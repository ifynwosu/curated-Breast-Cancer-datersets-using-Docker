
#  The code below summerizes all of the metadata summaries in one file
datadir <- "/Data/metadata_summaries"
file_paths <- list.files(datadir, full.names = TRUE)
out_file_path <- "/Data/merged_metadata_summary.tsv"

big_df <- NULL

for (file in file_paths) {
    df <- read_tsv(file)

    cat("\n")
    print(paste0("Reading in ", file, "!"))
    cat("\n")

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

# This section summarizes the file generated above to identify how many times each variable appears

# metadata_summary <- read_tsv("/Data/metadata_summary_NCIT_terms.tsv")

# NCIT_field_name <- metadata_summary |>
#     separate_rows(NCIT_Term_field_name, sep = ";")

# NCIT_field_name_sum <- NCIT_field_name |>
#     group_by(NCIT_Term_field_name) |>
#     tally() |>
#     arrange(desc(n))

# NCIT_field_name_multiple <- metadata_summary |>
#     cSplit(splitCols = "NCIT_Term_field_name", sep = ";")

# NCIT_field_name_sum_multiple <- NCIT_field_name_multiple |> 
#     group_by(NCIT_Term_field_name_1, NCIT_Term_field_name_2, NCIT_Term_field_name_3, NCIT_Term_field_name_4, NCIT_Term_field_name_5) |>
#     tally()  |>
#     arrange(desc(n))

# write_tsv(NCIT_field_name_sum, "/Data/NCIT_field_name_summary.tsv")
# write_tsv(NCIT_field_name_sum_multiple, "/Data/NCIT_field_name_multiple_summary.tsv")

# NCIT_term_values <- metadata_summary |>
#     separate_rows(NCIT_Term_values, sep = ";")

# NCIT_term_values_sum <- NCIT_term_values |>
#     group_by(NCIT_Term_values) |>
#     tally() |>
#     arrange(desc(n))

# NCIT_term_values_multiple <- metadata_summary |>
#     cSplit(splitCols = "NCIT_Term_values", sep = ";")

# NCIT_term_values_sum_multiple <- NCIT_term_values_multiple |>
#     group_by(NCIT_Term_values_01, NCIT_Term_values_02, NCIT_Term_values_03, NCIT_Term_values_04,
#              NCIT_Term_values_05, NCIT_Term_values_06, NCIT_Term_values_07, NCIT_Term_values_08, NCIT_Term_values_09,
#              NCIT_Term_values_10, NCIT_Term_values_11, NCIT_Term_values_12, NCIT_Term_values_13, NCIT_Term_values_14,
#              NCIT_Term_values_15, NCIT_Term_values_16, NCIT_Term_values_17, NCIT_Term_values_18, NCIT_Term_values_19) |>
#     tally()  |>
#     arrange(desc(n))

# write_tsv(NCIT_term_values_sum, "/Data/NCIT_term_values_summary.tsv")
# write_tsv(NCIT_term_values_sum_multiple, "/Data/NCIT_term_values_multiple_summary.tsv")



# # The code below summerizes all of the metadata variables in one file
# # datadir <- "/Data/analysis_ready_metadata"
# # file_paths <- list.files(datadir, full.names = T)
# # out_file_path <- "/Data/merged_metadata.tsv"

# # big_column_names <- NULL

# # for (file in file_paths) {
# #     df <- read_tsv(file)
# #     column_names <- as_tibble(colnames(df)) %>%
# #         mutate(df[1, 1], .before = value)

# #     if (is.null(big_column_names)) {
# #         big_column_names <- column_names
# #     } else {
# #         big_column_names <- bind_rows(big_column_names, column_names)
# #     }
# # }

# # big_column_names <- big_column_names[order(big_column_names$value), ]

# # write_tsv(as_tibble(big_column_names), out_file_path)
# # print(paste0("Saved to ", out_file_path))
