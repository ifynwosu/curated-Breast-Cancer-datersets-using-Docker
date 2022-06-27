
removeColsWithAllUniqueValue <- function(metadata) {

  #create vector to store column names that should be ignored
  excludeColumn <- c("Dataset_ID", "Sample_ID", "sex", "node", "relation", "hormone receptor status", "population", "therapy")

  #create empty vector to store column names that should be removed
  cols_to_remove <- NULL

  for (i in seq_along(metadata)) {
    columnName <- colnames(metadata)[i]
    aCol <- pull(metadata, i)
    aCol <- aCol[!is.na(aCol)]

    #check numeric values (this is because some datasets might have different values in a variable e.g age, and will be removed in the second loop)
    if (is.numeric(metadata[, i])) {
      next
    }

    if (!(columnName %in% excludeColumn)) {
      if (length(aCol) == length(unique(aCol))) {
        print(paste0("All of the values in the ", columnName, " column are different. Examples: ", aCol[1], ", ", aCol[2], " and will be removed."))
        cols_to_remove <- c(cols_to_remove, columnName)
      }
    }
  }

  #Remove unwanted columns
  metadata <- metadata %>%
    dplyr::select(-all_of(cols_to_remove))

  return(metadata)
}