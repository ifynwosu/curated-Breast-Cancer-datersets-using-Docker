FROM bioconductor/bioconductor_docker:RELEASE_3_14

#install required packages
RUN R -e 'BiocManager::install(c("tidyverse", "tidytext", "stringdist", "writexl"), force = TRUE)'

WORKDIR /6_NCIT_matching
