# Workstation

A dependable, repeatable sane development workstation that runs inside of a docker container

# X86
docker-compose \
  --file ./docker-compose.yaml \
  --file ./docker-compose-arm.yaml \
  up \
  --detach

# ARM
docker-compose \
  --file ./docker-compose.yaml \
  --file ./docker-compose-arm.yaml \
  up \
  --detach

## Notes

## Connect
```bash
docker exec \
  --user <USER> \
  --interactive \
  --tty \
  <CONATINER> \
  sh -c '$SHELL'
```

### Connect (via SSH)

```bash
DOCKER_HOST=ssh://<HOST>@<SERVER>:<PORT> <DOCKER_CMD>
```
