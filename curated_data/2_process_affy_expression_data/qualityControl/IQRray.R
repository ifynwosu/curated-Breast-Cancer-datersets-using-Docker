library(oligo)
library(affy)
library(methods)
library(AnnotationDbi)
library(Biobase)
library(tidyverse)
library(GEOquery)
options(download.file.method.GEOquery = "wget")

#source script that seperates datasets by array type
source("filter_chips.R")

#define the datasets with Gene ST and Exon ST arrays
oligo_arrays <- c("GSE33692", "GSE86374", "GSE58644", "GSE118432", "GSE59772", "GSE81838")
dual_arrays <- c("GSE4922", "GSE1456", "GSE3494", "GSE6532")

#function computing arIQR quality score
IQRray <- function(data) {
  #obtaining intensity values for perfect match (pm) probes
  pm_data <- pm(data)

  #ranking probe intensities for every array
  rank_data <- apply(pm_data, 2, rank)

  #obtaining names of probeset for every probe
  probeNames <- probeNames(data)

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
  tmp_dir <- "tempDir"
  if (!dir.exists(tmp_dir)) {
      dir.create(tmp_dir)
  }
  print(paste0("Downloading ", gseID, " for processing!"))

  downloadDir <- paste(tmp_dir, "/", gseID, sep = "")
  #delete temporary download directory if it already exists
  unlink(downloadDir, recursive = TRUE)

  GSE <- getGEOSuppFiles(gseID, makeDirectory = F, baseDir = tmp_dir, filter_regex = "RAW.tar$")
  tmp <- rownames(GSE)
  untar(tmp[1], exdir = downloadDir)
  celFilePaths <- list.files(downloadDir, pattern = "*.CEL", full.names = T, ignore.case = T)

  if (gseID %in% oligo_arrays) {
    my_data <- read.celfiles(filenames = celFilePaths)
  } else {
    my_data <- ReadAffy(filenames = celFilePaths)
  }

  IQR_score <- IQRray(my_data) %>%
      as_tibble(rownames = "celfileID")
  IQR_score <- mutate(IQR_score, gsmID = str_extract(IQR_score$celfileID, "^GSM\\d+")) %>%
    relocate(gsmID)
  IQR_score <- cbind(gseID, IQR_score)

  unlink(tmp_dir, recursive = TRUE)
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
write_tsv(IQRay_file, "huGene.tsv")
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
write_tsv(IQRay_file, "huExon.tsv")
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
write_tsv(IQRay_file, "U95_2.tsv")
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
write_tsv(IQRay_file, "U133A_Early_Access.tsv")
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
write_tsv(IQRay_file, "U133_A.tsv")
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
write_tsv(IQRay_file, "U133_A2.tsv")
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
write_tsv(IQRay_file, "U133_plus_2.tsv")
print("Saved to U133_plus_2.tsv")
