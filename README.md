# docker-hifistreamer

Docker-hifistreamer is for audio enthusiasts that want to stream music through DAC/AMPs and HiFi headphones.
* Plexamp - use Plexamp on your phone as remote to play your Plex lossless audio collection
* Spotifyd - cast Spotify through your HiFi headphones
* Built with s6 overlay, allowing custom startup scripts and services
* Image is automatically updated and built

AMD64 only for now.

Based on linuxserver's [Debian BaseImage](https://github.com/linuxserver/docker-baseimage-debian). 

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
    - ./plexamp-data:/plexamp-data
  restart: unless-stopped
  secrets:
    - spotify
```
