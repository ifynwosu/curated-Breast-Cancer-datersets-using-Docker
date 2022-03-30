#required libraries
library(GEOquery)
# if download times out, use this option to allow for longer download times
options(download.file.method.GEOquery ="wget")
# alternatives
# options('download.file.method.GEOquery'='curl')
# options('download.file.method.GEOquery' = 'libcurl')
library(SCAN.UPC)
library(tidyverse)
library(doParallel)

registerDoParallel(cores=8)

#Read in list of gseID's
gseID_list <- read_tsv("gene_exp.tsv", col_names = F, comment = "#") %>%
  select(c(X1,X3)) %>%
  rename("gseID" = X1, "geneChip" = X3)

huExon <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Exon 1.0 ST Array [transcript (gene) version]")

huGene <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Gene 1.0 ST Array [transcript (gene) version]")

U133_A_Early_Access <- gseID_list %>%
    filter(geneChip == "Affymetrix GeneChip HT-HG_U133A Early Access Array")

U133_A <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Genome U133A Array") 

U133_A2 <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Genome U133A 2.0 Array")

U133_plus_2 <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Genome U133 Plus 2.0 Array")

U95_2 <- gseID_list %>%
    filter(geneChip == "Affymetrix Human Genome U95 Version 2 Array")

# Define the file path to the data directory
data_dir <- "/Data"

# Define the file path to a temp directory for saving RAW data
tmp_dir = "/tmp"

if (!dir.exists(tmp_dir)) {
    dir.create(tmp_dir)
}

SCAN_normalise <- function(gseID, annotation_package, probe_summary, GSM_to_exclude = c(), output_filename = NULL) {
    
    if (is.null(output_filename)) {
        out_file_path = paste0("/Data/", gseID, ".tsv.gz")
        
    }   else {
        out_file_path = paste0("/Data/", output_filename, ".tsv.gz")
    }
    
    if (file.exists(out_file_path)) {
        print(paste0(gseID," has already been processed!"))
    }   else {
            print(paste0("Downloading ", gseID, " for processing!"))
            GSE <-getGEOSuppFiles(gseID, makeDirectory = F)
            tmp <- rownames(GSE)
            untar(tmp[1], exdir = tmp_dir)
            celFilePaths = list.files(tmp_dir, pattern = "*.CEL", full.names = T, ignore.case = T)

            all_normalized = NULL

            for (celFilePath in celFilePaths) {
                gsm_id = basename(celFilePath)
                gsm_id = gsub("\\.cel.gz", "", gsm_id, ignore.case = TRUE)

                if (gsm_id %in% GSM_to_exclude) {
                    next
                }

                normalized = exprs(SCAN(celFilePath, annotationPackageName = annotation_package, probeSummaryPackage = probe_summary))
                genes = rownames(normalized)
                normalized = as_tibble(normalized) %>%
                mutate(Gene = genes) %>%
                dplyr::select(Gene, all_of(basename(celFilePath)))

                colnames(normalized)[2] = gsm_id

                if (is.null(all_normalized)) {
                    all_normalized = normalized
                }   else {
                        all_normalized = inner_join(all_normalized, normalized, by = "Gene")
                }
            }
            write_tsv(all_normalized, out_file_path)
            print(paste0("Saved to ", out_file_path))
    }
}

# To run individual GSE ids, run the code line below, substituting with actual values
# e.g 
# SCAN_normalise("GSE118432", "pd.hugene.1.0.st.v1", "hugene10sthsentrezgprobe")

#done
# for (gseID in huExon$gseID){
# SCAN_normalise(gseID, "pd.huex.1.0.st.v2", "huex10sthsentrezgprobe")
# }

#done
# for(gseID in huGene$gseID){
#   SCAN_normalise(gseID, "pd.hugene.1.0.st.v1", "hugene10sthsentrezgprobe")
# }

#done
#for(gseID in U133A_Early_Access$gseID){
#   SCAN_normalise(gseID, "pd.ht.hg.u133a", "u133aaofav2hsentrezgprobe")
# }

#done
# for(gseID in U95_2$gseID){
#   SCAN_normalise(gseID, "pd.hg.u95av2", "hgu95av2hsentrezgprobe")
# }

#done
# for (i in 1:length(U133_A2$gseID)) {
# SCAN_normalise((U133_A2$gseID)[i], "pd.hg.u133a.2", "hgu133a2hsentrezgprobe")
# }

for (gseID in U133_A$gseID) {
SCAN_normalise(gseID, "pd.hg.u133a", "hgu133ahsentrezgprobe")
}

# we are excluding c("GSM125119", "GSM125120") in GSE5460 because the are listed as corrupted on GEO website
# for (gseID in U133_plus_2$gseID) {
# SCAN_normalise(gseID, "pd.hg.u133.plus.2", "hgu133plus2hsentrezgprobe", c("GSM125119", "GSM125120"))
# }

#list.files(baseDir, pattern = glob2rx("*.csv"), full.names = TRUE, ignore.case = FALSE)[1]
#http://brainarray.mbni.med.umich.edu/Brainarray/Database/CustomCDF/25.0.0/entrezg.asp
#http://brainarray.mbni.med.umich.edu/Brainarray/Database/CustomCDF/CDF_download.asp

