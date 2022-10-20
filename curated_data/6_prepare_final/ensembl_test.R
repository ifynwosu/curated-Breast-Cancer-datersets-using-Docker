
BiocManager::install("biomaRt")
BiocManager::install("GEOquery")
BiocManager::install("affy")

library(tidyverse)
library(biomaRt)
ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
library(GEOquery)
library(tools)

merged_metadata <- read_tsv("/inwosu/Data/merged_metadata.tsv")

datadir <- "/inwosu/Data/IQRray_filtered_data"
file_paths <- list.files(datadir, full.names = T)
file_paths
expr_file <- (file_paths[65])
expr_data <- read_tsv(expr_file)

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


special_cases <- c("GSE62944_TCGA_Tumor_Exp.tsv.gz", "GSE62944_TCGA_Normal_Exp.tsv.gz", "GSE81538_MSCANBI_Cohort405_HiSeq.tsv.gz", "GSE96058_MSCANBI_Cohort3273_HiSeq.tsv",
                  "GSE96058_MSCANBI_Cohort3273_HiSeq.tsv", "ICGC_BRCA_FR.tsv.gz", "ICGC_BRCA_KR.tsv.gz", "METABRIC_expr.tsv.gz")



