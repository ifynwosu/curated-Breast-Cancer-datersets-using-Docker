# This is not a microarray study, so no series matrix file with expression values for getGEO to download.
# Thus we have to download the expression data directly


# get expression data
GSE96058 <- getGEOSuppFiles(GEO = "GSE96058", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE96058_gene_expression_3273_samples_and_136_replicates_transformed.csv.gz")
tmp <- rownames(GSE96058)
GSE96058_expr_table <- read_csv(tmp) %>%
  rename("Gene" = "...1")


# this block of code takes the sample names from the metadada,
# binds them to the expresion matrix which doesnt have any sample names

gseID <- getGEO("GSE96058")
df_HiSeq <- gseID[[1]]
metadata_HiSeq <- pData(df_HiSeq)
gsm_id_HiSeq <- metadata_HiSeq[, c(1, 2)]

df_NextSeq <- gseID[[2]]
metadata_NextSeq <- pData(df_NextSeq)
gsm_id_NextSeq <- metadata_NextSeq[, c(1, 2)]

big_gsm_id <- bind_rows(gsm_id_HiSeq, gsm_id_NextSeq)

big_gsm_id <- as_tibble(t(big_gsm_id), rownames = NA) %>%
  rownames_to_column(var = "rowname")

big_gsm_id[1, 1] <- "Gene"
column_name <- big_gsm_id[1, ]
colnames(big_gsm_id) <- column_name
big_gsm_id <- big_gsm_id[-1, ]

GSE96058_expr_table <- GSE96058_expr_table %>%
  mutate(across(where(is.double), as.character))

expr_df <- bind_rows(big_gsm_id, GSE96058_expr_table) %>%
  dplyr::select(-contains("repl"))

expr_df[1, 1] <- "Gene"
column_name <- expr_df[1, ]
colnames(expr_df) <- column_name
expr_df <- expr_df[-1, ]

print("Writing GSE96058 to file!")
write_tsv(expr_df, paste0(data_dir, "GSE96058_MSCANBI_Cohort3273.tsv.gz"))
