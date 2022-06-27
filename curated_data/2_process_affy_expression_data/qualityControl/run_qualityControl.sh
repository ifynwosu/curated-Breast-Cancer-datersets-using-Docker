#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################
docker build -t qctest .

# docker build -t qctest \
#       --build-arg USER_ID=$(id -u) \
#       --build-arg GROUP_ID=$(id -g) .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While you are testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd):/qualityControl \
    -v $HOME/Data:/Data \
    qctest"

$dockerCommand Rscript merge_meta_summaries.R
$dockerCommand Rscript compare_norm_GEO.R
$dockerCommand Rscript doppelgang.R

$dockerCommand Rscript IQRray.R	
$dockerCommand Rscript merge_doppel_results.R
$dockerCommand Rscript draw_plots.R

# $dockerCommand bash    
