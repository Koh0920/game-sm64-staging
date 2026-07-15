FROM ubuntu:24.04

ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo \
    HOME=/home/ato \
    DISPLAY=:1 \
    XDG_RUNTIME_DIR=/run/sm64/xdg \
    SM64_ROOT=/opt/sm64

RUN test "${TARGETARCH:-amd64}" = "amd64" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      tigervnc-standalone-server \
      tigervnc-common \
      websockify \
      novnc \
      nginx-light \
      supervisor \
      tini \
      curl \
      x11-utils \
      x11-xserver-utils \
      x11-apps \
      xfonts-base \
      fonts-dejavu-core \
      libsdl2-2.0-0 \
      libglew2.2 \
      libgl1 \
      libsamplerate0 \
      libasound2t64 \
    && rm -rf /var/lib/apt/lists/*

RUN groupmod --new-name ato ubuntu 2>/dev/null || true \
    && usermod --login ato --home /home/ato --move-home --comment Ato ubuntu 2>/dev/null || true \
    && install -d -o 1000 -g 1000 -m 0755 /opt/sm64 /opt/sm64/scripts /run/sm64 /run/sm64/xdg

COPY --chown=1000:1000 scripts/ /opt/sm64/scripts/
COPY --chown=1000:1000 supervisor/ /opt/sm64/supervisor/
COPY --chown=1000:1000 web/ /opt/sm64/web/
COPY --chown=1000:1000 nginx.conf /opt/sm64/nginx.conf
RUN chmod 0755 /opt/sm64/scripts/*.sh

USER 1000:1000
WORKDIR /home/ato
EXPOSE 3000

ENTRYPOINT ["/usr/bin/tini", "--", "/opt/sm64/scripts/entrypoint.sh"]
