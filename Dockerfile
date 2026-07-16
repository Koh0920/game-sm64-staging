FROM docker.io/library/busybox@sha256:0872fb3a7632ba9d0ae46a8e832a62b30ce83a6f220b8bb52903d9cf477dabe3 AS busybox

FROM docker.io/jlesage/baseimage-gui@sha256:3369ba652f07c5c0ccaba37b7885ba162e205fb948874ab41a07172e6f3de99a

ENV HOME=/home/ato \
    DISPLAY=:1 \
    XDG_RUNTIME_DIR=/run/sm64/xdg \
    SM64_ROOT=/opt/sm64 \
    LIBGL_ALWAYS_SOFTWARE=1 \
    SDL_AUDIODRIVER=dummy

COPY --from=busybox /bin/busybox /usr/local/bin/busybox
COPY vendor/debs/ /opt/sm64/debs/

RUN dpkg -i /opt/sm64/debs/*.deb \
    && rm -rf /opt/sm64/debs \
    && printf 'root:x:0:0:root:/root:/bin/bash\nato:x:1000:1000:Ato:/home/ato:/bin/bash\n' >/etc/passwd \
    && printf 'root:x:0:\nato:x:1000:\n' >/etc/group \
    && install -d -o 1000 -g 1000 -m 0755 \
      /home/ato /opt/sm64 /opt/sm64/game /opt/sm64/scripts \
      /run/sm64 /run/sm64/xdg

COPY vendor/releases/sm64coopdx_Linux.zip /opt/sm64/sm64coopdx_Linux.zip

RUN /usr/local/bin/busybox unzip -q /opt/sm64/sm64coopdx_Linux.zip -d /opt/sm64/game \
    && rm /opt/sm64/sm64coopdx_Linux.zip \
    && test -x /opt/sm64/game/sm64coopdx \
    && chown -R 1000:1000 /opt/sm64/game

COPY --chown=1000:1000 scripts/ /opt/sm64/scripts/
COPY --chown=1000:1000 web/ /opt/sm64/web/

RUN chmod 0755 /opt/sm64/scripts/*.sh

USER 1000:1000
WORKDIR /home/ato
EXPOSE 3000

CMD ["/opt/sm64/scripts/entrypoint.sh"]
