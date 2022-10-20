#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu/bc_data_curation_05 .

#######################################################
# Run docker command
#######################################################

# While you are testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd):/5_process_non_affy_expr_data \
    -v $HOME/Data:/Data \
    inwosu/bc_data_curation_05"

$dockerCommand Rscript scripts/source_all_non_affy_expr.R

# $dockerCommand bash