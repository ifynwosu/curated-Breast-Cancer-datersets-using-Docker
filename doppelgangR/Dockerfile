FROM bioconductor/bioconductor_docker:RELEASE_3_14

#install required packages
RUN R -e 'BiocManager::install(c("doppelgangR", "Biobase", "tidyverse", "rlist", "tools"), force = TRUE)'

RUN mkdir /doppelgangR

WORKDIR /doppelgangR
