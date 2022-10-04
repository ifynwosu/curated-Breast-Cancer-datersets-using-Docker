FROM bioconductor/bioconductor_docker:RELEASE_3_14

#install required packages
RUN R -e 'BiocManager::install(c("tidyverse", "doppelgangR", "affy", "AnnotationDbi", "Biobase", "oligo", "GEOquery", "ggplot2"), force = TRUE)'
RUN R -e 'BiocManager::install(c("pd.hugene.1.0.st.v1", "pd.huex.1.0.st.v2", "pd.ht.hg.u133a", "pd.hg.u133a", "pd.hg.u133a.2", "pd.hg.u133.plus.2", "pd.hg.u133b", "pd.hg.u95av2"), force = TRUE)'


WORKDIR /3_qualityControl_affy_expression_data

# "hgu133acdf", "hgu133bcdf", "hgu133plus2cdf"
