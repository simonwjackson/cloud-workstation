# Workstation

A dependable, repeatable sane development workstation that runs inside of a docker container

# Mac
docker-sync clean
docker-sync start 
docker-compose -f ./docker-compose.yaml -f ./docker-compose-dev.yaml -f docker-compose-mac.yaml up

# Linux
UID=1000 GID=100 HOME=/mnt/user/workstation docker-compose -f ./docker-compose.yaml -f docker-compose-linux.yaml up
