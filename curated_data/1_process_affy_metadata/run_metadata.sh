#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu_bc_data_paper_process_metadata .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd):/1_process_metadata \
    -v $HOME/Data:/Data \
    inwosu_bc_data_paper_process_metadata"

$dockerCommand Rscript scripts/runAll.R 
# $dockerCommand bash