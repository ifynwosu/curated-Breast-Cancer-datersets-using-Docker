FROM bioconductor/bioconductor_docker:RELEASE_3_14

#install required packages
RUN R -e 'BiocManager::install(c("GEOquery", "SCAN.UPC", "tidyverse", "janitor", "stringi", "biomaRt", "rlist", "doParallel", "doppelgangR", "conflicted"), force = TRUE)'

#add brain array script and install packages
ADD brain_Array.R / 
RUN Rscript /brain_Array.R

#add R scripts to docker
ADD filter_chips.R /
ADD normalize.R /
ADD normalize_irregular_files.R / 

#add gseID list
ADD gseIDs.tsv / 
