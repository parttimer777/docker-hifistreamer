FROM ghcr.io/linuxserver/baseimage-debian:bookworm 
COPY --from=node:20-bookworm /usr/local/bin /usr/local/bin

RUN \
    echo "**** install packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget  \
        curl  \
        jq \
        alsa-utils libasound2 libasound2-plugin-equal gettext \
        bzip2 \
        apt-transport-https && \
    curl -sSLk https://dtcooper.github.io/raspotify/key.asc | apt-key add -v - && \
    echo "deb https://dtcooper.github.io/raspotify raspotify main" | tee /etc/apt/sources.list.d/raspotify.list && \
    apt-get update && \
    apt-get -y install raspotify && \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf \
        /config/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

WORKDIR /app

# source: https://github.com/anatosun/plexamp-docker/blob/main/Dockerfile
RUN wget -q "$(curl -s "https://plexamp.plex.tv/headless/version.json" | jq -r '.updateUrl')" -O plexamp.tar.bz2 \
	&& tar -xvf plexamp.tar.bz2 \
	&& rm plexamp.tar.bz2

ENV ALSA_SLAVE_PCM="11111"

COPY /rootfs /

HEALTHCHECK --interval=15s \
    CMD [ $(s6-rc -a list|grep -v grep|egrep "plexamp|librespot"|wc -l) -eq 2 ]
