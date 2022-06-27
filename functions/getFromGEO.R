getFromGEO <- function(geoID) {
  
  gseData <- getGEO(geoID)
  df <- gseData[[1]]
  
  exprsData<- exprs(df) %>% as_tibble(rownames = NA) %>% 
    rownames_to_column(var = "geneID")
  
  metadata <- pData(df) %>%
    rename(sampleID = geo_accession) %>%
    select(sampleID, everything()) %>%
    mutate(experiment_ID = geoID, .before = sampleID) #%>%rownames_to_column(var = "accession")
  
  return (list(exprs = df, meta = metadata))
  
}