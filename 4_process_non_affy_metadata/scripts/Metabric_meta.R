
# download the patient data from this URL
download.file("https://osf.io/download/ubcej/",
              destfile = paste0(tmp_dir, "metabric_meta.txt"))

metabric <- read_tsv(paste0(tmp_dir, "metabric_meta.txt")) 

# write un-curated metadata to file
write_tsv(metabric, file.path(raw_metadata_dir, "METABRIC.tsv"))

metabric <- read_tsv(paste0(tmp_dir, "metabric_meta.txt"), comment = "#")  %>%
  dplyr::rename(Sample_ID = PATIENT_ID) %>%
  mutate(Dataset_ID = "METABRIC", .before = Sample_ID) %>%
  mutate(Platform_ID = "GPL6947", .after = Sample_ID) %>%
  dplyr::select(-INTCLUST)

# summarise metadata variables
varSummary <- summariseVariables(metabric)

if (nrow(varSummary$numSummary) >= 1) {
  write_tsv(varSummary$numSummary, file.path("/Data/metadata_summaries/METABRIC_num.tsv"))
}

if (nrow(varSummary$charSummary) >= 1) {
  write_tsv(varSummary$charSummary, file.path("/Data/metadata_summaries/METABRIC_char.tsv"))
}

print("Writing METABRIC to file!")
write_tsv(metabric, paste0(data_dir, "METABRIC.tsv"))
