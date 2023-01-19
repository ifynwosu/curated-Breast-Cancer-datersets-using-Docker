
library(doppelgangR)
library(Biobase)
library(tidyverse)
library(rlist)
library(tools)

#declare variables
datadir <- "/Data/expression_data"
out_file_path <- paste0("/Data/doppel_result_test.tsv")
dopple_file <- list()
filename_list <- c()

# turn each dataset into an Expressionset
makeExprs <- function(dataset) {
  GSEdata <- read_tsv(dataset)
  genes_names <- pull(GSEdata, Gene)
  GSEdata <- dplyr::select(GSEdata, -Gene)
  data_matrix <- as.matrix(GSEdata)
  rownames(data_matrix) <- genes_names
  data_expr <- ExpressionSet(assayData = data_matrix)
}

for (file in list.files(datadir, full.names = T)) {
    file_name <- file %>% basename() %>% file_path_sans_ext()
    filename_list <- c(filename_list, file_name)
    exprs_file <- makeExprs(file)
    dopple_file <- list.append(dopple_file, exprs_file)
}
names(dopple_file) <- filename_list

result <- doppelgangR(dopple_file, phenoFinder.args = NULL, BPPARAM = MulticoreParam(workers = 16))
result_summary <- summary(result)
write_tsv(result_summary, out_file_path)
