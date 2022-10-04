
library(tidyverse)
library(tools)
library(R.utils)
library(GEOquery)

datadir <- "/Data/normalized_data/"
file_paths <- list.files(datadir, full.names = T)
dual_arrays <- c("GSE1456_U133A", "GSE1456_U133B", "GSE3494_U133A", "GSE3494_U133B",
                  "GSE4922_U133A", "GSE4922_U133B", "GSE6532_U133A", "GSE6532_U133B", "GSE6532_U133_2")
missing_samples <- c("GSE118432", "GSE4611", "GSE5460")

for (file in file_paths) {
  gse_id <- basename(file) %>%
  file_path_sans_ext() %>%
  file_path_sans_ext()

  if (gse_id %in% dual_arrays) {
    next
  }
  if (gse_id %in% missing_samples) {
    next
  }

  out_file_path <- paste0("/Data/compare_norm_GEO/", gse_id, ".tsv")

  if (file.exists(out_file_path)) {
    print(paste0(gse_id, " has already been processed!"))
  } else {
      normalized_data <- read_tsv(file)
      colnames_norm <- normalized_data %>%
        dplyr::select(-Gene) %>%
        colnames()
      colnames_norm <- insert(colnames_norm, 1, gse_id) %>%
        as_tibble()

      print(paste0("Downloading ", gse_id, " for processing!"))
      GEOdata <- getGEO(gse_id)
      GEO_df <- GEOdata[[1]]
      GEO_expr <- exprs(GEO_df)
      colnames_GEO <- colnames(GEO_expr)
      colnames_GEO <- insert(colnames_GEO, 1, gse_id) %>%
        as_tibble()

      passing <- (colnames_norm == colnames_GEO)

      col_info <- cbind(colnames_norm, colnames_GEO, passing)

      write_tsv(col_info, out_file_path)
    }
}
