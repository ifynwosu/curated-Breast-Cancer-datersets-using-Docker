#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t ncit_matching .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd):/6_NCIT_matching \
    -v $HOME/Data:/Data \
    ncit_matching"

$dockerCommand Rscript NCIT.R 
# $dockerCommand bash