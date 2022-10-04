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

# $dockerCommand Rscript doppelgang.R
$dockerCommand Rscript merge_doppel_results.R
# $dockerCommand Rscript IQRray.R
# $dockerCommand Rscript draw_plots.R

# $dockerCommand bash    
