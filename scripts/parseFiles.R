sampleList <- read_tsv("affyList.tsv", col_names = "gseID", comment = "#") %>%
  pull(gseID)


for (gseID in sampleList) {
  df <- getFromGEO(gseID)
 
  #clean up column names
  metadata <- df$meta %>%
    select(-(starts_with("characteristic"))) %>%
    rename_with(~str_replace_all(., ":ch1", "")) %>%
    mutate_all(type.convert, as.is=TRUE)

  #some housekeeping
  metadata <- metadata %>%
    removeUnusefulCols() %>%
    removeColsWithOnlyOneValue() %>%
    removeColsWithAllUniqueValue()

  #write relation and description columns to file for later use
  saveCols <- metadata %>%
    select((starts_with("relation")))
  saveCols <- cbind(saveCols, metadata %>%
                      select((starts_with("description"))))

  #remove relation and description columns
  metadata <- metadata %>%
    select(-(starts_with("relation"))) %>%
    select(-(starts_with("description")))

  #summarise variables
  varSummary <- summariseVariables(metadata)

  #write cleaned up data to files
  writeOutput(gseID)
}
