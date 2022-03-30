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
    -v $(pwd)/Data:/Data \
    srp33/bc_data_paper_ifeanyi"

# When you want it to run in the background, use this command:
# dockerCommand="docker run -d --rm \
#     -v $(pwd)/Data:/Data \
#     srp33/bc_data_paper_ifeanyi"

# While you are testing, use this command:
#dockerCommand="docker run -i -t --rm --user $(id -u):$(id -g) -v $(pwd)/Data:/Data -v $(pwd)/Expression_Scripts:/Expression_Scripts srp33/bc_data_paper_ifeanyi"

# When you want it to run in the background, use this command:
#dockerCommand="docker run -d --rm --user $(id -u):$(id -g) -v $(pwd)/Data:/Data srp33/bc_data_paper_ifeanyi"

# to bring to foreground docker attach <container_id>
#to see logs docker logs <container_id>
# To check for running containers, use docker container ls
# To check for docker images docker ps -a
# To stop a running container, use docker container stop <container_id>

$dockerCommand Rscript /Expression_Scripts/Normalize.R
#$dockerCommand Rscript /Expression_Scripts/dopplegang.R
#$dockerCommand bash

#######################################################
# To run RStudio server
#######################################################
#docker run --rm -i -t -p 8787:8787 -e PASSWORD=Master bioconductor/bioconductor_docker:RELEASE_3_14
#dojo:8787