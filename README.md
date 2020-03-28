# Workstation

A dependable, repeatable sane development workstation that runs inside of a docker container

# Mac
docker-sync clean
docker-sync start 
docker-compose -f ./docker-compose.yaml -f docker-compose-mac.yaml up

# Linux
docker-compose -f ./docker-compose.yaml -f docker-compose-linux.yaml up
