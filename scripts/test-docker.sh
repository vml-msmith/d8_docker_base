#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

printf "${YELLOW}Starting Docker servers....${NC}"
echo ""
docker-compose -f ../.docker/docker-compose.yml -p testdocker build
docker-compose -f ../.docker/docker-compose.yml -p testdocker up -d

exit_code=0

port=`docker port testdocker_app_1 80`
port=${port#*:}

port_ssl=`docker port testdocker_app_1 443`
port_ssl=${port_ssl#*:}

echo ""
printf "Testing normal port 80 accesss.... "
http_code=`curl -I -sL -w "%{http_code}" "localhost:${port}" -o /dev/null`
if [ ${http_code} -eq 200 ]
then
    printf "${GREEN}Success${NC}"
else
    printf "${RED}Failure${NC}"
    exit_code=1
fi
printf " (${http_code})"
echo ""

printf "Testing SSL port 443 accesss.... "
http_code_ssl=`curl -I -sL -w "%{http_code}" "localhost:${port_ssl}" -o /dev/null`
if [ ${http_code_ssl} -eq 200 ]
then
    printf "${GREEN}Success${NC}"
else
    printf "${RED}Failure${NC}"
    exit_code=1
fi
printf " (${http_code_ssl})"
echo ""

printf "Testing PHP is working.... "
http_code=`curl -I -sL -w "%{http_code}" "localhost:${port}/index.php" -o /dev/null`
if [ ${http_code} -eq 200 ]
then
    printf "${GREEN}Success${NC}"
else
    printf "${RED}Failure${NC}"
    exit_code=1
fi
echo ""

echo ""
printf "${YELLOW}Cleaning up....${NC}"
echo ""
docker-compose -f ../.docker/docker-compose.yml -p testdocker kill

exit ${exit_code}
