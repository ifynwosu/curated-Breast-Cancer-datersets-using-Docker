getFromGEO <- function(geoID) {

  gseData <- getGEO(geoID)
  df <- gseData[[1]]

  exprsData <- exprs(df) %>%
    as_tibble(rownames = NA) %>%
    rownames_to_column(var = "geneID")

  meta <- pData(df) %>%
    dplyr::rename(Sample_ID = geo_accession) %>%
    dplyr::select(Sample_ID, everything()) %>%
    mutate(Dataset_ID = geoID, .before = Sample_ID)

  return(list(expression_data = exprsData, metadata = meta))
}