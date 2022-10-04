
#get ExpressionSet from GEO for "this" GEO tag, create data frame of relevant information
gseID <- getGEO("GSE81538")
df <- gseID[[1]]

metadata <- pData(df) %>%
  clean_names() %>%
  removeCols() %>%
  dplyr::select(-c("title", "description", "tissue_ch1")) %>%
  rename_with(~str_replace_all(., "_ch1", "")) %>%
  dplyr::rename(Sample_ID = geo_accession) %>%
  mutate(Dataset_ID = "GSE81538", .before = Sample_ID)

#summarise metadata variables
varSummary <- summariseVariables(metadata)

if (nrow(varSummary$numSummary) >= 1) {
  write_tsv(varSummary$numSummary, file.path("/Data/metadata_summaries/GSE81538_MSCANBI_Cohort405_HiSeq_num.tsv"))
}

if (nrow(varSummary$charSummary) >= 1) {
  write_tsv(varSummary$charSummary, file.path("/Data/metadata_summaries/GSE81538_MSCANBI_Cohort405_HiSeq_char.tsv"))
}

print("Writing GSE81538 to file!")
write_tsv(metadata, paste0(data_dir, "GSE81538_MSCANBI_Cohort405_HiSeq.tsv"))
