FROM bioconductor/bioconductor_docker:RELEASE_3_17-R-4.3.0

#install required packages
RUN R -e 'BiocManager::install(c("GEOquery", "tidyverse", "stringi", "janitor", "rlist"), force = TRUE)'

WORKDIR /1_process_metadata
