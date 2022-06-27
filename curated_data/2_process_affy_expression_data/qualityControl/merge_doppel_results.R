#combine all files and pass thru them.
library(tidyverse)

file_paths <- list.files("/Data/dopple_results", pattern = "*.tsv", full.names = T)
big_file <- read_tsv(file_paths, id = "filename") #%>%
    #select(sample1, sample2, expr.similarity) #%>%
    # distinct() %>%
    # filter(expr.similarity > 0.99)

write_tsv(big_file, "/Data/merge_dopple_unfiltered.tsv.gz")
