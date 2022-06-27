library(tidyverse)
library(tools)

IQRray_dir <- "/Data/IQRray"
datadir <- "/Data/normalized_data"
clean_data_dir <- "/Data/clean_Data/"

huExon <- read_tsv(paste0(IQRray_dir, "/huExon.tsv")) %>%
  mutate(Platform = "HuEx") %>%
  mutate(Passing = TRUE)

huGene <- read_tsv(paste0(IQRray_dir, "/huGene.tsv")) %>%
  mutate(Platform = "HuGene") %>%
  mutate(Passing = TRUE)

U95_2 <- read_tsv(paste0(IQRray_dir, "/U95_2.tsv")) %>%
  mutate(Platform = "U95v2") %>%
  mutate(Passing = value > 45759.6835)

U133A <- read_tsv(paste0(IQRray_dir, "/U133_A.tsv")) %>%
  mutate(Platform = "U133A") %>%
  mutate(Passing = value > 53812.1375)

U133A_early <- read_tsv(paste0(IQRray_dir, "/U133A_Early_Access.tsv")) %>%
  mutate(Platform = "U133A") %>%
  mutate(Passing = value > 53812.1375)

U133_plus_2 <- read_tsv(paste0(IQRray_dir, "/U133_plus_2.tsv")) %>%
  mutate(Platform = "U133Plus2") %>%
  mutate(Passing = value > 136266.0795)

big_list <- (do.call("rbind", list(huExon, huGene, U95_2, U133A, U133A_early, U133_plus_2)))
goodQuality <- big_list[which(big_list$Passing == "TRUE"), ]

goodQual <- function(GSE_ID) {
    data <- read_tsv(GSE_ID)
    Sample_ID <- colnames(data[2:ncol(data)])
    all_samples <- goodQuality %>%
      pull(gsmID)
    keep_samples <- intersect(Sample_ID, all_samples)
    clean_data <- select(data, Gene, all_of(keep_samples))
}

for (file in list.files(datadir, full.names = T)) {
  file_name <- file %>% basename() %>% file_path_sans_ext()
  out_file_path <- paste0(clean_data_dir, file_name, ".gz")
  new_data <- goodQual(file)
  write_tsv(new_data, out_file_path)
}