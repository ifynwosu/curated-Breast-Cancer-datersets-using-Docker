

# Download and save file
download.file("https://dcc.icgc.org/api/v1/download?fn=/current/Projects/BRCA-FR/exp_array.BRCA-FR.tsv.gz",
              destfile = paste0(tmp_dir, "exp_array_BRCA_FR.tsv.gz"))
exp_array_BRCA_FR <- read_tsv(paste0(tmp_dir, "exp_array_BRCA_FR.tsv.gz"))

# clean up data
BRCA_FR <- exp_array_BRCA_FR %>%
  rename("gene_symbol" = "gene_id") %>%
  dplyr::select(icgc_donor_id, gene_symbol, normalized_expression_value) %>%
  pivot_wider(names_from = icgc_donor_id, values_from = normalized_expression_value)

print("Writing BRCA_FR to file!")
write_tsv(BRCA_FR, paste0(data_dir, "ICGC_BRCA_FR.tsv.gz"))
