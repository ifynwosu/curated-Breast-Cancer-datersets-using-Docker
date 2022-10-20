FROM bioconductor/bioconductor_docker:RELEASE_3_14

#install required packages
RUN R -e 'BiocManager::install(c("tidyverse", "doppelgangR", "affy", "AnnotationDbi", "Biobase", "oligo", "GEOquery", "ggplot2"), force = TRUE)'

WORKDIR /3_qualityControl_affy_expression_data

# "hgu133acdf", "hgu133bcdf", "hgu133plus2cdf"
