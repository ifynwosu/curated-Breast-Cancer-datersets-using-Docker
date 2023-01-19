#BRCA_FR

download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-FR/donor.BRCA-FR.tsv.gz",
              destfile = paste0(tmp_dir, "donor.BRCA-FR.tsv.gz"))
donor_BRCA_FR <- read_tsv(paste0(tmp_dir, "donor.BRCA-FR.tsv.gz")) %>%
  dplyr::select(-c(project_code, study_donor_involved_in, submitted_donor_id, donor_tumour_staging_system_at_diagnosis,
  donor_tumour_stage_at_diagnosis_supplemental, cancer_type_prior_malignancy))


download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-FR/donor_exposure.BRCA-FR.tsv.gz",
              destfile = paste0(tmp_dir, "donor_exposure.BRCA-FR.tsv.gz"))
donor_exposure_BRCA_FR <- read_tsv(paste0(tmp_dir, "donor_exposure.BRCA-FR.tsv.gz")) %>%
  dplyr::select(-c(project_code, submitted_donor_id, exposure_type, exposure_intensity, alcohol_history, alcohol_history_intensity))


download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-FR/donor_family.BRCA-FR.tsv.gz",
              destfile = paste0(tmp_dir, "donor_family.BRCA-FR.tsv.gz"))
donor_family_BRCA_FR <- read_tsv(paste0(tmp_dir, "donor_family.BRCA-FR.tsv.gz")) %>%
  dplyr::select(-c(project_code, submitted_donor_id, relationship_type_other))


download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-FR/donor_therapy.BRCA-FR.tsv.gz",
              destfile = paste0(tmp_dir, "donor_therapy.BRCA-FR.tsv.gz"))
donor_therapy_BRCA_FR <- read_tsv(paste0(tmp_dir, "donor_therapy.BRCA-FR.tsv.gz")) %>%
  dplyr::select(-c(project_code, submitted_donor_id, first_therapy_response))


download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-FR/specimen.BRCA-FR.tsv.gz",
              destfile = paste0(tmp_dir, "specimen.BRCA-FR.tsv.gz"))

specimen_BRCA_FR <- read_tsv(paste0(tmp_dir, "specimen.BRCA-FR.tsv.gz")) %>%
  dplyr::filter(specimen_type == "Primary tumour - solid tissue") %>%
  dplyr::select(-c(icgc_specimen_id, project_code, study_specimen_involved_in, submitted_specimen_id, submitted_donor_id, specimen_type_other,
                   specimen_interval, specimen_donor_treatment_type_other, specimen_processing, specimen_processing_other, specimen_storage,
                   specimen_storage_other, tumour_confirmed, specimen_biobank, specimen_biobank_id, specimen_available, tumour_histological_type,
                   tumour_grade_supplemental, tumour_stage_supplemental, digital_image_of_stained_section, percentage_cellularity, 
                   specimen_type, specimen_donor_treatment_type))

download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-FR/exp_array.BRCA-FR.tsv.gz",
              destfile = paste0(tmp_dir, "exp_array.BRCA-FR.tsv.gz"))
exp_array_BRCA_FR <- read_tsv(paste0(tmp_dir, "exp_array.BRCA-FR.tsv.gz"))


BRCA_FR <- exp_array_BRCA_FR %>%
  dplyr::select(icgc_donor_id) %>%
  distinct() %>%
  pull(icgc_donor_id)

combined_df <- list(donor_BRCA_FR, donor_exposure_BRCA_FR, donor_family_BRCA_FR, donor_therapy_BRCA_FR, specimen_BRCA_FR) %>%
  reduce(full_join, by = "icgc_donor_id") %>%
  dplyr::select(-starts_with(c("relationship_", "donor_diagnosis_icd10", "first_therapy_therapeutic_intent", 
                               "other_therapy_response", "second_therapy_response", "second_therapy_therapeutic_intent"))) %>%
  distinct() %>%
  dplyr::filter(icgc_donor_id %in% BRCA_FR) %>%
  dplyr::rename(Sample_ID = icgc_donor_id) %>%
  mutate(Dataset_ID = "ICGC_FR", .before = Sample_ID) %>%
  mutate(Platform_ID = "GPL570", .after = Sample_ID)

#summarise metadata variables
varSummary <- summariseVariables(combined_df)

if (nrow(varSummary$numSummary) >= 1) {
  write_tsv(varSummary$numSummary, file.path("/Data/metadata_summaries/ICGC_FR_num.tsv"))
}

if (nrow(varSummary$charSummary) >= 1) {
  write_tsv(varSummary$charSummary, file.path("/Data/metadata_summaries/ICGC_FR_char.tsv"))
}

print("Writing ICGC_FR to file!")
write_tsv(combined_df, paste0(data_dir, "ICGC_FR.tsv"))
