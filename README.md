# Workstation

A dependable, repeatable sane development workstation that runs inside of a docker container

# Mac
docker-sync clean
docker-sync start 
docker-compose -f ./docker-compose.yaml -f ./docker-compose-dev.yaml -f docker-compose-mac.yaml up

# Linux
USERID=1000 GROUPID=100 WORKINGDIR=/mnt/user/workstation docker-compose -f ./docker-compose.yaml -f docker-compose-linux.yaml up 