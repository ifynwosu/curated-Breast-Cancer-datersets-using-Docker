
#fetch RAW file from GEO and store in dataDir
GSE <- getGEOSuppFiles(GEO = "GSE62944", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE62944_RAW.tar")

# #unzip the tar file for access to internal files
strorage_dir <- rownames(GSE)
untar(strorage_dir[1], exdir = tmp_dir)

GSE62944_tumor_df <- read_tsv(paste0(tmp_dir, "GSM1536837_06_01_15_TCGA_24.tumor_Rsubread_TPM.txt.gz"), col_names = F)
#GSE62944_tumor_df <- read_tsv("/inwosu/Data/GSE62944_data/GSM1536837_06_01_15_TCGA_24.tumor_Rsubread_TPM.txt.gz", col_names = F)


#Process tumor gene expression data
CancerType <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE62944_06_01_15_TCGA_24_CancerType_Samples.txt.gz")
cancerTypeSamples <- rownames(CancerType) %>%
  read_tsv(col_names = F)
colnames(cancerTypeSamples) <- c("Sample_ID", "cancer_type")


#rearrange tumor dataframe
Transposed_tumor_expr <- as.data.frame(t(GSE62944_tumor_df), stringsAsFactors = F)
Transposed_tumor_expr[1, 1] <- "Sample_ID"
Transposed_tumor_expr <- row_to_names(Transposed_tumor_expr, 1, remove_row = TRUE, remove_rows_above = TRUE)

Merged_tumor_df <- Transposed_tumor_expr %>%
  inner_join(cancerTypeSamples, by = "Sample_ID") %>%
  dplyr::filter(cancer_type == "BRCA")

GSE62944_tumor_data <- t(Merged_tumor_df) %>%
  row_to_names(1, remove_row = TRUE, remove_rows_above = TRUE) %>%
  as_tibble(rownames = "HGNC_Symbol")

# Process normal gene expression data
normalTypeSamples <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE62944_06_01_15_TCGA_24_Normal_CancerType_Samples.txt.gz")
normalType <- rownames(normalTypeSamples) %>%
  read_tsv(col_names = F)
colnames(normalType) <- c("Sample_ID", "cancer_type")

GSE62944_normal_df <- read_tsv(paste0(tmp_dir, "GSM1697009_06_01_15_TCGA_24.normal_Rsubread_TPM.txt.gz"), col_names = F)
#GSE62944_normal_df <- read_tsv("/inwosu/Data/GSE62944_data/GSM1697009_06_01_15_TCGA_24.normal_Rsubread_TPM.txt.gz", col_names = F)

#rearrange normal dataframe
Transposed_normal <- as.data.frame(t(GSE62944_normal_df), stringsAsFactors = F)
Transposed_normal[1, 1] <- "Sample_ID"
Transposed_normal <- row_to_names(Transposed_normal, 1, remove_row = TRUE, remove_rows_above = TRUE)

Merged_df_normal <- Transposed_normal %>%
  inner_join(normalType, by = "Sample_ID") %>%
  dplyr::filter(cancer_type == "BRCA")

GSE62944_normal_data <- t(Merged_df_normal) %>%
  row_to_names(1, remove_row = TRUE, remove_rows_above = TRUE) %>%
  as_tibble(rownames = "HGNC_Symbol")

print("Writing GSE62944 to file!")
write_tsv(GSE62944_tumor_data, paste0(data_dir, "GSE62944_TCGA_Tumor.tsv.gz"))
write_tsv(GSE62944_normal_data, paste0(data_dir, "GSE62944_TCGA_Normal.tsv.gz"))
