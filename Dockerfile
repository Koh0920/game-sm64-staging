FROM docker.io/library/alpine:3.20

ENV HOME=/home/ato \
    DISPLAY=:1 \
    XDG_RUNTIME_DIR=/run/sm64/xdg \
    SM64_ROOT=/opt/sm64

RUN for i in 1 2 3; do \
      apk add --no-cache \
        bash python3 xvfb xvfb-run xdpyinfo \
        xwininfo xrandr tigervnc xterm xdotool \
        setxkbmap \
      && exit 0; \
      echo "attempt $i failed"; sleep 5; \
    done; exit 1

RUN install -d -o 1000 -g 1000 -m 0755 /opt/sm64 /opt/sm64/scripts /run/sm64 /run/sm64/xdg

COPY --chown=1000:1000 scripts/ /opt/sm64/scripts/
COPY --chown=1000:1000 web/ /opt/sm64/web/

RUN chmod 0755 /opt/sm64/scripts/*.sh

USER 1000:1000
WORKDIR /home/ato
EXPOSE 3000

CMD ["/opt/sm64/scripts/entrypoint.sh"]
