options(repos = "http://cran.r-project.org")
#"https://cloud.r-project.org"
#"https://cran.rstudio.com/"

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GEOquery")

install.packages("tidyverse")
install.packages("stringi")
install.packages("janitor")
install.packages("rlist")

