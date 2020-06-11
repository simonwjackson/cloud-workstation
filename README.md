# Workstation

A dependable, repeatable sane development workstation that runs inside of a docker container

## X86
```bash
docker-compose \
  --file ./docker-compose.yaml \
  --file ./docker-compose-x86.yaml \
  up \
  --no-recreate \
  --detach
```

## ARM
```bash
docker-compose \
  --file ./docker-compose.yaml \
  --file ./docker-compose-arm.yaml \
  up \
  --no-recreate \
  --detach
```

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
