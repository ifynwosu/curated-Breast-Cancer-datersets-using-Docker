library(GEOquery)
library(tidyverse)
library(janitor)

#create Directory
data_Dir <- "dataDir"
if (!dir.exists(data_Dir)) {
  dir.create(data_Dir)
}

#save supplementary files to Directory and read into separate data frames
cancerTypeSamples <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = data_Dir, filter_regex = "GSE62944_06_01_15_TCGA_24_CancerType_Samples.txt.gz")
CancerType <- rownames(cancerTypeSamples) %>%
  read_tsv(col_names = F)
colnames(CancerType) <- c("Sampleid", "cancer_type")

#create a vector to replace the unknown variables with NA
na_strings <- c("[Unknown]", "[Not Available]", "[Not Evaluated]", "[Not Applicable]")
clinicalVariables <- getGEOSuppFiles("GSE62944", makeDirectory = F, baseDir = data_Dir, filter_regex = "GSE62944_06_01_15_TCGA_24_548_Clinical_Variables_9264_Samples.txt.gz")
Clinical_Variables <- rownames(clinicalVariables) %>%
  read_tsv(col_names = F, na = na_strings) %>%
  select(-(X2:X3))

#rearrange Clinical_Variables
Transposed_df <- as.data.frame(t(Clinical_Variables), stringsAsFactors = F)
Transposed_df[1, 1] <- "Sampleid"
Header <- Transposed_df[1, ]
colnames(Transposed_df) <- Header
Transposed_df <- Transposed_df[-c(1), ]

#merge the data frames by Sampleid
Merged_df <- Transposed_df %>%
  inner_join(CancerType, by = "Sampleid")

#select breast cancer samples only, remove samples without an ID, and remove samples with only one value
BRCA <- Merged_df %>%
  filter(Merged_df$cancer_type == "BRCA") %>%
  filter(bcr_patient_uuid != "NA") %>%
  remove_constant()

#calculate percentage of columns with missing data
percent_NA_brca <- as_tibble(colMeans(is.na(BRCA)), rownames = "variable") %>%
  pivot_wider(names_from = variable, values_from = value)

new_BRCA <- rbind(percent_NA_brca, BRCA)

# remove colums with more than 50% NA
BRCA_fitered <- BRCA[, colMeans(is.na(BRCA)) < 0.5]

write_tsv(BRCA_fitered, "Data/analysis_ready_metadata/GSE62944.tsv")