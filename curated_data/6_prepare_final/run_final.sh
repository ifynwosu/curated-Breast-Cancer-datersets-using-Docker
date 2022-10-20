#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu_bc_data_paper_prepare_final .

#######################################################
# Run docker command
#######################################################

# While testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd):/6_prepare_final \
    -v $HOME/Data:/Data \
    inwosu_bc_data_paper_prepare_final"

$dockerCommand Rscript scripts/prepare_final.R

# $dockerCommand bash
