
removeColsWithOnlyOneValue <- function(metadata) {

  #create vector to store column names that should be ignored
  excludeColumn <- c("Dataset_ID", "Sample_ID", "node", "relation", "hormone receptor status", "population", "therapy")

  #create empty vector to store column names that should be removed
  cols_to_remove <- NULL

  for (i in seq_along(metadata)) {
    columnName <- colnames(metadata)[i]
    aCol <- pull(metadata, i)
    aCol <- aCol[!is.na(aCol)]

    if (!(columnName %in% excludeColumn)) {
      if (length(unique(aCol)) == 1) {
        print(paste0("All of the values in the ", columnName, " column are the same: ", aCol[1], " and will be removed."))
        cols_to_remove <- c(cols_to_remove, columnName)
      }
    }
  }

  #Remove unwanted columns
  metadata <- metadata %>%
    dplyr::select(-all_of(cols_to_remove))

  return(metadata)
}