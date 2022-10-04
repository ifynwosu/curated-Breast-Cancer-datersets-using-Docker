
#download the patient data from this URL
download.file("https://media.githubusercontent.com/media/cBioPortal/datahub/master/public/brca_metabric/data_mrna_agilent_microarray_zscores_ref_diploid_samples.txt", 
              destfile = paste0(tmp_dir, "metabric_expr.txt"))

metaBric <- read_tsv(paste0(tmp_dir, "metabric_expr.txt"), comment = "#") %>%
  rename("Gene" = "Hugo_Symbol") %>%
  dplyr::select(-Entrez_Gene_Id)

print("Writing metabric to file!")
write_tsv(metaBric, paste0(data_dir, "METABRIC_expr.tsv.gz"))
