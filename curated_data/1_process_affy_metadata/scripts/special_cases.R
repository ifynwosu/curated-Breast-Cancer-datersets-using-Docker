
if (gseID == "GSE1561") {
    metadata <- metadata %>%
      dplyr::select(-starts_with("title")) %>%
      dplyr::select(-starts_with("description"))
}

if (gseID == "GSE2034") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("title")) %>%
     dplyr::select(-starts_with("description"))
}

if (gseID == "GSE2603") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE2990") {
  metadata <- metadata %>%
    dplyr::select(-"title") %>%
    mutate(across(where(is.character), ~replace(., . %in% c("KJ67", "KJ68", "KJ69", "KJX46", "KJX38", "KJ117"), NA)))

}

if (gseID == "GSE3744") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "description")) %>%
    rename(tissue_source = characteristics)
}

if (gseID == "GSE4611") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE5327") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("description")) %>%
    dplyr::rename(er_status = title)
}

if (gseID == "GSE5460") {
  metadata <- metadata %>%
  dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE5764") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "description")) %>%
    separate("characteristics", c("tissue", "mastectomy", "postmenupausal", "subtype"), sep = cumsum(c(13, 25, 28, 40)))

  # metadata <- df$metadata %>%
  #   dplyr::select(-c("title", "description")) %>%
  #   mutate(tissue = substr(characteristics, 1, 13),
  #       mastectomy = substr(characteristics, 14, 38),
  #       postmenupausal = substr(characteristics, 39, 66),
  #       subtype = substr(characteristics, 67, 106))
}

if (gseID == "GSE5847") {
  metadata <- metadata %>%
  mutate(description = sub(";", ",", description)) %>%
  separate("description", c("chemotherapy", "ER_status", "Her2Neu", "TNM_stage", "Clinical_IBC"), sep = ", ") %>%
  mutate(across(chemotherapy, ~str_replace(., "Chemo: ", ""))) %>%
  mutate(across(ER_status, ~str_replace(., "ER: ", ""))) %>%
  mutate(across(Her2Neu, ~str_replace(., "Her2Neu: ", ""))) %>%
  mutate(across(TNM_stage, ~str_replace(., "Stage: ", ""))) %>%
  dplyr::select(-c("title", "er_status", "patient_id", "tnm_stage"))
}

if (gseID == "GSE6434") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE7378") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "characteristics_4")) %>%
    rename(er_status = characteristics)
}

if (gseID == "GSE7390") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "description", "filename"))
}

if (gseID == "GSE7904") {
  metadata <- metadata %>%
    dplyr::select(-c("description", "description_1", "title")) %>%
    dplyr::rename(breast_cancer_subtype = characteristics) %>%
    mutate(across(breast_cancer_subtype, ~str_replace(., "NO", "Normal organelle"))) %>%
    mutate(across(breast_cancer_subtype, ~str_replace(., "NB", "Normal breast")))
    # mutate(across(breast_cancer_subtype, ~case_when(. == "NO" ~ "Normal organelle", . == "NB" ~ "Normal breast", TRUE ~ as.character(.))))
}

if (gseID == "GSE8977") {
  metadata <- metadata %>%
    dplyr::select(-"description") %>%
    rename(tissue_source = characteristics) %>%
    rename(tissue_type = title) %>%
    mutate(tissue_type = "Stroma")
}

if (gseID == "GSE9195") {
  metadata <- metadata %>%
  dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE9574") {
  metadata <- metadata %>%
  dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE10780") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "description")) %>%
    dplyr::rename(tissue_type = characteristics)
}

if (gseID == "GSE10797") {
  metadata <- metadata %>%
  rename(tissue_source = characteristics) %>%
  rename(replicate = title) %>%
  mutate(across(replicate, ~str_replace(., "cancer_epithelial_rep", ""))) %>%
  mutate(across(replicate, ~str_replace(., "cancer_stroma_rep", ""))) %>%
  dplyr::select(-"description")
}

if (gseID == "GSE11121") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "description", "storage"))
}

if (gseID == "GSE12093") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("characteristics_ch1")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE12276") {
  metadata <- metadata %>%
  dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE16391") {
  metadata <- metadata %>%
    rename(`tumor_size_<=_2cm_=_1_>_2cm_=2` = size) %>%
    rename(`treatment_Letrozol_=_0_Tamoxifen_=_1` = treatment) %>%
    rename(`node_node_negative_=_0_node_positive_=_1` = node) %>%
    rename(`local_therapy_BCS/RT_=_1_BCS/no_RT_=_2_Mx/RT_=_3` = local_therapy) %>%
    rename(tumor_grade = grade) %>%
    rename(`ER_PgR_ER+/PgR+_=_1_ER+/PgR_=_2` = er_pgr) %>%
    rename(`post_menopausal_status_before_chemotherapy_=_1_after_chemotherapy_=_2` = post_menopausal_status) %>%
    dplyr::select(-starts_with("description")) %>%
    dplyr::select(-c("title", "tissue"))
}

if (gseID == "GSE16446") {
  metadata <- metadata %>%
  dplyr::select(-c("title", "description", "final_analysis"))
}

if (gseID == "GSE16873") {
  metadata <- metadata %>%
  dplyr::select(-c("title", "label_protocol_1", "description", "tissue"))
}

if (gseID == "GSE17705") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description")) %>%
    dplyr::select(-starts_with("tissue"))
}

if (gseID == "GSE17907") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE18864") {
  metadata <- metadata %>%
    dplyr::select(-("description")) %>%
    separate("er_pr_her2_status", c("er_status", "pr_status", "her2_status"), sep = "/")
}

if (gseID == "GSE19615") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description")) %>%
    dplyr::select(-starts_with("tissue"))
}

if (gseID == "GSE19697") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE20086") {
  metadata <- metadata %>%
    dplyr::select(-starts_with("title")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE20181") {
  metadata <- metadata %>%
    dplyr::select(-starts_with(c("title", "description", "tissue", "characteristics", "subject")))
}

if (gseID == "GSE20194") {
  metadata <- metadata %>%
    dplyr::select(-starts_with(c("title", "description", "tissue")))
}

if (gseID == "GSE20271") {
  metadata <- metadata %>%    
    dplyr::select(-starts_with(c("title", "description", "array", "biopsy", "surgery date")))
}

if (gseID == "GSE20437") {
  metadata <- metadata %>%
    dplyr::select(-starts_with(c("tissue", "description"))) %>%
    rename(histology = title) %>%
    mutate(across(histology, ~str_replace(., "reduction mammoplasty", "normal")))
}

if (gseID == "GSE20685") {
  metadata <- metadata %>%
    dplyr::select(-starts_with(c("title", "tissue", "characteristics_ch1", "description")))
}

if (gseID == "GSE20711") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-("description")) %>%
    dplyr::select(-starts_with("methylation")) %>%
    dplyr::select(-starts_with("quality"))
}

if (gseID == "GSE21653") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-("description")) %>%
    dplyr::select(-starts_with("tissue"))
}

if (gseID == "GSE21947") {
  metadata <- metadata %>%
    rename(histology = title) %>%
    mutate(er_status = ifelse(is.na(er_status), specimen, er_status)) %>%
    mutate(histology = str_sub(histology, 1, 39)) %>%
    mutate(er_status = str_sub(er_status, 1, 3)) %>%
    dplyr::select(-c("description", "breast_cancer_patient_id", "disease_state", "specimen", "tissue"))
}

if (gseID == "GSE22513") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-("description")) %>%
    dplyr::select(-starts_with("tissue"))
}

if (gseID == "GSE24185") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-starts_with("description")) %>%
    dplyr::select(-starts_with("disease"))
}

if (gseID == "GSE25055") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "sample_id", "tissue", "characteristics_23"))
}

if (gseID == "GSE25065") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "sample_id", "tissue"))
}

if (gseID == "GSE26910") {
  metadata <- metadata %>%
    dplyr::filter(grepl("breast", title)) %>%
    dplyr::select(-c("description", "tissue", "title"))
}

if (gseID == "GSE28796") {
  metadata <- metadata %>%
    dplyr::select(-starts_with(c("description", "title", "tissue")))
}

if (gseID == "GSE28821") {  #examine associated journal article. suggests TNBC
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-starts_with("description")) %>%
    dplyr::select(-starts_with("tissue"))
}

if (gseID == "GSE31138") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "tissue")) %>%
    dplyr::select(-starts_with("description"))
}

if (gseID == "GSE31192") {
  metadata <- metadata %>%
    separate("title", c("patient_id", "A", "er_status", "cell_type_1", "cell_type_2"), sep = ", ") %>%
    rename(cell_type_3 = cell_type) %>%
    dplyr::select(-c("A", "description", "description_1", "tissue"))
}

if (gseID == "GSE31519") {
  metadata <- metadata %>%
    dplyr::select(-starts_with(c("title", "description"))) %>%
    rename(breast_cancer_subtype = tissue) %>%
    rename_with(~str_replace_all(., "_0", "")) %>%
    rename_with(~str_replace_all(., "_1", "")) %>%
    rename_with(~str_replace_all(., "2", ""))

  #biopsy type (1: surgical, 2: core needle)
  metadata <- metadata %>%
    mutate(across(biopsy_type, ~str_replace(., "surgical, 2: core needle\\)\\:", ""))) %>%
    mutate(across(biopsy_type, ~str_replace(., "1", "surgical"))) %>%
    mutate(across(biopsy_type, ~str_replace(., "2", "core needle")))

  #event (1: yes, 0: no)
  metadata <- metadata %>%
    mutate(across(event, ~str_replace(., "yes, 0: no\\)\\:", ""))) %>%
    mutate(across(event, ~str_replace(., "0", "no"))) %>%
    mutate(across(event, ~str_replace(., "1", "yes")))

  #grade (12: G1 or G2, 3: G3)
  metadata <- metadata %>%
    mutate(across(grade, ~str_replace(., "G1 or G2, 3\\: G3\\)\\:", ""))) %>%
    mutate(across(grade, ~str_replace(., "12", "G1 or G2"))) %>%
    mutate(across(grade, ~str_replace(., "3", "G3")))

  #lymph node status (0: negative, 1: positive)
  metadata <- metadata %>%
    mutate(across(lymph_node_status, ~str_replace(., "negative, 1\\: positive\\)\\: ", ""))) %>%
    mutate(across(lymph_node_status, ~str_replace(., "0", "negative"))) %>%
    mutate(across(lymph_node_status, ~str_replace(., "1", "positive")))

  #tumor size (1: up to 1 cm, 2: >1cm)
  metadata <- metadata %>%
    mutate(across(tumor_size, ~str_replace(., "up to 1 cm, 2\\: \\>1cm\\)\\:", ""))) %>%
    mutate(across(tumor_size, ~str_replace(., "1", "up to 1 cm"))) %>%
    mutate(across(tumor_size, ~str_replace(., "2", "greater than 1 cm")))
}

if (gseID == "GSE32518") {
  metadata <- metadata %>%
    rename(treatment_status = description) %>%
    mutate(across(treatment_status, ~str_replace(., "Gene expression data from breast cancer FNA biopsy, ", ""))) %>%
    mutate(across(treatment_status, ~str_replace(., "Gene expression data from breast cancer CBX biopsy, ", ""))) %>%
    dplyr::select(-c("title", "tissue"))
}

if (gseID == "GSE32646") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "tissue"))
}

if (gseID == "GSE33692") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-starts_with("data_processing"))
}

if (gseID == "GSE45255") {
  metadata <- metadata %>%
    dplyr::select(-starts_with(c("title", "description"))) %>%
    rename(`endocrine_0=no_1=yes` = characteristics_9) %>%
    mutate(across(`endocrine_0=no_1=yes`, ~str_replace(., "characteristics\\: endocrine\\? \\(0\\=no, 1\\=yes\\):", "")))
}

if (gseID == "GSE46184") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-("description"))
}

if (gseID == "GSE48391") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "description", "tissue"))
}

if (gseID == "GSE50948") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "patid"))
}

if (gseID == "GSE57968") {
  metadata <- metadata %>%
    dplyr::select(-("title"))
}

if (gseID == "GSE58644") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-("description"))
}

if (gseID == "GSE58984") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-("description"))
}

#GSE59772 is triple negative according to GEO website
if (gseID == "GSE59772") {
  metadata <- metadata %>%
  rename(replicate = title) %>%
  dplyr::select(-("description"))
}

if (gseID == "GSE76275") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "characteristics_18", "description", "data_processing_1", "tissue"))
}

if (gseID == "GSE81838") {
  metadata <- metadata %>%
    dplyr::select(-("title"))
}

if (gseID == "GSE86374") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-("description"))
}

if (gseID == "GSE90521") {
  metadata <- metadata %>%
    dplyr::select(-("title")) %>%
    dplyr::select(-("description"))
}

if (gseID == "GSE111662") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "description", "organ", "subject_id", "tissue_abbrevation"))
}

if (gseID == "GSE118432") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "characteristics_4", "description"))
}

if (gseID == "GSE120129") {
  metadata <- metadata %>%
    dplyr::select(- ("title"))
}

if (gseID == "GSE167213") {
  metadata <- metadata %>%
    dplyr::select(-c("title", "description", "tissue"))
}