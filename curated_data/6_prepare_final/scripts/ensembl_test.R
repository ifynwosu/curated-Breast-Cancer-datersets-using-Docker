small_file <- read_tsv("/inwosu/Data/merged_doppelgang_results.tsv.gz")

out_file_dir <- "/inwosu/Data/doppelgang_results"

#combine all doppelgang files
file_paths <- list.files(out_file_dir, pattern = "*.tsv", full.names = T)
merged_dopple <- read_tsv(file_paths) %>%
  select(sample1, sample2, expr.similarity) %>%
  separate(sample1, c("gseID_1", "sampleID_1"), sep = ":") %>%
  separate(sample2, c("gseID_2", "sampleID_2"), sep = ":") %>%
  filter(expr.similarity > 0.99) %>%
  distinct()  

write_tsv(filtered_dopple, "doppelgang_results.tsv.gz")

################################################################################################

GSE10780:GSM272147
# Read in data TSV file
metadata <-  read_tsv("/inwosu/Data/analysis_ready_metadata/E_TABM_158.tsv")

cols_to_selecct <- metadata$Sample_ID



# Read in data TSV file
df<- read_tsv("/inwosu/Data/gene_symbol_df/E_TABM_158.tsv.gz") 

for (df_name in names(df)[5:(length(names(df)))]) {
  
  print(df_name)
}

names(df)


# Make the data in the order of the metadata
df <- df %>%
  dplyr::select(metadata$Sample_ID)



#################################################################################################


BiocManager::install("biomaRt")
install.packages("tidyverse")
library(biomaRt)
library(tidyverse)
library(tools)

datadir <- "/inwosu/Data/HGNC_df/"
file_paths <- list.files(datadir, full.names = T)
expr_file <- (file_paths[2])
expr_data <- read_tsv(expr_file)


cleaned_data_dir <- "/Data/HGNC_df/"
if (!dir.exists(cleaned_data_dir)) {
  dir.create(cleaned_data_dir)
}

ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")

geneSymbol <- function(expr_file) {
  expr_data <- read_tsv(expr_file)
  new_df <- mutate(expr_data, across(Gene, ~str_replace(., "_at", ""))) %>%
            mutate(across(Gene, as.integer))
  entrez_ID <- (new_df$Gene)
  
  #match gene ids to ensemble database
  gene_list <- getBM(attributes= c("entrezgene_id", "ensembl_gene_id", "hgnc_symbol", "gene_biotype"),
                     filters = "entrezgene_id",
                     values = entrez_ID,
                     mart = ensembl) %>%
                     rename(Gene = entrezgene_id)
  big_df <- full_join(gene_list, new_df, by = "Gene") %>%
    dplyr::select(Dataset, everything())
  
  
  return(big_df)
}


for (file in file_paths) {
  file_name <- file %>% basename() %>% file_path_sans_ext()
  out_file_path <- paste0(cleaned_data_dir, file_name, ".gz")
  
  #call function
  gene_df <- geneSymbol(file)
  stop("got here")
  
  #write file
  write_tsv(gene_df, out_file_path)
  
}



