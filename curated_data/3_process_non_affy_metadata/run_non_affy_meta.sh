#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t non_affy_meta .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While you are testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $HOME/Data:/Data \
    non_affy_meta"

# $dockerCommand Rscript /scripts/E-TABM-158_Meta.R
$dockerCommand Rscript /scripts/GSE62944_Meta.R
# $dockerCommand Rscript /scripts/GSE96058_Meta.R
# $dockerCommand Rscript /scripts/ICGC_Meta.R
# $dockerCommand Rscript /scripts/Metabric_Meta.R
# $dockerCommand bash