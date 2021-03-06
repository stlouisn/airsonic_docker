FROM stlouisn/java:8

COPY rootfs /

RUN \

    export DEBIAN_FRONTEND=noninteractive && \

    # Create airsonic group
    groupadd \
        --system \
        --gid 10000 \
        airsonic && \

    # Create airsonic user
    useradd \
        --system \
        --no-create-home \
        --shell /sbin/nologin \
        --comment airsonic \
        --gid 10000 \
        --uid 10000 \
        airsonic

COPY --chown=airsonic:airsonic userfs /

VOLUME /music \
       /playlists \
       /podcasts \
       /config

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
