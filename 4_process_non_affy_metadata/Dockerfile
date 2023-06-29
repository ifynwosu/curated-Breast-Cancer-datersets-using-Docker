FROM bioconductor/bioconductor_docker:RELEASE_3_15

RUN R -e 'BiocManager::install(c("GEOquery", "tidyverse", "janitor"))'

WORKDIR /4_process_non_affy_metadata
