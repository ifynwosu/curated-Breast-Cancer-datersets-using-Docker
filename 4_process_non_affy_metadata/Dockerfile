FROM bioconductor/bioconductor_docker:RELEASE_3_18

RUN R -e 'BiocManager::install(c("GEOquery", "tidyverse", "janitor", "rlist", "stringi"))'

WORKDIR /4_process_non_affy_metadata
