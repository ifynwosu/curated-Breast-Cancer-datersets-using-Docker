
#fetch RAW file from GEO and store in dataDir
GSE <- getGEOSuppFiles(GEO = "GSE62944", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE62944_RAW.tar")

#unzip the tar file for access to internal files
tmp <- rownames(GSE)
untar(tmp[1], exdir = tmp_dir)

#Process tumor gene expression data
cancerTypeSamples <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE62944_06_01_15_TCGA_24_CancerType_Samples.txt.gz")
CancerType <- rownames(cancerTypeSamples) %>%
  read_tsv(col_names = F)
colnames(CancerType) <- c("Sampleid", "cancer_type")

GSE62944_tumor_expr <- read_tsv(paste0(tmp_dir, "GSM1536837_06_01_15_TCGA_24.tumor_Rsubread_TPM.txt.gz"), col_names = F)

#rearrange tumor dataframe
Transposed_tumor <- as.data.frame(t(GSE62944_tumor_expr), stringsAsFactors = F)
Transposed_tumor[1, 1] <- "Sampleid"
Header <- Transposed_tumor[1, ]
colnames(Transposed_tumor) <- Header
Transposed_df <- Transposed_tumor[-c(1), ]

# #rearrange Clinical_Variables
# Transposed_df <- as.data.frame(t(Clinical_Variables), stringsAsFactors = F)
# Transposed_df[1, 1] <- "Sampleid"
# Transposed_df <- row_to_names(Transposed_df, 1, remove_row = TRUE, remove_rows_above = TRUE)

# #merge the data frames by Sampleid
# Merged_df <- Transposed_df %>%
#   inner_join(CancerType, by = "Sampleid")

Merged_df_tumor <- Transposed_tumor %>%
  inner_join(CancerType, by = "Sampleid") %>%
  dplyr::filter(cancer_type == "BRCA")

GSE62944_tumor_data <- t(Merged_df_tumor)
Header <- GSE62944_tumor_data[1, ]
colnames(GSE62944_tumor_data) <- Header

GSE62944_tumor_data <- GSE62944_tumor_data %>%
  as_tibble(rownames = "Gene")
GSE62944_tumor_data <- GSE62944_tumor_data[-c(1), ]

# Process normal gene expression data
normalTypeSamples <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE62944_06_01_15_TCGA_24_Normal_CancerType_Samples.txt.gz")
normalType <- rownames(normalTypeSamples) %>%
  read_tsv(col_names = F)
colnames(normalType) <- c("Sampleid", "cancer_type")

GSE62944_normal_expr <- read_tsv(paste0(tmp_dir, "GSM1697009_06_01_15_TCGA_24.normal_Rsubread_TPM.txt.gz"), col_names = F)

#rearrange normal dataframe
Transposed_normal <- as.data.frame(t(GSE62944_normal_expr), stringsAsFactors = F)
Transposed_normal[1, 1] <- "Sampleid"
Header <- Transposed_normal[1, ]
colnames(Transposed_normal) <- Header
Transposed_normal <- Transposed_normal[-c(1), ]

Merged_df_normal <- Transposed_normal %>%
  inner_join(normalType, by = "Sampleid") %>%
  dplyr::filter(cancer_type == "BRCA")

GSE62944_normal_data <- t(Merged_df_normal)
Header <- GSE62944_normal_data[1, ]
colnames(GSE62944_normal_data) <- Header

GSE62944_normal_data <- GSE62944_normal_data %>%
  as_tibble(rownames = "Gene")
GSE62944_normal_data <- GSE62944_normal_data[-c(1), ]

print("Writing GSE62944 to file!")
write_tsv(GSE62944_tumor_data, paste0(data_dir, "GSE62944_TCGA_Tumor_Exp.tsv.gz"))
write_tsv(GSE62944_normal_data, paste0(data_dir, "GSE62944_TCGA_Normal_Exp.tsv.gz"))
