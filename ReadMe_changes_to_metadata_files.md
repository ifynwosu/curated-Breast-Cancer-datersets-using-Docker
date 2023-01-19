# Changes we made to the meta data files after the first round of processing

GSE3744 - Because there are no replicates, I don't think we need the description column. "characteristics_ch1" has the information we need. Rename the "characteristics_ch1" column to "tissue_source".
GSE2990
In the "age" column, the KJ67, KJ68, and KJ69 values refer to the cohort (based on my interpretation from this paper). Change these to "NA". 
In the "time rfs" column, the KJX46, KJX38, KJ117 values refer to the cohort. Change these to "NA".
GSE8977 - The "description" column doesn't add anything. Please remove it. Rename "characteristics_ch1" to "tissue_source".
GSE7904 - Because there are no replicates, remove "title". Rename "characteristics_ch1" to "breast_cancer_subtype".
GSE7378 - Remove the description column. Replace it with a new column name = er_status. Values = positive. The other information is expressed in the other columns. Rename "characteristics_ch1" to "er_status".
GSE5847 - Split the description column out into multiple columns: Chemo, Her2Neu, Stage, Clinical IBC. There is already an er_status column. Some of the samples are missing tnm_status, so remove this column and replace it with what you obtain from the description column. Clinical IBC appears to be an extension of what we see in the diagnosis column, so that information is useful to keep.
GSE5764 - Split the "characteristics_ch1" column into: tissue, mastectomy, postmenopausal, subtype.
GSE6532
U133C should be called U133Plus2
U133A should have 327 samples, but it has 87
U133C should have 87 samples, but it has 327
GSE16446 - Remove description column. Remove final_analysis column.
GSE16391 - Remove the description columns. Rename many of the other columns to match what is in the description columns. For example, change "post menopausal status" to "Post.menopausal.status: before chemotherapy = 1, after chemotherapy = 2". Change "size" to "size: tumor size <= 2cm = 1, tumor size > 2cm = 2". Do the same for others.
GSE11121 - Remove "storage".
GSE10797 - Rename "title" to "replicate". Simplify the values in this column so that they just have the replicate number (1 or 2, etc.). Rename "characteristics_ch1" to "tissue_source".
GSE28796 - Split "title" into two columns: "sample_id" and "replicate". The "sample_id" values should be 1, 2, 3, etc. The replicate values should be 1 or 2.
GSE26910 - Rename "title" to "sample_id". The values should be 1, 2, 3, etc.
GSE21947 - Split "title" into multiple columns: "histology" and "sample_id". The values in "histology" should be "histologically normal breast epithelium". The values in "sample_id" should be 1, 2, 3, etc. (remove "351H", etc.). The "er status" column needs to be fixed. Some of the samples are missing a value. Remove this column and create a new "er_status" that has the values in the title column. Remove the "disease state" column. According to the paper, these samples are all from normal cells.
GSE20685 - Remove "title" because there are not replicates.
GSE20437 - Rename "title" to "histology". Set all values to "normal breast epithelium" (reduction mammoplasty are also histologically normal).
GSE20194 - Remove "description.1".
GSE45255 - Remove "description.2" and "description.3". Rename "characteristics" to "endocrine? (0=no, 1=yes)". The values should be either 0 or 1.
GSE32518 - Rename "description" to "treatment_status" and change all the values to "pre-treatment". All the rest of the information is in other columns.
GSE31519 - Rename "title" to "breast_cancer_subtype" and set the values to "Triple-negative breast cancer". There are no replicates, so we don't need the sample ids.
GSE31192 - Rename "title" to "er_status" and indicate whether each patient was positive or negative based on the title. The other columns already have the other information in "title".
GSE81838 - Rename "title" to "sample_id" and simplify these to 1, 2, 3, etc.
GSE59722 - Rename "title" to "sample_id" and simplify these to 1, 2, 3, etc.
GSE4922_U133A and GSE4922_U133B - Remove "All patients (1=included in survival analysis):ch1". Remove ":ch1" from the end of the column names.
GSE5327 - Change "title" to "er_status" and set values to "negative".
GSE10780 - Rename "characteristics_ch1" to "tissue_type".
GSE18864 - Split "er/pr/her2 status" into three columns, one per IHC type. The values should be "neg" or "pos".