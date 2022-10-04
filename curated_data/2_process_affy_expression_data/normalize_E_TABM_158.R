library(SCAN.UPC)
library(doParallel)
library(tidyverse)
library(janitor)

# enable parralelization
registerDoParallel(cores = 16)

# Create the normalized data folder if it doesn't exist
normalized_data <- "/Data/normalized_data/"
if (!dir.exists(normalized_data)) {
    dir.create(normalized_data)
}

base_dir <- "E-TABM-158"
unlink(base_dir, recursive = TRUE)
if (!dir.exists(base_dir)) {
  dir.create(base_dir)
}

tmp_dir <- "tmp/"
unlink(tmp_dir, recursive = TRUE)
if (!dir.exists(tmp_dir)) {
  dir.create(tmp_dir)
}

# download metadata file
download.file("https://www.ebi.ac.uk/arrayexpress/files/E-TABM-158/E-TABM-158.sdrf.txt",
              destfile = paste0(tmp_dir, "ETABM_158_meta.txt"))

# download expression files
download.file("https://www.ebi.ac.uk/arrayexpress/files/E-TABM-158/E-TABM-158.raw.1.zip",
              destfile = paste0(base_dir, "/E_TABM_1.zip"), method = "wget")

download.file("https://www.ebi.ac.uk/arrayexpress/files/E-TABM-158/E-TABM-158.raw.2.zip",
              destfile = paste0(base_dir, "/E_TABM_2.zip"), method = "wget")

download.file("https://www.ebi.ac.uk/arrayexpress/files/E-TABM-158/E-TABM-158.raw.3.zip",
              destfile = paste0(base_dir, "/E_TABM_3.zip"), method = "wget")

zip_file <- list.files(base_dir, pattern = "*.zip", full.names = T)

for (file in zip_file) {
  unzip(file, exdir = base_dir)
}

celFilePaths <- list.files(base_dir, pattern = "*.CEL", full.names = T, ignore.case = T)

all_normalized <- NULL

for (celFilePath in celFilePaths) {

  normalized <- exprs(SCAN(celFilePath, annotationPackageName = "pd.ht.hg.u133a", probeSummaryPackage = "u133aaofav2hsentrezgprobe"))
  normalized <- as_tibble(normalized, rownames = "Gene")

  if (is.null(all_normalized)) {
    all_normalized <- normalized
  } else {
    all_normalized <- inner_join(all_normalized, normalized, by = "Gene")
  }
}

## The sections below change the column names to match metadata

# read the normalized expression data file into a table
ETABM_expr <- all_normalized %>%
  mutate(across(where(is.double), as.character))
expr_col <- colnames(ETABM_expr) %>% as_tibble()
names(expr_col) <- "Array Data File"

#read the sample and data relationship file into a table
ETABM_meta <- read_tsv(paste0(tmp_dir, "ETABM_158_meta.txt"))
meta_col <- ETABM_meta %>%
  dplyr::select(c("Array Data File", "Source Name"))

# this variable is just to view visually the bound colums and make sure they match
joint_cols_full <- full_join(expr_col, meta_col, keep = T)

joint_cols <- full_join(expr_col, meta_col) %>%
    t() %>%
    row_to_names(1) %>%
    as_tibble()
joint_cols[1, 1] <- "Gene"

new_df <- bind_rows(joint_cols, ETABM_expr) %>%
    row_to_names(1)
  
out_file_path <- "/Data/normalized_data/E_TABM_158.tsv.gz"

write_tsv(new_df, out_file_path)
print(paste0("Saved E_TABM_158 to ", out_file_path))

unlink(base_dir, recursive = TRUE, force = TRUE)
unlink(tmp_dir, recursive = TRUE, force = TRUE)