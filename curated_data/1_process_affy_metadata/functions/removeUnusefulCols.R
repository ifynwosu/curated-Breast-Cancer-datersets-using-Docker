
removeUnusefulCols <- function(metadata) {

  #these should be common to multiple datasets
  remove_cols <- c("channel_count","data_processing", "data_row_count", "description", "hyb_protocol", "id", "last_update_date", "platform", "processor_id",
                   "processor_name", "processor_version", "scan_protocol", "series_id", "set", "source_name_ch1", "status",
                   "submission_date")

  for (element in remove_cols) {
    if (element %in% names(metadata)) {
      metadata <- metadata %>%
        dplyr::select(-all_of(element))
    }
  }

  return(metadata)
}