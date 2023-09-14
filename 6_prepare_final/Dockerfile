FROM bioconductor/bioconductor_docker:RELEASE_3_17

#install required packages
RUN R -e 'BiocManager::install(c("tidyverse", "janitor", "biomaRt", "splitstackshape"), force = TRUE)'

WORKDIR /6_prepare_final