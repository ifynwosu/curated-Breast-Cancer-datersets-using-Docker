# sampleList <- read_tsv("gene_exp.tsv", col_names = "gseID", comment = "#") %>%
  # pull(gseID)

gseIDs <- read_tsv("gseIDs.tsv", col_names = F, comment = "#") %>%
  dplyr::select(c(X1, X3)) %>%
  dplyr::rename("gseID" = X1, "geneChip" = X3)

keep_varible <- c("Affymetrix Human Exon 1.0 ST Array [transcript (gene) version]", "Affymetrix Human Gene 1.0 ST Array [transcript (gene) version]", 
                  "Affymetrix Human Genome U95 Version 2 Array", "Affymetrix GeneChip HT-HG_U133A Early Access Array", 
                  "Affymetrix Human Genome U133A Array", "Affymetrix Human Genome U133A 2.0 Array", "Affymetrix Human Genome U133 Plus 2.0 Array")


gseID_list <- NULL

for (i in seq_along(gseIDs$geneChip)) {
  keep_sample <- gseIDs$geneChip[i]
  if (keep_sample %in% keep_varible) {
    gseID_list <- rbind(gseID_list, gseIDs$gseID[i])
  }
}

for (gseID in gseID_list) {
  df <- getFromGEO(gseID)

#some housekeeping
  metadata <- df$metadata %>%
    removeUnusefulCols() %>%
    removeColsWithOnlyOneValue() %>%
    removeColsWithAllUniqueValue()

  #clean up column names
  metadata <- metadata %>%
    select(-(starts_with("characteristic"))) %>%
    rename_with(~str_replace_all(., ":ch1", "")) %>%
    mutate(across(where(is.character), ~replace(., . %in% c("KJ67", "KJ68", "KJ69", "?", "--", "", "KJX46", "KJX38", "KJ117"), NA))) %>%
    mutate_all(type.convert, as.is = TRUE)

  #write relation and description columns to file for later use
  saveCols <- metadata %>%
    select(starts_with("relation"))
  saveCols <- cbind(saveCols, metadata %>%
                      select(starts_with("description")))

  #remove relation and description columns
  metadata <- metadata %>%
    select(-(starts_with("relation"))) %>%
    select(-(starts_with("description"))) %>%
    clean_names()

  #summarise variables
  varSummary <- summariseVariables(metadata)

  #write cleaned up data to files
  writeOutput(gseID)
}
