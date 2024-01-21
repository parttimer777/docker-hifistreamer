# docker-hifistreamer

```
version: '3'

secrets:
  spotify:
    file: ./spotify.secret.txt

services:
 hifistreamer:
  container_name: hifistreamer
  image: ghcr.io/parttimer777/docker-hifistreamer
  ports:
    - 32500:32500/tcp
    - 3005:3005/tcp
    - 8324:8324/tcp
    - 32469:32469/tcp
    - 1900:1900/udp
    - 32410:32410/udp
    - 32412:32412/udp
    - 32413:32413/udp
    - 32414:32414/udp
  devices:
    - /dev/snd:/dev/snd
  environment:
    - PUID=1001
    - PGID=1001
    - TZ=America/New_York
    - DEVICE_NAME=${DEVICE_NAME:?err}
    - PLEXAMP_CLAIM_TOKEN=${PLEXAMP_CLAIM_TOKEN:?err}
    - SPOTIFY_USER=${SPOTIFY_USER:?err}
  volumes: 
    - /work/data/hifistreamer/plexamp:/plexamp-data
  restart: unless-stopped
  secrets:
    - spotify
```