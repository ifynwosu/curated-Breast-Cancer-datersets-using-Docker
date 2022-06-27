#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

# use this for the first ever run on a system to give apropraite permisions
#   docker build -t srp33/bc_data_paper_ifeanyi \
#       --build-arg USER_ID=$(id -u) \
#       --build-arg GROUP_ID=$(id -g) .

# use this on subsequent runs
docker build -t srp33/bc_data_paper_ifeanyi .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While you are testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $HOME/Data:/Data \
    srp33/bc_data_paper_ifeanyi"

$dockerCommand Rscript normalize.R
$dockerCommand Rscript normalize_irregular_files.R 
