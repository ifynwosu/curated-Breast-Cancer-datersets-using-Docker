library(tidyverse)
library(tools)
library(doppelgangR)
library(ggplot2)
library(affy)
library(methods)
library(AnnotationDbi)
library(Biobase)
library(oligo)
library(GEOquery)
options(timeout = max(300, getOption("timeout")))
options(download.file.method.GEOquery = "wget")

out_file_path <- "/Data/IQRray_results/"
if (!dir.exists(out_file_path)) {
  dir.create(out_file_path)
}

#source required functions
source("functions/compute_IQRray.R")
source("functions/run_IQRray.R")
source("functions/bind_IQR_file.R")

#source script that seperates datasets by array type
source("scripts/filter_chips.R")

source("scripts/doppelgang.R")
source("scripts/merge_doppel_results.R")
source("scripts/IQRray_E_TABM_158.R")
source("scripts/IQRray_single_chips.R")
source("scripts/IQRray_multiple_chips.R")

#delete temporary download directory
unlink("GSE1456", recursive = TRUE, force = TRUE)
unlink("GSE3494", recursive = TRUE, force = TRUE)
unlink("GSE4922", recursive = TRUE, force = TRUE)
unlink("GSE6532", recursive = TRUE, force = TRUE)