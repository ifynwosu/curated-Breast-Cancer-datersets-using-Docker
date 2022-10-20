#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu/bc_data_curation_03 .

#######################################################
# Run detailed functional tests on small file
#######################################################

dockerCommand="docker run -i -t --rm \
    -v $(pwd):/3_qualityControl_affy_expression_data \
    -v $HOME/Data:/Data \
    inwosu/bc_data_curation_03"

$dockerCommand Rscript scripts/source_all_QC.R

# $dockerCommand bash    
