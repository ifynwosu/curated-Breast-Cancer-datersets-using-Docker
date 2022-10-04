#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu/bc_data_curation_02 .  

#######################################################
# Run detailed functional tests on small file
#######################################################

dockerCommand="docker run -i -t --rm \
    -v $(pwd):/2_process_affy_expression_data \
    -v $HOME/Data:/Data \
    inwosu/bc_data_curation_02"

$dockerCommand Rscript normalize_E_TABM_158.R
$dockerCommand Rscript normalize_multiple_chips.R
$dockerCommand Rscript normalize_single_chips.R
 
# $dockerCommand bash