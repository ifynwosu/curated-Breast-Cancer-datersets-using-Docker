# This is not a microarray study, so no series matrix file with expression values for getGEO to download.
# Thus we have to download the expression data directly

# get expression data
GSE81538 <- getGEOSuppFiles(GEO = "GSE81538", makeDirectory = F, baseDir = tmp_dir, filter_regex = "GSE81538_gene_expression_405_transformed.csv.gz")
tmp <- rownames(GSE81538)
GSE81538_expr_table <- read_csv(tmp) %>%
  rename("Gene" = "...1")

# this block of code takes the sample names from the metadada,
# binds them to the expresion matrix which doesnt have any sample names

gseID <- getGEO("GSE81538")
df <- gseID[[1]]
metadata <- pData(df)
gsm_id <- metadata[, c(1, 2)]

gsm_id <- as_tibble(t(gsm_id), rownames = NA) %>%
  rownames_to_column(var = "rowname")

gsm_id[1, 1] <- "Gene"
column_name <- gsm_id[1, ]
colnames(gsm_id) <- column_name
gsm_id <- gsm_id[-1, ]

GSE81538_expr_table <- GSE81538_expr_table %>%
  mutate(across(where(is.double), as.character))

expr_df <- bind_rows(gsm_id, GSE81538_expr_table)
expr_df[1, 1] <- "Gene"
column_name <- expr_df[1, ]
colnames(expr_df) <- column_name
expr_df <- expr_df[-1, ]

print("Writing GSE81538 to file!")
write_tsv(expr_df, paste0(data_dir, "GSE81538_MSCANBI_Cohort405_HiSeq.tsv.gz"))
