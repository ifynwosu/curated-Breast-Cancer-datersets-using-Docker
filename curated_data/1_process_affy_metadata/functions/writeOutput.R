#write output to files

writeOutput <- function(gseID) {

  if ((ncol(metadata) > 2)) {
    write_tsv(metadata, file.path(
        metadata_dir,
        paste0(gseID, ".tsv")
    ))
    print(paste0("Saved ", gseID, ".tsv to ", metadata_dir))
  }

  if (!is.null(varSummary$numSummary)) {
    if (nrow(varSummary$numSummary) >= 1) {
      write_tsv(varSummary$numSummary, file.path(
        tsv_dir,
        paste0(gseID, "_num.tsv")
      ))
    }
  }

  if (!is.null(varSummary$charSummary)) {
    if (nrow(varSummary$charSummary) >= 1) {
      write_tsv(varSummary$charSummary, file.path(
        tsv_dir,
        paste0(gseID, "_char.tsv")
      ))
    }
  }

  if (ncol(saveCols) >= 1) {
    write_tsv(saveCols, file.path(
      other_dir,
      paste0(gseID, "_other.tsv")
   ))
  }
}
