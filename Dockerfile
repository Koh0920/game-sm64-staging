FROM docker.io/library/ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/ato \
    DISPLAY=:1 \
    XDG_RUNTIME_DIR=/run/sm64/xdg \
    SM64_ROOT=/opt/sm64

RUN for i in 1 2 3 4 5; do \
      apt-get update -qq && \
      apt-get install --yes --no-install-recommends \
        openbox python3 x11-apps x11-utils x11-xkb-utils \
        tigervnc-scraping-server xdotool xterm xvfb \
      && rm -rf /var/lib/apt/lists/* \
      && exit 0; \
      echo "attempt $i failed, sleeping 10..."; \
      sleep 10; \
    done; exit 1

RUN install -d -o 1000 -g 1000 -m 0755 /opt/sm64 /opt/sm64/scripts /run/sm64 /run/sm64/xdg

COPY --chown=1000:1000 scripts/ /opt/sm64/scripts/
COPY --chown=1000:1000 web/ /opt/sm64/web/

RUN chmod 0755 /opt/sm64/scripts/*.sh

USER 1000:1000
WORKDIR /home/ato
EXPOSE 3000

CMD ["/opt/sm64/scripts/entrypoint.sh"]
