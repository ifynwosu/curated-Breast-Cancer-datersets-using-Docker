
library("doppelgangR")
library("Biobase")
library("tidyverse")
library(rlist)
library(tools)

#declare variables
datadir <- "/dopplegangR"
out_file_path = paste0("/dopplegangR_test/result.tsv")
dopple_test = list()
name_list = c()

# turn each dataset into an Expressionset
makeExprs <- function(dataset) {
  GSEdata <- read_tsv(dataset)
  genes_names = GSEdata$Gene
  GSEdata = select(GSEdata, -1)
  data_matrix <- as.matrix(GSEdata)
  rownames(data_matrix) <- genes_names
  data_expr <- ExpressionSet(assayData = data_matrix)
}

for (file in list.files(datadir, full.names = T)) {
    file_name <- file %>% basename() %>% file_path_sans_ext()
    name_list <- c(name_list, file_name)
    exprs_file <- makeExprs(file)
    dopple_test <- list.append(dopple_test, exprs_file)    
}
names(dopple_test) <- name_list

result <- doppelgangR(dopple_test, phenoFinder.args=NULL)
result1 <- summary(result)
write_tsv(result1, out_file_path)


# test from same platforms
