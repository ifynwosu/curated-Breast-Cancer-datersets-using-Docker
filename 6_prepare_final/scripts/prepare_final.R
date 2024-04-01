library(biomaRt)
library(tidyverse)
library(tools)
library(splitstackshape)

# set biomart cache location. Without this, code fails becase of docker permissions issues.
Sys.setenv(BIOMART_CACHE = "/Data/cache")

Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 10000)

# function to create directory
create_directory <- function(directory_path) {
    if (!dir.exists(directory_path)) {
        dir.create(directory_path, recursive = TRUE)
    }
}

# set relevant directories
normalized_data <- "/Data/expression_data"
IQRray_result <- "/Data/IQRray_results"
clean_colnames_expr_data <- "/Data/clean_colnames_expr_data/"
IQRray_filtered <- "/Data/IQRray_filtered_data/"
meta_expr_matched_data <- "/Data/matched_expr_data/"
analysis_ready_meta_data <- "/Data/analysis_ready_metadata/"
analysis_ready_expr_data <- "/Data/analysis_ready_expression_data/"


create_directory(clean_colnames_expr_data)
create_directory(IQRray_filtered)
create_directory(analysis_ready_meta_data)
create_directory(meta_expr_matched_data)
create_directory(analysis_ready_expr_data)

source("scripts/clean_expression_data_colnames.R")
source("scripts/IQRray_filter_samples.R")
source("scripts/match_data.R")
source("scripts/add_gene_symbol.R")
source("scripts/merge_metadata_summaries.R")

unlink(clean_colnames_expr_data, recursive = TRUE, force = TRUE)
unlink(IQRray_filtered, recursive = TRUE, force = TRUE)
unlink(meta_expr_matched_data, recursive = TRUE, force = TRUE)
unlink(meta_dir, recursive = TRUE, force = TRUE)
unlink("/Data/cache", recursive = TRUE, force = TRUE)
