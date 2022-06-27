FROM bioconductor/bioconductor_docker:RELEASE_3_14

RUN R -e 'BiocManager::install(c("tidyverse", "GEOquery", "SCAN.UPC", "biomaRt", "rvest", "janitor", "stringi", "doParallel"))'
RUN mkdir /scripts

ADD scripts/* /scripts/