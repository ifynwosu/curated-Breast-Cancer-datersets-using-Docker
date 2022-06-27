#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

docker build -t non_affy .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While you are testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd)/Data:/Data \
    non_affy"

$dockerCommand Rscript /scripts/GSE62944_Exp.R
$dockerCommand Rscript /scripts/GSE96058_Exp.R
$dockerCommand Rscript /scripts/ICGC_Exp.R
$dockerCommand Rscript /scripts/Metabric_Exp.R
#$dockerCommand bash