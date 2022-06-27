library(tidyverse)

datadir <- "/Data/metadata_summaries/"
file_paths <- list.files(datadir, full.names = T)
out_file_path <- "/Data/merged_meta_summary.tsv"

big_df <- NULL

for (file in file_paths) {
    df <- read_tsv(file)

    if (is.null(big_df)) {
        big_df <- df
    } else {
        print(big_df)
        big_df <- bind_rows(big_df, df)
    }
}
big_df <- big_df[order(big_df$Variable), ]

# big_df <- big_df %>%
#     distinct(Variable, .keep_all = TRUE)

write_tsv(as_tibble(big_df), out_file_path)
print(paste0("Saved to ", out_file_path))