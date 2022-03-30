FROM bioconductor/bioconductor_docker:RELEASE_3_14

#install required packages
RUN R -e 'BiocManager::install(c("GEOquery", "SCAN.UPC", "tidyverse", "janitor", "stringi", "biomaRt", "rlist", "doParallel", "doppelgangR"), force = TRUE)'

#add brain array script and install packages
ADD brain_Array.R / 
RUN Rscript /brain_Array.R

#make directory in docker to store scripts
RUN mkdir /Expression_Scripts

#add R scripts to docker
ADD Expression_Scripts/*.R /Expression_Scripts/

#add gseID list
ADD gene_exp.tsv / 
