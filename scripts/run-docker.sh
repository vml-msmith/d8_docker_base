#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_COMPOSE="docker-compose -f ${DIR}/../.docker/docker-compose.yml"

## Startup the Docker servers. Ensures a new build first.:Q
printf "${YELLOW}Starting Docker servers....${NC}"
docker-compose -f ${DIR}/../.docker/docker-compose.yml build
`${DOCKER_COMPOSE} up -d`

port_ssl=`docker port docker_app_1 443`
port_ssl=${port_ssl#*:}

`open https://localhost:${port_ssl}`
exit 0
