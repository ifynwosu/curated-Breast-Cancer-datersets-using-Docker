
#save supplementary files to Directory and read into separate data frames
cancerTypeSamples <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE62944_06_01_15_TCGA_24_CancerType_Samples.txt.gz")
CancerType <- rownames(cancerTypeSamples) %>%
  read_tsv(col_names = F)
colnames(CancerType) <- c("Sampleid", "cancer_type")

#create a vector to replace the unknown variables with NA
na_strings <- c("[Unknown]", "[Not Available]", "[Not Evaluated]", "[Not Applicable]")
clinicalVariables <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE62944_06_01_15_TCGA_24_548_Clinical_Variables_9264_Samples.txt.gz")
Clinical_Variables <- rownames(clinicalVariables) %>%
  read_tsv(col_names = F, na = na_strings) %>%
  dplyr::select(- (X2:X3))

#rearrange Clinical_Variables
Transposed_df <- as_tibble(t(Clinical_Variables), stringsAsFactors = F)
Transposed_df[1, 1] <- "Sampleid"
Transposed_df <- row_to_names(Transposed_df, 1, remove_row = TRUE, remove_rows_above = TRUE)

#merge the data frames by Sampleid
Merged_df <- Transposed_df %>%
  inner_join(CancerType, by = "Sampleid")

#select breast cancer samples only, remove samples without an ID, and remove samples with only one value
BRCA <- Merged_df %>%
  dplyr::filter(Merged_df$cancer_type == "BRCA") %>%
  dplyr::filter(bcr_patient_uuid != "NA") %>%
  dplyr::select(-c("form_completion_date", "prospective_collection", "retrospective_collection", "tissue_source_site")) %>%
  remove_constant()
  # not sure if we should keep or discard these variables ("bcr_patient_barcode" "patient_id", "birth_days_to", "last_contact_days_to")
 
#calculate percentage of columns with missing data for easy visualisation
NA_cols <- as_tibble(colMeans(is.na(BRCA)), rownames = "variable") %>%
  pivot_wider(names_from = variable, values_from = value)
new_BRCA <- rbind(NA_cols, BRCA)

# keep columns with less than 50% NA
BRCA_filtered <- BRCA[, colMeans(is.na(BRCA)) < 0.5] %>%
  dplyr::rename(Sample_ID = Sampleid) %>%
  mutate(Dataset_ID = "GSE62944", .before = Sample_ID)

#summarise metadata variables
varSummary <- summariseVariables(BRCA_filtered)

if (nrow(varSummary$numSummary) >= 1) {
  write_tsv(varSummary$numSummary, file.path("/Data/metadata_summaries/GSE62944_TCGA_num.tsv"))
}

if (nrow(varSummary$charSummary) >= 1) {
  write_tsv(varSummary$charSummary, file.path("/Data/metadata_summaries/GSE62944_TCGA_char.tsv"))
}

print("Writing GSE62944 to file!")
write_tsv(BRCA_filtered, paste0(data_dir, "GSE62944_TCGA.tsv"))
