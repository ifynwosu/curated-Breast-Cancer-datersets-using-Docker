#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu/bc_data_curation_04 .

#######################################################
# Run detailed functional tests on small file
#######################################################

dockerCommand="docker run -i -t --rm \
    -v $(pwd):/4_process_non_affy_metadata \
    -v $HOME/Data:/Data \
    inwosu/bc_data_curation_04"

$dockerCommand Rscript scripts/source_all_non_affy_meta.R

# $dockerCommand bash