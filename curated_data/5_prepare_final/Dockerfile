FROM bioconductor/bioconductor_docker:RELEASE_3_14

#install required packages
RUN R -e 'BiocManager::install(c("tidyverse", "stringi", "janitor"), force = TRUE)'

WORKDIR /5_prepare_final