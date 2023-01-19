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
    -v $(pwd)/../Data:/Data \
    inwosu_bc_data_paper_prepare_final"

time $dockerCommand Rscript scripts/prepare_final.R

# $dockerCommand bash
