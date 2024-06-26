
meta_dir <- "/Data/prelim_metadata"
file_paths_meta <- list.files(meta_dir, full.names = T)

expr_dir <- "/Data/IQRray_filtered_data"
file_paths_expr <- list.files(expr_dir, full.names = T)

good_match <- c("GSE62944_Tumor.tsv", "GSE62944_Normal.tsv", "ABiM_100", "ABiM_405", "Normal_66", "OSLO2EMIT0_103", "SCANB_9206")

# SCAN_B <- c("ABiM_100", "ABiM_405", "Normal_66", "OSLO2EMIT0_103", "SCANB_9206")

special_cases <- c("GSE81538.tsv", "GSE96058_HiSeq.tsv", "GSE96058_NextSeq.tsv", "ICGC_KR.tsv", "METABRIC.tsv")


for (i in seq_along(file_paths_meta)) {

    meta_file <- (file_paths_meta[i])
    meta_data <- read_tsv(meta_file)

    expr_file <- (file_paths_expr[i])
    expr_data <- read_tsv(expr_file)

    filename_meta <- meta_file %>% basename() %>% file_path_sans_ext()
    filename_expr <- expr_file %>% basename() %>% file_path_sans_ext()
    
    meta_path <- paste0(analysis_ready_meta_data, filename_meta, ".tsv")
    expr_path <- paste0(meta_expr_matched_data, filename_expr, ".gz")

    Sample_ID <- names(expr_data)[3:ncol(expr_data)]
    all_samples <- meta_data %>%
        pull(Sample_ID)
    keep_samples <- intersect(Sample_ID, all_samples)

    if (file.exists(expr_path)) {
        cat("\n")
        print(paste0(filename_expr, " has already been processed!"))
        cat("\n")
    } else {
        if (filename_expr %in% good_match) {
            clean_meta_data <- meta_data
            clean_expr_data <- expr_data
        } else if (filename_expr %in% special_cases) {
            clean_meta_data <- meta_data[meta_data$Sample_ID %in% keep_samples, ]
            clean_expr_data <- dplyr::select(expr_data, Dataset, HGNC, all_of(keep_samples))
        } else {
            clean_meta_data <- meta_data[meta_data$Sample_ID %in% keep_samples, ]
            clean_expr_data <- dplyr::select(expr_data, Dataset, Gene, all_of(keep_samples))
        }
        cat("\n")
        print(paste0("Writing ", filename_meta, " to file"))
        cat("\n")
        
        write_tsv(clean_meta_data, meta_path)
        write_tsv(clean_expr_data, expr_path)
    }
}
