# Define the file path to the metadata directory
metadata_dir <- "metadata"

# Create the metadata folder if it doesn't exist
if (!dir.exists(metadata_dir)) {
  dir.create(metadata_dir)
}

# Define the file path to the variable summaries directory in json format 
json_dir <- "varSummary_json"

# Create the folder if it doesn't exist
if (!dir.exists(json_dir)) {
  dir.create(json_dir)
}

# Define the file path to the variable summaries directory in tsv format
tsv_dir <- "varSummary_tsv"

# Create the folder if it doesn't exist
if (!dir.exists(tsv_dir)) {
  dir.create(tsv_dir)
}