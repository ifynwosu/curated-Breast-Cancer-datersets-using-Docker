
#get ExpressionSet from GEO for "this" GEO tag, create data frame of relevant information
gseID <- getGEO("GSE96058")

df_1 <- gseID[[1]]

#pull phenotype data from GEO data frame
metadata_1 <- pData(df_1) %>%
  clean_names() %>%
  removeCols() %>%
  rename_with(~str_replace_all(., "_ch1", "")) %>%
  dplyr::select(-c(title, description, `scan_b_external_id`)) %>%
  dplyr::rename(Sample_ID = geo_accession) %>%
  mutate(Dataset_ID = "GSE96058", .before = Sample_ID)

cols_to_change <- c("er_status", "pgr_status", "her2_status", "ki67_status")

metadata_1 <- metadata_1 %>%
  mutate_at(all_of(cols_to_change), ~ str_replace(., "0", "negative")) %>%
  mutate_at(all_of(cols_to_change), ~ str_replace(., "1", "positive"))

#summarise metadata variables
varSummary <- summariseVariables(metadata_1)

if (nrow(varSummary$numSummary) >= 1) {
  write_tsv(varSummary$numSummary, file.path("/Data/metadata_summaries/GSE96058_MSCANBI_Cohort3273_HiSeq_num.tsv"))
}

if (nrow(varSummary$charSummary) >= 1) {
  write_tsv(varSummary$charSummary, file.path("/Data/metadata_summaries/GSE96058_MSCANBI_Cohort3273_HiSeq_char.tsv"))
}

df_2 <- gseID[[2]]

#pull phenotype data from GEO data frame
metadata_2 <- pData(df_2) %>%
  clean_names() %>%
  removeCols() %>%
  rename_with(~str_replace_all(., "_ch1", "")) %>%
  dplyr::select(-c(title, description, `scan_b_external_id`)) %>%
  dplyr::rename(Sample_ID = geo_accession) %>%
  mutate(Dataset_ID = "GSE96058", .before = Sample_ID)

metadata_2 <- metadata_2 %>%
  mutate_at(all_of(cols_to_change), ~ str_replace(., "0", "negative")) %>%
  mutate_at(all_of(cols_to_change), ~ str_replace(., "1", "positive"))

#summarise metadata variables
varSummary <- summariseVariables(metadata_2)

if (nrow(varSummary$numSummary) >= 1) {
  write_tsv(varSummary$numSummary, file.path("/Data/metadata_summaries/GSE96058_MSCANBI_Cohort3273_NextSeq_num.tsv"))
}

if (nrow(varSummary$charSummary) >= 1) {
  write_tsv(varSummary$charSummary, file.path("/Data/metadata_summaries/GSE96058_MSCANBI_Cohort3273_NextSeq_char.tsv"))
}

print("Writing GSE96058 to file!")
write_tsv(metadata_1, paste0(data_dir, "GSE96058_MSCANBI_Cohort3273_HiSeq.tsv"))
write_tsv(metadata_2, paste0(data_dir, "GSE96058_MSCANBI_Cohort3273_NextSeq.tsv"))
