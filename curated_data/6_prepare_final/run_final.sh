#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu_bc_data_paper_prepare_final .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd):/6_prepare_final \ n
    -v $HOME/Data:/Data \
    inwosu_bc_data_paper_prepare_final"

$dockerCommand Rscript scripts/clean_expression_data_colnames.R
$dockerCommand Rscript scripts/filter_samples.R 
$dockerCommand Rscript scripts/gene_symbol.R
$dockerCommand Rscript scripts/merge_metadata_summaries.R

# directions for file directories to ensure script runs properly
#change directory for expression files in clean_expression_data_colnames.R (line 4) 
#change directory for "IQRray_dir" (it should point to where IQRray_results from step 3 are stored) in filter_samples.R (line 4)
#change directory for directories "input_dir" (it should point to where filtered results from filter_samples.R are stored) in gene_symbol.R (line 6)
