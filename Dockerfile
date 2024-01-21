FROM rust:bookworm as spotifyd-builder

RUN \
    echo "**** install packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libasound2-dev && \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf \
        /config/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

RUN mkdir /work
WORKDIR /work

# build from scratch to support alsa
# spotifyd docs https://github.com/Spotifyd/spotifyd/blob/ae6dac7a54f899316674ba57ce4a0f9890cd2b1c/docs/src/installation/Feature-flags.md
RUN git clone https://github.com/Spotifyd/spotifyd.git \
    && cd spotifyd \
    && cargo build --release --no-default-features --features alsa_backend

FROM ghcr.io/linuxserver/baseimage-debian:bookworm 
COPY --from=node:16-bookworm /usr/local/bin /usr/local/bin

RUN \
    echo "**** install packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget  \
        curl  \
        jq \
        libasound2 \
        alsa-utils \
        bzip2 && \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf \
        /config/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

WORKDIR /app

# source: https://github.com/anatosun/plexamp-docker/blob/main/Dockerfile
RUN wget -q "$(curl -s "https://plexamp.plex.tv/headless/version$1.json" | jq -r '.updateUrl')" -O plexamp.tar.bz2 \
	&& tar -xvf plexamp.tar.bz2 \
	&& rm plexamp.tar.bz2

COPY --from=spotifyd-builder /work/spotifyd/target/release/spotifyd /app/spotifyd
COPY /rootfs /
# COPY ./asound.conf /etc/asound.conf