library(tidyverse)

gseID_list <- read_tsv("gseIDs.tsv", col_names = F, comment = "#") %>%
    select(c(X1, X3)) %>%
    rename("gseID" = X1, "geneChip" = X3)

huExon <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Exon 1.0 ST Array [transcript (gene) version]")

huGene <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Gene 1.0 ST Array [transcript (gene) version]")

U95_2 <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Genome U95 Version 2 Array")

U133_A_Early_Access <- gseID_list %>%
    filter(geneChip == "Affymetrix GeneChip HT-HG_U133A Early Access Array")

U133_A <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Genome U133A Array")

U133_A2 <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Genome U133A 2.0 Array")

U133_plus_2 <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Genome U133 Plus 2.0 Array")
