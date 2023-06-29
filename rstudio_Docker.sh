#! /bin/bash

set -o errexit

docker run --rm -i -t \
    -p 8787:8787 \
    -e USERID=$(id -u) \
    -e GROUPID=$(id -g) \
    -e PASSWORD=Master \
    -v $HOME:/inwosu \
    bioconductor/bioconductor_docker:RELEASE_3_17
    #rocker/tidyverse

#########################################################################################################

# OpenBLAS blas_thread_init: pthread_create failed for thread 1 of 20: Operation not permitted
# OpenBLAS blas_thread_init: RLIMIT_NPROC -1 current, -1 max

##########################################################################################################

# The above error popped up at some time. The solution was to update the docker version


# Helpful tips

# Go to the folder where you have your R code. Mine is $Home so I’ll go there.
# Run "echo $UID" to get your user id (Mine is 1005). Replace this in the script with yours. 
# This helps with permissions issuses for saving changes to scripts withing rstudio.
# Replace the volume directory with yours preferences. "$Home" is my local directory and "inwosu" will be the directory created in the Docker container
# Execute the "rStudio_Docker.sh" script
# This starts a Docker container from the bioconductor/bioconductor_docker:RELEASE_3_15 image 
# It will also create a link between the folder $HOME on my system and the folder /inwosu inside the Docker container. 
# This results in my code being available inside the container.
# run "ifconfig" (I'm working on a linux server) to get youp ip address. Mine looked something like 10.10.10.10
# Open 10.10.10.10:8787 (replace "10.10.10.10" with yours) in your browser.
# type "rstudio" in the user name section and whatever password you had in the script. Password cannot be "rstudio"
# Execute setwd "/inwosu" (remember to replace "/inwosu" with yours) in RStudio.
# Down to the right inside RStudio, press “More” and then “Go to working directory”

# see the bioconductor github page "https://github.com/bioconductor/bioconductor_docker" for more info
