#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################
docker build -t doppletest .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While you are testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd):/doppelgangR \
    doppletest"
	
$dockerCommand Rscript doppelgang.R
#$dockerCommand bash
