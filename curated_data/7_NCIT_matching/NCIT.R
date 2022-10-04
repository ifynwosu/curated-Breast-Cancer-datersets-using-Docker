## Load libraries

library(tidyverse, warn.conflicts = FALSE)
options(tidyverse.quiet = TRUE) 
options(dplyr.summarise.inform = FALSE)
library(tidytext) # https://www.tidytextmining.com/index.html
data(stop_words)
library(stringdist)
library(readxl)
library(writexl)
library(knitr)

## Read TSV file
#TODO: Change the file name and column names used here.
data <- read_tsv("/Data/test_files/merged_summary.tsv") %>%
  dplyr::select(Variable) %>%
  mutate(variable_cleaned = tolower(Variable)) %>%
  mutate(variable_cleaned = str_trim(variable_cleaned)) %>%
  distinct()

## Obtain data from NCI Thesaurus
# 1. Download NCIT in CSV format and read into a tibble.
# 2. Split the synonyms into separate rows.

tmp_file_path <- "NCIT_22.04d.csv.gz"

if (!file.exists(tmp_file_path))
  download.file("https://data.bioontology.org/ontologies/NCIT/download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb&download_format=csv", tmp_file_path)

ncit_data <- read_csv(tmp_file_path) %>%
  filter(!Obsolete) %>%
  dplyr::rename(Preferred = `Preferred Label`) %>%
  dplyr::rename(Synonym = Synonyms) %>%
  dplyr::rename(Definition = DEFINITION) %>%
  select(Preferred, Synonym, Definition)

ncit_preferred <- select(ncit_data, Preferred) %>%
  mutate(PreferredLowerCase = tolower(Preferred))

ncit_synonyms <- separate_rows(ncit_data, Synonym, sep = " ?\\| ?") %>%
  mutate(SynonymLowerCase = tolower(Synonym)) %>%
  distinct()

## Match against NCI Thesaurus synonyms - stringdist

# The input argument is a vector of (string) terms. This function creates a "clean" version
# of each term. "Stop words" are removed, as well as some punctuation or extra white space.
build_term_tibble = function(terms) {
  terms_df = tibble(term = terms) %>%
    unnest_tokens(word, term, drop = FALSE) %>%
    anti_join(stop_words) %>%
    dplyr::rename(original_term = term) %>%
    distinct() %>%
    group_by(original_term) %>%
    summarize(cleaned_term = paste(word, collapse = " ")) %>%
    ungroup() %>%
    group_by(cleaned_term) %>%
    summarize(original_term = collapse_terms(original_term)) %>%
    ungroup() %>%
    select(original_term, cleaned_term)

  return(terms_df)
}

# When a cleaned term is the same for two original terms,
# collapse them as |-separated values.
collapse_terms = function(terms) {
  paste0(unique(terms), collapse = "|")
}

ncit_synonym_terms <- pull(ncit_synonyms, SynonymLowerCase) %>%
  unique()
#TODO: Change column name used here
data_names <- pull(data, variable_cleaned) %>%
  unique()

# Create a list that has each synonym (which includes the preferred term) as a key/name and the relevant preferred term as a value.
ncit_list <- as.list(pull(ncit_synonyms, Preferred))
names(ncit_list) <- pull(ncit_synonyms, SynonymLowerCase)

# Build tibbles with "clean" terms alongside the input terms.
data_tibble <- build_term_tibble(data_names)
ncit_tibble <- build_term_tibble(ncit_synonym_terms)

# Use the stringdist package to map the test terms to the ontology terms (including synonyms).
# Use the Jaro-Winkler (jw) method.
start_time <- Sys.time()
data_sdm <- stringdistmatrix(pull(ncit_tibble, cleaned_term), pull(data_tibble, cleaned_term), method = "jw", p = 0.1)

# We get a matrix back. Convert it to a tibble and label columns descriptively.
colnames(data_sdm) <- pull(data_tibble, original_term)
data_sdm <- as_tibble(data_sdm)
data_sdm <- bind_cols(pull(ncit_tibble, original_term), data_sdm, .name_repair = "minimal")
colnames(data_sdm)[1] <- "Ontology_Term"

# Create a tidy version of the results. It includes steps for un-collapsing terms that were combined in previous steps and making the results easier to work with.
data_sdm_tidy <- pivot_longer(data_sdm, 2:ncol(data_sdm), names_to = "Test_Term", values_to = "Score") %>%
  group_by(Test_Term) %>%
  slice_min(n = 3, order_by = Score) %>%
  separate_rows(Ontology_Term, sep = "\\|") %>%
  mutate(Ontology_Term = sapply(Ontology_Term, function(x) {ncit_list[[x]]})) %>%
  separate_rows(Test_Term, sep = "\\|") %>%
  group_by(Test_Term, Ontology_Term) %>%
  summarize(Score = min(Score)) %>%
  inner_join(ncit_data, by = c("Ontology_Term" = "Preferred")) %>%
  select(Test_Term, Ontology_Term, Definition, Score) %>%
  dplyr::rename(Ontology_Term_Definition = Definition) %>%
  arrange(Test_Term, Score)

duration = Sys.time() - start_time
print("#############################")
print(duration)
print("#############################")

## Prepare Excel spreadsheet so that curators can review the data
# We'll pull the top 3 matches for each unique data name.
# If there are ties, we retain all tied values, even if that results in more than 3 matches.

#TODO: Not sure if this part of the code will be helpful. I didn't really update it.

curation_output <- data_sdm_tidy %>%
  dplyr::rename(Breast_Cancer_variable = Test_Term) %>%
  mutate(Breast_Cancer_variable = tolower(Breast_Cancer_variable)) %>%
  distinct() %>%
  arrange(Breast_Cancer_variable, Ontology_Term)

unique_drug_names <- select(curation_output, Breast_Cancer_variable) %>%
  distinct() %>%
  rowid_to_column()

inner_join(curation_output, unique_drug_names) %>%
  dplyr::rename(ID = rowid) %>%
  select(ID, Breast_Cancer_variable, Ontology_Term, Ontology_Term_Definition, Score) %>%
  arrange(ID, Score, Ontology_Term) %>%
  mutate(`Best?` = "N") %>%
  mutate(`Better_Alternative_Term?` = "") %>%
  mutate(`Note` = "") %>%
  write_xlsx("/Data/Metadata_variables.xlsx")
