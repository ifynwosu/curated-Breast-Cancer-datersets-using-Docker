library(tidyverse)
#clean up expression data names

datadir <- "/Data/normalized_data"
file_paths <- list.files(datadir, full.names = T)

cleaned_data_dir <- "/Data/expr_data_clean_colnames/"
if (!dir.exists(cleaned_data_dir)) {
  dir.create(cleaned_data_dir)
}

# remove extra characters in column names
for (file in file_paths) {
  gseID <- basename(file)
  gseID <- gsub(".tsv.gz", "", gseID)
  expr_data <- read_tsv(file) %>%
                  mutate(Dataset_ID = gseID, .before = Gene) %>%
                  filter(!str_detect(Gene, "^AFFX"))
  names(expr_data) <- gsub("_.+", "", names(expr_data))
  write_tsv(expr_data, paste0(cleaned_data_dir, gseID, ".tsv.gz"))
}
