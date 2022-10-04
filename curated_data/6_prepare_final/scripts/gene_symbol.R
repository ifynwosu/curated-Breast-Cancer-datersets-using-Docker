
library(biomaRt)
library(tidyverse)
library(tools)

input_dir <- "/Data/IQRray_filtered_data"
file_paths <- list.files(input_dir, full.names = T)

cleaned_data_dir <- "/Data/gene_symbol_df/"
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
  gene_list <- getBM(attributes = c("entrezgene_id", "ensembl_gene_id", "hgnc_symbol", "gene_biotype"),
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

  #write file
  write_tsv(gene_df, out_file_path)

}