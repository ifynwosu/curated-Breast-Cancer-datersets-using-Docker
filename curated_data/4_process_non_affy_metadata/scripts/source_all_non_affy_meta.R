library(GEOquery)
library(tidyverse)
library(janitor)

#this setting helps with the download for GSE62944 which is a very large file
Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 10000)

#create download directory for temporary files
tmp_dir <- "tmp/"
unlink(tmp_dir, recursive = TRUE, force = TRUE)
if (!dir.exists(tmp_dir)) {
  dir.create(tmp_dir)
}

# create data directory for saving data
data_dir <- "/Data/analysis_ready_metadata/"
if (!dir.exists(data_dir)) {
  dir.create(data_dir, recursive = TRUE)
}

source("functions/summariseVariables.R")

source("functions/removeCols.R")
source("scripts/GSE81538_meta.R")
source("scripts/GSE96058_meta.R")
source("scripts/GSE62944_meta.R")
source("scripts/ICGC_France_meta.R")
source("scripts/ICGC_South_Korea_meta.R")
source("scripts/Metabric_meta.R")

#delete temporary download directory
unlink(tmp_dir, recursive = TRUE, force = TRUE)