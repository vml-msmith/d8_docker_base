#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_COMPOSE="docker-compose -f ${DIR}/../.docker/docker-compose.yml -p testdocker"


## Startup the Docker servers. Ensures a new build first.
printf "${YELLOW}Starting Docker servers....${NC}"
echo ""
docker-compose -f ${DIR}/../.docker/docker-compose.yml -p testdocker build
`${DOCKER_COMPOSE} up -d`

exit_code=0

## Get the mapped port 80, and check that we receive a proper 200 HTTP code.
port=`docker port testdocker_app_1 80`
port=${port#*:}
echo ""
printf "Testing normal port 80 accesss.... "
http_code=`curl -sL -w "%{http_code}" "localhost:${port}" -o /dev/null`
if [ ${http_code} -eq 200 ]
then
    printf "${GREEN}Success${NC}"
else
    printf "${RED}Failure${NC}"
    exit_code=1
fi
printf " (${http_code})"
echo ""


## Get the mapped port 443 and check that we receive a proper 200 HTTP code.
port_ssl=`docker port testdocker_app_1 443`
port_ssl=${port_ssl#*:}

printf "Testing SSL port 443 accesss.... "
http_code_ssl=`curl -sLk -w "%{http_code}" "https://localhost:${port_ssl}" -o /dev/null`
if [ ${http_code_ssl} -eq 200 ]
then
    printf "${GREEN}Success${NC}"
else
    printf "${RED}Failure${NC}"
    exit_code=1
fi
printf " (${http_code_ssl})"
echo ""

## Test that index.php returns a good 200 HTTP code.
printf "Testing PHP is working.... "
http_code=`curl -sLk -w "%{http_code}" "localhost:${port}/index.php" -o /dev/null`
if [ ${http_code} -eq 200 ]
then
    printf "${GREEN}Success${NC}"
else
    printf "${RED}Failure${NC}"
    exit_code=1
fi
echo ""


## Shut the whole thing down.
echo ""
printf "${YELLOW}Cleaning up....${NC}"
echo ""
`${DOCKER_COMPOSE} kill`

exit ${exit_code}
