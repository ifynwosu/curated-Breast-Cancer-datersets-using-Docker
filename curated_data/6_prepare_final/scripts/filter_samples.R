library(tidyverse)
library(tools)

IQRray_dir <- "/Data/IQRray_results"
input_dir <- "/Data/expr_data_clean_colnames"

cleaned_data_dir <- "/Data/IQRray_filtered_data/"
if (!dir.exists(cleaned_data_dir)) {
  dir.create(cleaned_data_dir)
}

huExon <- read_tsv(paste0(IQRray_dir, "/huExon.tsv")) %>%
  mutate(Platform = "HuEx") %>%
  mutate(Passing = TRUE)

huGene <- read_tsv(paste0(IQRray_dir, "/huGene.tsv")) %>%
  mutate(Platform = "HuGene") %>%
  mutate(Passing = TRUE)

U95_2 <- read_tsv(paste0(IQRray_dir, "/U95_2.tsv")) %>%
  mutate(Platform = "U95v2") %>%
  mutate(Passing = value > 45759.6835)

U133_A_Early_Access <- read_tsv(paste0(IQRray_dir, "/U133A_Early_Access.tsv")) %>%
  mutate(Platform = "U133A") %>%
  mutate(Passing = value > 53812.1375)

U133_A <- read_tsv(paste0(IQRray_dir, "/U133_A.tsv")) %>%
  mutate(Platform = "U133A") %>%
  mutate(Passing = value > 53812.1375)

U133_A2 <- read_tsv(paste0(IQRray_dir, "/U133_A2.tsv")) %>%
  mutate(Platform = "U133A2") %>%
  mutate(Passing = value > 66795.84023)

U133_plus_2 <- read_tsv(paste0(IQRray_dir, "/U133_plus_2.tsv")) %>%
  mutate(Platform = "U133Plus2") %>%
  mutate(Passing = value > 136266.0795)

E_TABM_158 <- read_tsv(paste0(IQRray_dir, "/E_TABM_158.tsv")) %>%
  mutate(Platform = "U133A") %>%
  mutate(Passing = value > 53812.1375)

big_list <- do.call("rbind", list(huExon, huGene, U95_2, U133_A_Early_Access, U133_A, U133_A2, U133_plus_2))

goodQuality <- big_list[which(big_list$Passing == "TRUE"), ]

goodQual <- function(expr_file) {
    cat("\n")
    print(paste0("Reading in ", expr_file, "!"))
    cat("\n")

    data <- read_tsv(expr_file)
    Sample_ID <- colnames(data)
    all_samples <- goodQuality %>%
      pull(gsmID)
    keep_samples <- intersect(Sample_ID, all_samples)
    clean_data <- dplyr::select(data, Dataset, Gene, all_of(keep_samples))
}

for (file in list.files(input_dir, full.names = T)) {

  file_name <- file %>% basename() %>% file_path_sans_ext()
  out_file_path <- paste0(cleaned_data_dir, file_name, ".gz")

  # call function
  new_data <- goodQual(file)

  #write file
  write_tsv(new_data, out_file_path)
}