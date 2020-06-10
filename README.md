# Workstation

A dependable, repeatable sane development workstation that runs inside of a docker container

# Mac
docker-sync clean
docker-sync start 
docker-compose -f ./docker-compose.yaml -f ./docker-compose-dev.yaml -f docker-compose-mac.yaml up

# Linux
docker-compose -f ./docker-compose.yaml -f docker-compose-linux.yaml up 

https://raw.githubusercontent.com/simonwjackson/dotfiles/master/.config/packages/arch

## Notes

### Connect via SSH

```bash
DOCKER_HOST=ssh://<HOST>@<SERVER>:<PORT> \
docker exec \
  --user <USER> \
  --interactive \
  --tty \
  <CONATINER> \
  sh -c '$SHELL'
```
