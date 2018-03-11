FROM stlouisn/ubuntu:rolling

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
        airsonic && \

    # Update apt-cache
    apt-get update && \

    # Install Java
    apt-get install -y --no-install-recommends \
        default-jre-headless && \

    # Clean apt-cache
    apt-get autoremove -y --purge && \
    apt-get autoclean -y && \

    # Cleanup temporary folders
    rm -rf \
        /root/.cache \
        /root/.wget-hsts \
        /tmp/* \
        /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/default-java/jre

COPY --chown=airsonic:airsonic userfs /

VOLUME /config \
       /music \
       /playlists \
       /podcasts

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
