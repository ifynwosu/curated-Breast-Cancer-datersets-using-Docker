library(GEOquery)
library(tidyverse)

dual_chips <- c("GSE1456", "GSE3494", "GSE4922")

getDualGEO <- function(geoID) {
  gseData <- getGEO(geoID)

  U133A <- gseData[[1]]
  U133B <- gseData[[2]]

  exprsData_A <- exprs(U133A) %>%
    as_tibble(rownames = NA) %>%
    rownames_to_column(var = "geneID")

  meta_A <- pData(U133A) %>%
    as_tibble(rownames = NA) %>%
    clean_names() %>%
    dplyr::rename(Sample_ID = geo_accession) %>%
    dplyr::select(Sample_ID, everything()) %>%
    mutate(Dataset_ID = geoID, .before = Sample_ID)

  exprsData_B <- exprs(U133B) %>%
    as_tibble(rownames = NA) %>%
    rownames_to_column(var = "geneID")

  meta_B <- pData(U133B) %>%
    as_tibble(rownames = NA) %>%
    clean_names() %>%
    dplyr::rename(Sample_ID = geo_accession) %>%
    dplyr::select(Sample_ID, everything()) %>%
    mutate(Dataset_ID = geoID, .before = Sample_ID)

  return(list(expression_data_A = exprsData_A, metadata_A = meta_A, expression_data_B = exprsData_B, metadata_B = meta_B))
}

clean_metadata_Dual <- function(meta) {
  metadata <- meta %>%
    removeUnusefulCols() %>%
    rename_with(~str_replace_all(., "_ch1", "")) %>%
    dplyr::select(-c("title", "description")) %>%
    dplyr::select(-starts_with("characteristics"))

  return(metadata)
}

for (gseID in dual_chips) {
    df <- getDualGEO(gseID)

    # write un-curated metadata to file
    write_tsv(df$metadata_A, file.path(raw_metadata_dir, paste0(gseID, "_U133A.tsv")))
    write_tsv(df$metadata_B, file.path(raw_metadata_dir, paste0(gseID, "_U133B.tsv")))

    # remove unuseful columns
    metadata_A <- clean_metadata_Dual(df$metadata_A)
    metadata_B <- clean_metadata_Dual(df$metadata_B)

    # summarise variables
    varSummary_A <- summariseVariables(metadata_A)
    varSummary_B <- summariseVariables(metadata_B)

    #write cleaned up data to files
    if ((ncol(metadata_A) > 2)) {
      write_tsv(metadata_A, file.path(metadata_dir, paste0(gseID, "_U133A.tsv")))
      write_tsv(metadata_B, file.path(metadata_dir, paste0(gseID, "_U133B.tsv")))
    }

    if (!is.null(varSummary_A$numSummary)) {
      write_tsv(varSummary_A$numSummary, file.path(metadata_summaries, paste0(gseID, "_U133A_num.tsv")))
      write_tsv(varSummary_B$numSummary, file.path(metadata_summaries, paste0(gseID, "_U133B_num.tsv")))
    }

    if (!is.null(varSummary_A$charSummary)) {
      write_tsv(varSummary_A$charSummary, file.path(metadata_summaries, paste0(gseID, "_U133A_char.tsv")))
      write_tsv(varSummary_B$charSummary, file.path(metadata_summaries, paste0(gseID, "_U133B_char.tsv")))
    }
}

gseData <- getGEO("GSE6532")

U133A <- gseData[[2]]
U133B <- gseData[[3]]
U133Plus2 <- gseData[[1]]

exprs_meta_data <- function(chipID) {
  exprsData <- exprs(chipID) %>%
    as_tibble(rownames = NA) %>%
    rownames_to_column(var = "geneID")

  meta <- pData(chipID) %>%
    clean_names() %>%
    dplyr::rename(Sample_ID = geo_accession) %>%
    dplyr::select(Sample_ID, everything()) %>%
    mutate(Dataset_ID = "GSE6532", .before = Sample_ID)

  return(list(expression_data = exprsData, metadata = meta))
}

df_U133A <- exprs_meta_data(U133A)
df_U133B <- exprs_meta_data(U133B)
df_U133Plus2 <- exprs_meta_data(U133Plus2)

write_tsv(df_U133A$metadata, file.path(raw_metadata_dir, paste0("GSE6532_U133A.tsv")))
write_tsv(df_U133B$metadata, file.path(raw_metadata_dir, paste0("GSE6532_U133B.tsv")))
write_tsv(df_U133Plus2$metadata, file.path(raw_metadata_dir, paste0("GSE6532_U133Plus2.tsv")))

clean_metadata <- function(chip) {
  metadata <- chip$metadata %>%
    removeUnusefulCols() %>%
    rename_with(~str_replace_all(., "_ch1", "")) %>%
    dplyr::select(-c("title", "description")) %>%
    mutate(across(where(is.character), ~replace(., . %in% c("KJ67", "KJ68", "KJ69", "KJX46", "KJX38", "KJ117"), NA)))
  return(metadata)
}

metadata_A <- clean_metadata(df_U133A) %>%      #The following variables are prsent in A but not B & C (distant_rfs, ggi, time_rfs)
  dplyr::select(-starts_with("characteristics_"))
metadata_B <- clean_metadata(df_U133B)
metadata_C <- clean_metadata(df_U133Plus2)

# summarise variables
varSummary_A <- summariseVariables(metadata_A)
varSummary_B <- summariseVariables(metadata_B)
varSummary_C <- summariseVariables(metadata_C)

#write cleaned up data to files
write_tsv(metadata_A, file.path(metadata_dir, paste0("GSE6532_U133A.tsv")))
write_tsv(metadata_B, file.path(metadata_dir, paste0("GSE6532_U133B.tsv")))
write_tsv(metadata_C, file.path(metadata_dir, paste0("GSE6532_U133Plus2.tsv")))

if (!is.null(varSummary_A$numSummary)) {
  write_tsv(varSummary_A$numSummary, file.path(metadata_summaries, paste0("GSE6532_U133A_num.tsv")))
  write_tsv(varSummary_B$numSummary, file.path(metadata_summaries, paste0("GSE6532_U133B_num.tsv")))
  write_tsv(varSummary_C$numSummary, file.path(metadata_summaries, paste0("GSE6532_U133Plus2_num.tsv")))
}

if (!is.null(varSummary_A$charSummary)) {
  write_tsv(varSummary_A$charSummary, file.path(metadata_summaries, paste0("GSE6532_U133A_char.tsv")))
  write_tsv(varSummary_B$charSummary, file.path(metadata_summaries, paste0("GSE6532_U133B_char.tsv")))
  write_tsv(varSummary_C$charSummary, file.path(metadata_summaries, paste0("GSE6532_U133Plus2_char.tsv")))
}