library(tidyverse)

#read the sample and data relationship file into a table
etabm_158 <- read_tsv("https://www.ebi.ac.uk/arrayexpress/files/E-TABM-158/E-TABM-158.sdrf.txt")

write.table(etabm_158, "/Data/analysis_ready_metadata/etabm_158.tsv")
