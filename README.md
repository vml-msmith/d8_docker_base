## Setup a new Drupal Project
### Setup Docker and download Drupal.
```
./scripts/test-docker.sh
./scripts/download-drupal.sh
./scripts/run-docker.sh
```

### Launch your website
Run docker ps and find your port.

```
docker ps
```

Open a browser and type...

```
http://localhost:<portYouFoundInDockerPs
```