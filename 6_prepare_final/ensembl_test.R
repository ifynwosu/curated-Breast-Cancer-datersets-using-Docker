
library(tidyverse)

install.packages("janitor")

BiocManager::install("GEOquery")
BiocManager::install("biomaRt")
BiocManager::install("affy")

library(janitor)
library(tools)
library(GEOquery)
library(biomaRt)
library(affy)

ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")

expr_data <- read_tsv("/inwosu/curated_data/Data/expression_data/GSE1456_U133A.tsv.gz")

datadir <- "/inwosu/curated_data/Data/analysis_ready_expression_data/"
file_paths <- list.files(datadir, full.names = T)
file_paths
file <- (file_paths[82])

expr_file <- (file_paths[40])
expr_data <- read_tsv(expr_file) #%>%
  mutate(Dataset_ID = "GSE2990", .before = everything()) %>%
  filter(!str_detect(Gene, "^AFFX"))
  
  
  
  gseID <- basename(file)
  gseID <- gsub(".tsv.gz", "", gseID)

gene_df <- geneSymbol(expr_file)


for (file in file_paths) {
  file_name <- file %>% basename() %>% file_path_sans_ext()
  out_file_path <- paste0(cleaned_data_dir, file_name, ".gz")
  
  #call function
  gene_df <- geneSymbol(file)
  stop("got here")
  
  #write file
  write_tsv(gene_df, out_file_path)
  
}

BiocManager::install(c("affy", "AnnotationDbi", "Biobase", "oligo"), force = TRUE)


