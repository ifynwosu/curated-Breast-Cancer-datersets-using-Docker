#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu/bc_data_curation_01 .

#######################################################
# Run detailed functional tests on small file
#######################################################

dockerCommand="docker run -i -t --rm \
    -v $(pwd):/1_process_metadata \
    -v $HOME/Data:/Data \
    inwosu/bc_data_curation_01"

$dockerCommand Rscript scripts/runAll.R 

# $dockerCommand bash