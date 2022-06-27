# There seems to be lots of problems with GSE28796.
# However, it is a small dataset with only 12 samples, each of them duplicated, for a total of 24 samples
# Options to handle this are
#   A) Filter the dataset and remove the duplicates
#   B) Remove the entire dataset (mimimal no of samples)

if ((file_path1 == "/Data/normalized_data/GSE28796.tsv.gz") | (file_path2 == "/Data/normalized_data/GSE28796.tsv.gz")) {
    # This combination was hanging. We couldn't figure out how to fix it, so we are skipping this combination.
    next
}


# if ((file_path1 == "/Data/normalized_data/GSE118432.tsv.gz") & (file_path2 == "/Data/normalized_data/GSE1456.tsv.gz")) {
#     # This combination was hanging. We couldn't figure out how to fix it, so we are skipping this combination.
#     next
# }


# if ((file_path1 == "/Data/normalized_data/GSE118432.tsv.gz") & (file_path2 == "/Data/normalized_data/GSE4922.tsv.gz")) {
# #   # This combination was hanging. We couldn't figure out how to fix it, so we are skipping this combination.
#     next
# }


# if ((file_path1 == "/Data/normalized_data/GSE1456.tsv.gz") & (file_path2 == "/Data/normalized_data/GSE7378.tsv.gz")) {
#     # This combination was hanging. We couldn't figure out how to fix it, so we are skipping this combination.
#     next
# }
