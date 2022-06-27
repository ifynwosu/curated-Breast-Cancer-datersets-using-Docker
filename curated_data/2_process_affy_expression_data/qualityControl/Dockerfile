FROM bioconductor/bioconductor_docker:RELEASE_3_14

#install required packages
RUN R -e 'BiocManager::install(c("doppelgangR", "Biobase", "tidyverse", "rlist", "R.utils", "tools", "stringr", "affy", "oligo", "methods", "AnnotationDbi", "GEOquery", "hgu133acdf", "hgu133bcdf", "hgu133plus2cdf"), force = TRUE)'

RUN mkdir /qualityControl

WORKDIR /qualityControl
