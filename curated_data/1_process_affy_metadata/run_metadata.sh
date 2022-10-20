#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu/bc_data_curation_01 .

#######################################################
# Run docker command
#######################################################

dockerCommand="docker run -i -t --rm \
    -v $(pwd):/1_process_metadata \
    -v $HOME/Data:/Data \
    inwosu/bc_data_curation_01"

$dockerCommand Rscript scripts/parse_metadata.R 

# $dockerCommand bash