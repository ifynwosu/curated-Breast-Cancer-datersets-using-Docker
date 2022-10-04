# Define the file path to the unprocessed metadata directory
raw_metadata_dir <- "/Data/raw_metadata/"

# Create the unprocessed metadata folder if it doesn't exist
if (!dir.exists(raw_metadata_dir)) {
  dir.create(raw_metadata_dir, recursive = TRUE)
}

# Define the file path to the metadata directory
metadata_dir <- "/Data/analysis_ready_metadata/"

# Create the metadata folder if it doesn't exist
if (!dir.exists(metadata_dir)) {
  dir.create(metadata_dir, recursive = TRUE)
}

# Define the file path to the variable summaries directory in tsv format
metadata_summaries <- "/Data/metadata_summaries/"

# Create the folder if it doesn't exist
if (!dir.exists(metadata_summaries)) {
  dir.create(metadata_summaries, recursive = TRUE)
}
