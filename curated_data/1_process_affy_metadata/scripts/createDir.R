# Define the file path to the metadata directory
metadata_dir <- "/Data/analysis_ready_metadata"

# Create the metadata folder if it doesn't exist
if (!dir.exists(metadata_dir)) {
  dir.create(metadata_dir)
}

# Define the file path to the variable summaries directory in tsv format
tsv_dir <- "/Data/metadata_summaries"

# Create the folder if it doesn't exist
if (!dir.exists(tsv_dir)) {
  dir.create(tsv_dir)
}

# Define the file path to the other summaries directory in tsv format
other_dir <- "/Data/other_tsv"

# Create the folder if it doesn't exist
if (!dir.exists(other_dir)) {
  dir.create(other_dir)
}
