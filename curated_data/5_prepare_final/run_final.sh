#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t inwosu_bc_data_paper_prepare_final .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd):/5_prepare_final \
    -v $HOME/Data:/Data \
    inwosu_bc_data_paper_prepare_final"

# While running in the background, use this command:
# dockerCommand="docker run -d --rm \
#     -v $(pwd):/5_prepare_final \ 
#     -v $HOME/Data:/Data \
#     inwosu_bc_data_paper_prepare_final"

$dockerCommand Rscript scripts/filter_samples.R 
# $dockerCommand bash