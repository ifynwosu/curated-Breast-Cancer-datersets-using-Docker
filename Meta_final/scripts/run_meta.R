
source("scripts/LoadLibraries.R")

df_dir <- "/Data/df_test_data"
meta_dir <- "/Data/meta_test_data"

df_out <- "/Data/meta_output/df.tsv"
meta_out <- "/Data/meta_output/meta.tsv"

df_file_paths <- list.files(df_dir, full.names = T)
meta_file_paths <- list.files(meta_dir, full.names = T)

big_df <- NULL
big_meta <- NULL

for (file in df_file_paths) {
    cat("\n")
    print(paste0("Reading in ", file))
    cat("\n")
    df <- read_tsv(file)

    if (is.null(big_df)) {
        big_df <- df
    } else {
        big_df <- bind_rows(big_df, df)
    }
}

cat("\n")
print("Writing out combined expression file")
# write_tsv(as_tibble(big_df), df_out)


for (file in meta_file_paths) {
    cat("\n")
    print(paste0("Reading in ", file))
    cat("\n")
    meta <- read_tsv(file) %>%
    rename(`Estrogen Receptor Status` = er)

    if (is.null(big_meta)) {
        big_meta <- meta
    } else {
        big_meta <- bind_rows(big_meta, meta)
    }
}

cat("\n")
write_tsv(as_tibble(big_meta), meta_out)