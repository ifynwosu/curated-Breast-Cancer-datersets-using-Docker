
library(tidyverse)
library(rlist)
library(tools)

#declare variables
datadir <- "/Data/expression_data"

makeExprs <- function(dataset) {
  GSEdata <- read_tsv(dataset)
  genes_names <- pull(GSEdata, Gene)
  GSEdata <- select(GSEdata, -Gene)
  data_matrix <- as.matrix(GSEdata)
  rownames(data_matrix) <- genes_names
  return(data_matrix)
}

#run dopplegangR using pairwise comparisons of datasets
file_paths <- list.files(datadir, full.names = T)
for (i in 1:(length(file_paths) - 1)) {
  file_path1 <- file_paths[i]
  for (j in (i + 1):length(file_paths)) {
    file_path2 <- file_paths[j]
    if (file_path1 == file_path2) {
      next
    }

    file_names <- basename(c(file_path1, file_path2)) %>%
      file_path_sans_ext() %>%
      file_path_sans_ext()

    out_file_path <- "/Data/dopple_results/"
    out_file_path <- paste0(out_file_path,  paste0(file_names, collapse = "_"), ".tsv")

#    if (file.exists(out_file_path)) {
#      print(paste0(out_file_path, " already exists"))
#    } else {
      exprs_1 <- makeExprs(file_path1)

      results_summary = NULL

      for (m in 1:(ncol(exprs_1) - 1)) {
        for (n in (m + 1):ncol(exprs_1)) {
          id_1 = colnames(exprs_1)[m]
          id_2 = colnames(exprs_1)[n]

          print(paste0("Finding correlation between ", id_1, " and ", id_2))
          sample_1 = exprs_1[, m]
          sample_2 = exprs_1[, n]
          coef = cor(sample_1, sample_2, method = "spearman")

          results_summary = rbind(results_summary, c(id_1, id_2, coef))
        }
      }

      # Repeat the above process for exprs_2 (probably create a function)
      # Look at each pair of samples between exprs_1 and exprs_2.
      # Do parallelization?
      # common_genes = intersect(rownames(exprs_1), rownames(exprs_2))

      print(results_summary)
      stop("got here")

      exprs_2 <- makeExprs(file_path2)

  }
}
