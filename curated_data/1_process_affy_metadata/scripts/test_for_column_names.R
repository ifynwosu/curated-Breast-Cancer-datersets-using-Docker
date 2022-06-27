
source("scripts/LoadLibraries.R")
source("functions/getFromGEO.R")
source("functions/summarise_test.R")

gseIDs <- read_tsv("/Data/gseIDs.tsv", col_names = F, comment = "#") %>%
  dplyr::select(c(X1, X3)) %>%
  dplyr::rename("gseID" = X1, "geneChip" = X3)

keep_varible <- c("Affymetrix Human Exon 1.0 ST Array [transcript (gene) version]", "Affymetrix Human Gene 1.0 ST Array [transcript (gene) version]", 
                  "Affymetrix Human Genome U95 Version 2 Array", "Affymetrix GeneChip HT-HG_U133A Early Access Array", 
                  "Affymetrix Human Genome U133A Array", "Affymetrix Human Genome U133A 2.0 Array", "Affymetrix Human Genome U133 Plus 2.0 Array")


gseID_list <- NULL

for (i in seq_along(gseIDs$geneChip)) {
    keep_sample <- gseIDs$geneChip[i]
    if (keep_sample %in% keep_varible) {
        gseID_list <- rbind(gseID_list, gseIDs$gseID[i])
    }
}

for (gseID in gseID_list) {
    df <- getFromGEO(gseID)

    meta <- df$metadata %>%
        mutate_all(type.convert, as.is = TRUE)

    #summarise variables
    varSummary <- summariseVariables(meta)

}

#summerize variables