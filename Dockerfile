FROM docker.io/library/ubuntu:24.04@sha256:52df9b1ee71626e0088f7d400d5c6b5f7bb916f8f0c82b474289a4ece6cf3faf

ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/ato \
    DISPLAY=:1 \
    XDG_RUNTIME_DIR=/run/sm64/xdg \
    SM64_ROOT=/opt/sm64

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        python3 \
        xvfb \
        x11-utils \
        x11-xserver-utils \
        x11-apps \
        xfonts-base \
        fonts-dejavu-core \
        tigervnc-standalone-server \
        tigervnc-common \
        websockify \
        nginx-light \
        supervisor \
        tini \
    && rm -rf /var/lib/apt/lists/*

RUN install -d -o 1000 -g 1000 -m 0755 /opt/sm64 /opt/sm64/scripts /run/sm64 /run/sm64/xdg

COPY --chown=1000:1000 scripts/ /opt/sm64/scripts/
COPY --chown=1000:1000 supervisor/ /opt/sm64/supervisor/
COPY --chown=1000:1000 web/ /opt/sm64/web/
COPY --chown=1000:1000 nginx.conf /opt/sm64/nginx.conf
RUN chmod 0755 /opt/sm64/scripts/*.sh

USER 1000:1000
WORKDIR /home/ato
EXPOSE 3000

ENTRYPOINT ["/usr/bin/tini", "--", "/opt/sm64/scripts/entrypoint.sh"]
