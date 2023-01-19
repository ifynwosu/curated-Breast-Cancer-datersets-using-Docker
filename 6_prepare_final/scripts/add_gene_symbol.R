file_paths <- list.files(meta_expr_matched_data, full.names = T)

special_cases <- c("GSE62944_Tumor.tsv", "GSE62944_Normal.tsv", "GSE81538.tsv", "GSE96058_HiSeq.tsv",
                   "GSE96058_NextSeq.tsv", "ICGC_FR.tsv", "ICGC_KR.tsv", "METABRIC.tsv")

# Specify a BioMart database and a specific dataset inside the database.
ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")

rename_df <- function(expr_file) {
  df <- expr_file %>%
    rename(Dataset_ID = Dataset) %>%
    rename(Entrez_Gene_ID = entrezgene_id) %>%
    rename(Ensembl_Gene_ID = ensembl_gene_id) %>%
    rename(HGNC_Symbol = hgnc_symbol) %>%
    rename(Gene_Biotype = gene_biotype)

  return(df)
}

entrez_geneSymbol <- function(expr_file) {
  expr_data <- read_tsv(expr_file)
  new_df <- mutate(expr_data, across(Gene, ~str_replace(., "_at", ""))) %>%
            mutate(across(Gene, as.integer)) %>%
            rename(entrezgene_id = Gene)
  entrez_ID <- (new_df$entrezgene_id)

  #match gene ids to ensemble database
  gene_list <- getBM(attributes = c("entrezgene_id", "ensembl_gene_id", "hgnc_symbol", "gene_biotype"),
                     filters = "entrezgene_id",
                     values = entrez_ID,
                     mart = ensembl) %>%
                mutate(across(entrezgene_id, as.integer))

  big_df <- full_join(gene_list, new_df, by = "entrezgene_id") %>%
    dplyr::select(Dataset, everything())

  big_df <- rename_df(big_df)

  return(big_df)
}

HGNC_geneSymbol <- function(expr_file) {
  expr_data <- read_tsv(expr_file) %>%
    rename(hgnc_symbol = HGNC)
  HGNC_ID <- (expr_data$hgnc_symbol)

  #match gene ids to ensemble database
  gene_list <- getBM(attributes = c("entrezgene_id", "ensembl_gene_id", "hgnc_symbol", "gene_biotype"),
                     filters = "hgnc_symbol",
                     values = HGNC_ID,
                     mart = ensembl)

  big_df <- full_join(gene_list, expr_data, by = "hgnc_symbol") %>%
    dplyr::select(Dataset, everything())

  big_df <- rename_df(big_df)

  return(big_df)
}

for (file in file_paths) {
  cat("\n")
  print(paste0("Reading in ", file, "!"))
  cat("\n")

  file_name <- file %>% basename() %>% file_path_sans_ext()
  out_file_path <- paste0(analysis_ready_data, file_name, ".gz")

  if (file_name %in% special_cases) {
    gene_df <- HGNC_geneSymbol(file)
  } else {
    gene_df <- entrez_geneSymbol(file)
  }

  gene_df <-gene_df[order(gene_df$Entrez_Gene_ID),]
  
  write_tsv(gene_df, out_file_path)
}