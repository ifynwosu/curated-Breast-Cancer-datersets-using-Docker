#This script parses, gene expression metadata

install.packages(c("tidyverse", "janitor"))
BiocManager::install("GEOquery", force = TRUE)

library(tidyverse)
library(janitor)
library(GEOquery)


df <- getFromGEO("GSE8977")

#some housekeeping
metadata <- df$metadata %>%
  removeUnusefulCols() %>%
  rename_with(~str_replace_all(., "_ch1", "")) %>%
  dplyr::select(-"description") %>%
  rename(tissue_source = characteristics) %>%
  rename(tissue_type = title) %>%
  mutate(tissue_type = "Stroma")

  mutate(across(tissue_type, ~str_replace(., ".\\*", "Stroma")))
  

GEO  <- read_tsv("/inwosu/Data/normalized_data/GSE10780.tsv.gz")
a <- read_tsv("/inwosu/Data/normalized_data/E_TABM_158.tsv.gz")
b <- read_tsv("/inwosu/Data/analysis_ready_metadata/E_TABM_158.tsv")

x <- colnames(a)

c <- read_tsv("/inwosu/Data/merged_metadata.tsv")


match_A <- etabm_158 %>%
  dplyr::select(c("Array Data File", "Source Name")) #%>%
  pivot_wider(names_from = `Array Data File`, values_from = `Source Name`)


#%>%
  t() #%>%
  as_tibble() %>%
  rownames_to_column() %>%
  row_to_names(2, remove_row = T, remove_rows_above = F) %>%
  rename("Gene" = "2")

match_A[0,1] = "Gene"

match_B <- as_tibble(colnames(a))

match_c <- full_join(match_A, match_B, by = c("Array Data File" = "value"), keep = T)

big <- bind_rows(match_A, a)

mydf <- data.frame(A = c(letters[1:10]), M1 = c(11:20), M2 = c(31:40), M3 = c(41:50))
