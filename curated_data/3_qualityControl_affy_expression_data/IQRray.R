
library(affy)
library(methods)
library(AnnotationDbi)
library(Biobase)
library(oligo)
library(GEOquery)

options(timeout = max(300, getOption("timeout")))
options(download.file.method.GEOquery = "wget")

#source script that seperates datasets by array type
source("filter_chips.R")

out_file_path <- "/Data/IQRray_results/"
if (!dir.exists(out_file_path)) {
  dir.create(out_file_path)
}

#define the datasets with Gene ST and Exon ST arrays
oligo_arrays <- c("GSE33692", "GSE86374", "GSE58644", "GSE118432", "GSE59772", "GSE81838")

#function computing arIQR quality score for oligo arrays
IQRray_oligo <- function(data) {
  #obtaining intensity values for perfect match (pm) probes
  pm_data <- oligo::pm(data)

  #ranking probe intensities for every array
  rank_data <- apply(pm_data, 2, rank)

  #obtaining names of probeset for every probe
  probeNames <- oligo::probeNames(data)

  #function computing IQR of mean probe ranks in probesets
  get_IQR <- function(rank_data, probeNames) {
      round(IQR(sapply(split(rank_data, probeNames), mean)), digits = 2)
  }

  #computing arIQR score
  IQRray_score <- apply(rank_data, 2, get_IQR, probeNames = probeNames)

  return(IQRray_score)
}

#function computing arIQR quality score for affy arrays
IQRray_affy <- function(data) {
  #obtaining intensity values for perfect match (pm) probes
  pm_data <- affy::pm(data)

  #ranking probe intensities for every array
  rank_data <- apply(pm_data, 2, rank)

  #obtaining names of probeset for every probe
  probeNames <- affy::probeNames(data)

  #function computing IQR of mean probe ranks in probesets
  get_IQR <- function(rank_data, probeNames) {
      round(IQR(sapply(split(rank_data, probeNames), mean)), digits = 2)
  }

  #computing arIQR score
  IQRray_score <- apply(rank_data, 2, get_IQR, probeNames = probeNames)

  return(IQRray_score)
}

#function to run the IQRray function across multiple datasets
run_IQRray <- function(gseID) {

  # Define the file path to a temp directory for saving RAW data
  tmp_dir <- paste0("/tmp/", gseID)
  dir.create(tmp_dir)

  print(paste0("Downloading ", gseID, " for processing!"))

  GSE <- getGEOSuppFiles(gseID, makeDirectory = F, baseDir = tmp_dir, filter_regex = "RAW.tar$")
  tmp <- rownames(GSE)
  untar(tmp[1], exdir = tmp_dir)

  celFilePaths <- list.files(tmp_dir, pattern = "*.CEL", full.names = T, ignore.case = T)

  if (gseID %in% oligo_arrays) {
    my_data <- read.celfiles(filenames = celFilePaths)
    IQR_score <- IQRray_oligo(my_data) %>%
      as_tibble(rownames = "celfileID")
  } else {
    my_data <- ReadAffy(filenames = celFilePaths)
    IQR_score <- IQRray_affy(my_data) %>%
      as_tibble(rownames = "celfileID")
  }

  IQR_score <- mutate(IQR_score, gsmID = str_extract(IQR_score$celfileID, "^GSM\\d+")) %>%
    relocate(gsmID)
  IQR_score <- cbind(gseID, IQR_score)

  unlink(tmp_dir, recursive = TRUE, force = TRUE)
  return(IQR_score)
}

IQRay_file <- NULL
for (gseID in huGene$gseID) {
  final_score <- run_IQRray(gseID)
  if (is.null(IQRay_file)) {
    IQRay_file <- final_score
  } else {
    IQRay_file <- rbind(IQRay_file, final_score)
  }
}
write_tsv(IQRay_file, paste0(out_file_path, "huGene.tsv"))
print("Saved to huGene.tsv")

IQRay_file <- NULL
for (gseID in huExon$gseID) {
final_score <- run_IQRray(gseID)
  if (is.null(IQRay_file)) {
    IQRay_file <- final_score
  } else {
    IQRay_file <- rbind(IQRay_file, final_score)
  }
}
write_tsv(IQRay_file, paste0(out_file_path, "huExon.tsv"))
print("Saved to huExon.tsv")

IQRay_file <- NULL
for (gseID in U95_2$gseID) {
final_score <- run_IQRray(gseID)
  if (is.null(IQRay_file)) {
    IQRay_file <- final_score
  } else {
    IQRay_file <- rbind(IQRay_file, final_score)
  }
}
write_tsv(IQRay_file, paste0(out_file_path, "U95_2.tsv"))
print("Saved to U95_2.tsv")

IQRay_file <- NULL
for (gseID in U133_A_Early_Access$gseID) {
final_score <- run_IQRray(gseID)
  if (is.null(IQRay_file)) {
    IQRay_file <- final_score
  } else {
    IQRay_file <- rbind(IQRay_file, final_score)
  }
}
write_tsv(IQRay_file, paste0(out_file_path, "U133A_Early_Access.tsv"))
print("Saved to U133A_Early_Access.tsv")

IQRay_file <- NULL
for (gseID in U133_A$gseID) {
final_score <- run_IQRray(gseID)
  if (is.null(IQRay_file)) {
    IQRay_file <- final_score
  } else {
    IQRay_file <- rbind(IQRay_file, final_score)
  }
}
write_tsv(IQRay_file, paste0(out_file_path, "U133_A.tsv"))
print("Saved to U133_A.tsv")

IQRay_file <- NULL
for (gseID in U133_A2$gseID) {
final_score <- run_IQRray(gseID)
  if (is.null(IQRay_file)) {
    IQRay_file <- final_score
  } else {
    IQRay_file <- rbind(IQRay_file, final_score)
  }
}
write_tsv(IQRay_file, paste0(out_file_path, "U133_A2.tsv"))
print("Saved to U133_A2.tsv")

IQRay_file <- NULL
for (gseID in U133_plus_2$gseID) {
final_score <- run_IQRray(gseID)
  if (is.null(IQRay_file)) {
    IQRay_file <- final_score
  } else {
    IQRay_file <- rbind(IQRay_file, final_score)
  }
}
write_tsv(IQRay_file, paste0(out_file_path, "U133_plus_2.tsv"))
print("Saved to U133_plus_2.tsv")

# IQRray for E_TABM_158

base_dir <- "E-TABM-158/"
unlink(base_dir, recursive = TRUE)
if (!dir.exists(base_dir)) {
  dir.create(base_dir)
}

# download expression files
download.file("https://www.ebi.ac.uk/arrayexpress/files/E-TABM-158/E-TABM-158.raw.1.zip",
              destfile = paste0(base_dir, "E_TABM_1.zip"), method = "wget")

download.file("https://www.ebi.ac.uk/arrayexpress/files/E-TABM-158/E-TABM-158.raw.2.zip",
              destfile = paste0(base_dir, "E_TABM_2.zip"), method = "wget")

download.file("https://www.ebi.ac.uk/arrayexpress/files/E-TABM-158/E-TABM-158.raw.3.zip",
              destfile = paste0(base_dir, "E_TABM_3.zip"), method = "wget")

zip_file <- list.files(base_dir, pattern = "*.zip", full.names = T)

for (file in zip_file) {
  unzip(file, exdir = base_dir)
}

celFilePaths <- list.files(base_dir, pattern = "*.CEL", full.names = T, ignore.case = T)

my_data <- ReadAffy(filenames = celFilePaths)
IQR_score <- IQRray_affy(my_data) %>%
  as_tibble(rownames = "celfileID")

#code below matches sample names from metadata file to IQR_score

# download metadata file
download.file("https://www.ebi.ac.uk/arrayexpress/files/E-TABM-158/E-TABM-158.sdrf.txt",
              destfile = paste0(base_dir, "ETABM_158_meta.txt"))

ETABM_meta <- read_tsv(paste0(base_dir, "ETABM_158_meta.txt"))

meta_col <- ETABM_meta %>%
  dplyr::select(c("Array Data File", "Source Name")) %>%
  rename(celfileID = `Array Data File`) %>%
  rename(gsmID = `Source Name`)

joint_cols <- full_join(meta_col, IQR_score) %>%
  mutate(gseID = "E_TABM_158") %>%
  select(gseID, gsmID, celfileID, value)


write_tsv(joint_cols, paste0(out_file_path, "E_TABM_158.tsv"))
print("Saved to E_TABM_158.tsv")

unlink(base_dir, recursive = TRUE, force = TRUE)