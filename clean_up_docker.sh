# bash script to remove exited containers
#!/usr/bin/env bash

set -euo pipefail

exited=`docker ps -a -q -f status=exited`

if [[ ! -z ${exited} ]]; then
   docker rm -v $(docker ps -a -q -f status=exited)
fi

exit 0

# remove dangling images
# docker images
# docker rmi $(docker images -f "dangling=true" -q)
