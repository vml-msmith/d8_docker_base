## Install Docker
[Docker For Mac](https://docs.docker.com/engine/installation/mac/)

## Setup a new Drupal Project
### Setup Docker and download Drupal.
```
./scripts/test-docker.sh
./scripts/download-drupal.sh
./scripts/run-docker.sh
```

The website should launch automatically in you default browser.


### Launch your website again
Run docker ps and find your port.

```
docker ps
```

Open a browser and type...

```
http://localhost:<portYouFoundInDockerPs>
```