
#  The code below summerizes all of the metadata summaries in one file
datadir <- "/Data/meta_sum_new/"
file_paths <- list.files(datadir, full.names = TRUE)
out_file_path <- "/Data/merged_metadata_summary_2.tsv"

big_df <- NULL

for (file in file_paths) {
    df <- read_tsv(file)

    if (is.null(big_df)) {
        big_df <- df
    } else {
        big_df <- bind_rows(big_df, df)
    }
}
big_df <- big_df[order(big_df$Variable), ]

big_df <- big_df %>%
    distinct(Dataset_ID, Variable, .keep_all = TRUE)

write_tsv(as_tibble(big_df), out_file_path)
print(paste0("Saved to ", out_file_path))
