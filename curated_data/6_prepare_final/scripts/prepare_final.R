library(biomaRt)
library(tidyverse)
library(tools)

normalized_data <- "/Data/expression_data"

IQRray_result <- "/Data/IQRray_results"

clean_colnames_expr_data <- "/Data/clean_colnames_expr_data/"
if (!dir.exists(clean_colnames_expr_data)) {
  dir.create(clean_colnames_expr_data)
}

IQRray_filtered <- "/Data/IQRray_filtered_data/"
if (!dir.exists(IQRray_filtered)) {
  dir.create(IQRray_filtered)
}

analysis_ready_data <- "/Data/analysis_ready_expression_data/"
if (!dir.exists(analysis_ready_data)) {
  dir.create(analysis_ready_data)
}

# source("scripts/clean_expression_data_colnames.R")
# source("scripts/IQRray_filter_samples.R")
source("scripts/add_gene_symbol.R")
# source("scripts/merge_metadata_summaries.R")

# unlink(clean_colnames_expr_data, recursive = TRUE, force = TRUE)
# unlink(IQRray_filtered, recursive = TRUE, force = TRUE)