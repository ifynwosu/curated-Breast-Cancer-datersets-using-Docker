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

# Define the file path to the unprocessed metadata directory
raw_metadata_dir <- "/Data/raw_metadata/"

# Define the file path to the metadata directory for saving data
data_dir <- "/Data/prelim_metadata/"

source("functions/summariseVariables.R")
source("functions/removeCols.R")

source("scripts/GSE81538_meta.R")
source("scripts/GSE96058_meta.R")
source("scripts/GSE62944_meta.R")
source("scripts/ICGC_South_Korea_meta.R")
source("scripts/Metabric_meta.R")

#delete temporary download directory
unlink(tmp_dir, recursive = TRUE, force = TRUE)