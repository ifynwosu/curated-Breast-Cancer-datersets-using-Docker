
file_paths <- list.files(meta_expr_matched_data, full.names = TRUE)

special_cases <- c("GSE62944_Tumor.tsv", "GSE62944_Normal.tsv", "GSE81538.tsv", "GSE96058_HiSeq.tsv",
                   "GSE96058_NextSeq.tsv", "ICGC_KR.tsv", "METABRIC.tsv")

SCAN_B <- c("ABiM.100.tsv", "ABiM.405.tsv", "Normal.66.tsv", "OSLO2EMIT0.103.tsv", "SCANB.9206.tsv")

# The lines of code below are useful in identifying duplicates. 
# We used it to decide on how to filter the gene list from biomart
# dup_id <- data.frame(table(gene_list$ensembl_gene_id))
# dup_id[dup_id$Freq > 1,]
# dup_id <- gene_list[duplicated(gene_list$ensembl_gene_id),]

# Specify a BioMart database and a specific dataset inside the database.
ensembl <- useMart(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")

rename_df <- function(expr_file) {
    df <- expr_file |>
        rename(Dataset_ID = Dataset) |>
        rename(Entrez_Gene_ID = entrezgene_id) |>
        rename(Ensembl_Gene_ID = ensembl_gene_id) |>
        rename(HGNC_Symbol = hgnc_symbol) |>
        rename(Gene_Biotype = gene_biotype) |>
        rename(Chromosome = chromosome_name)

    return(df)
}

entrez_geneSymbol <- function(expr_file) {
    expr_data <- read_tsv(expr_file)
    new_df <- mutate(expr_data, across(Gene, ~str_replace(., "_at", ""))) |>
        mutate(across(Gene, as.integer)) |>
        rename(entrezgene_id = Gene)
    entrez_ID <- (new_df$entrezgene_id)

    # match gene ids to ensemble database
    gene_list <- getBM(attributes = c("entrezgene_id", "ensembl_gene_id", "chromosome_name", "hgnc_symbol", "gene_biotype"),
                       filters = "entrezgene_id",
                       values = entrez_ID,
                       mart = ensembl) |>
        mutate(across(entrezgene_id, as.integer))
    
    # filter off duplicate genes
    filtered_gene_list <- gene_list |>
        filter(!str_detect(chromosome_name, "^CHR")) |>    # this gets rid of genes from the haplotypic regions
        distinct(ensembl_gene_id, .keep_all = TRUE)

    big_df <- left_join(new_df, filtered_gene_list, by = "entrezgene_id") |>
        dplyr::select(Dataset, entrezgene_id, hgnc_symbol, ensembl_gene_id, chromosome_name, gene_biotype, everything()) |>
        rename_df() |>
        mutate(across(where(is.character), ~na_if(., ""))) |>
        na.omit()

    return(big_df)
}

HGNC_geneSymbol <- function(expr_file) {
    expr_data <- read_tsv(expr_file) |>
        rename(hgnc_symbol = HGNC)    
    HGNC_ID <- (expr_data$hgnc_symbol)

    # match gene ids to ensemble database
    gene_list <- getBM(attributes = c("entrezgene_id", "ensembl_gene_id", "chromosome_name", "hgnc_symbol", "gene_biotype"),
                        filters = "hgnc_symbol",
                        values = HGNC_ID,
                        mart = ensembl)
    
    # filter off duplicate genes
    filtered_gene_list <- gene_list |>
        filter(!str_detect(chromosome_name, "^CHR")) |>    # this gets rid of genes from the haplotypic regions
        distinct(ensembl_gene_id, .keep_all = TRUE)
    
    # merge files
    big_df <- left_join(expr_data, filtered_gene_list, by = "hgnc_symbol") |>
        dplyr::select(Dataset, entrezgene_id, hgnc_symbol, ensembl_gene_id, chromosome_name, gene_biotype, everything()) |>
        rename_df() |>
        mutate(across(where(is.character), ~na_if(., ""))) |>
        na.omit()

    return(big_df)
}

ensemble_geneSymbol <- function(expr_file) {
    expr_data <- read_tsv(expr_file) |>
        dplyr::filter(!str_detect(Gene, "PAR_Y")) |>
        rename(ensembl_gene_id = Gene)
        
    expr_data$ensembl_gene_id <- gsub("\\..+$", "", expr_data$ensembl_gene_id)
    # expr_data$ensembl_gene_id <- as.character(expr_data$ensembl_gene_id)
    ensembl_id <- (expr_data$ensembl_gene_id)

    # match gene ids to ensemble database
    gene_list <- getBM(attributes = c("entrezgene_id", "ensembl_gene_id", "chromosome_name", "hgnc_symbol", "gene_biotype"),
                       filters = "ensembl_gene_id",
                       values = ensembl_id,
                       mart = ensembl)
  
    # filter off duplicate genes
    filtered_gene_list <- gene_list |>
        distinct(ensembl_gene_id, .keep_all = TRUE)
  
    # merge files
    big_df <- left_join(expr_data, filtered_gene_list, by = "ensembl_gene_id") |>
        dplyr::select(Dataset, entrezgene_id, hgnc_symbol, ensembl_gene_id, chromosome_name, gene_biotype, everything()) |>
        rename_df() |>
        mutate(across(where(is.character), ~na_if(., ""))) |>
        na.omit()

    return(big_df)
}

for (file in file_paths) {
    cat("\n")
    print(paste0("Reading in ", file, "!"))
    cat("\n")

    file_name <- file |> basename() |> file_path_sans_ext()
    out_file_path <- paste0(analysis_ready_expr_data, file_name, ".gz")

    if (file_name %in% special_cases) {
        gene_df <- HGNC_geneSymbol(file)
    } else if (file_name %in% SCAN_B) {
        gene_df <- ensemble_geneSymbol(file)
    } else {
        gene_df <- entrez_geneSymbol(file)
    }

    gene_df <- gene_df[order(gene_df$Entrez_Gene_ID), ]
    
    write_tsv(gene_df, out_file_path)
}
