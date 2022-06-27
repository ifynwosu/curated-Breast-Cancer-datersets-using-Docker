#write output to files

writeOutput <- function(geoID) {
  
  if ((ncol(metadata) > 2)) {
    write_tsv(metadata, file.path(
        metadata_dir,
        paste0(gseID, ".tsv")
      ))
  }
  
  write_tsv(saveCols, file.path(
    metadata_dir,
    paste0(gseID, "_other.tsv")
  ))
  
  if (!is.null(varSummary$numSummary)) { 
    write_tsv(varSummary$numSummary, file.path(
      tsv_dir,
      paste0(gseID, "_num.tsv")
    ))
  }
  if (!is.null(varSummary$charSummary)) {
    write_tsv(varSummary$charSummary, file.path(
      tsv_dir,
      paste0(gseID, "_char.tsv")
    ))
  }
  
  # list.save(varSummary, file.path(
  #     json_dir,
  #     paste0(gseID, ".json")
  #   ))
}

# write_tsv(metadata, "metadata/GSE7378.tsv")
# write_tsv(varSummary$numSummary, "varSummary_tsv/GSE7378_num.tsv")
# write_tsv(varSummary$charSummary, "varSummary_tsv/GSE7378_char.tsv")
# list.save(varSummary, "varSummary_json/GSE7378.json")