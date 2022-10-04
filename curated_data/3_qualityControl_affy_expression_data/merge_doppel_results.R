#combine all doppel files.
library(tidyverse)

out_file_dir <- "/Data/doppelgang_results"

#seperate on cols

#combine all doppelgang files
file_paths <- list.files(out_file_dir, pattern = "*.tsv", full.names = T)

merged_doppel <- read_tsv(file_paths) %>%
  select(sample1, sample2, expr.similarity) %>%
  separate(sample1, c("gseID_1", "sampleID_1"), sep = ":") %>%
  separate(sample2, c("gseID_2", "sampleID_2"), sep = ":") %>%
  filter(expr.similarity > 0.99) %>%
  distinct()
  
  
write_tsv(merged_doppel, "/Data/merged_doppelgang_results.tsv.gz")
