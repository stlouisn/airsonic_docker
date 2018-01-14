FROM stlouisn/ubuntu:rolling

COPY rootfs /

ARG DOWNLOAD_URL

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
    apt install -y --no-install-recommends \
        default-jre-headless && \

    # Install airsonic
    curl $DOWNLOAD_URL -o /tmp/airsonic.tar.gz && \
    chown -R airsonic:airsonic /usr/lib/airsonic && \
    tar xzvf /tmp/airsonic.tar.gz -C /usr/lib/airsonic && \
    chown -R airsonic:airsonic /usr/lib/airsonic

    # Install codecs
    apt install -y --no-install-recommends \
        ffmpeg \
        flac \
        lame && \

    # Clean apt-cache
    apt autoremove -y --purge && \
    apt autoclean -y && \

    # Cleanup temporary folders
    rm -rf \
        /root/.cache \
        /root/.wget-hsts \
        /tmp/* \
        /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/default-java/jre

VOLUME /music \
       /playlists \
       /podcasts \
       /var/lib/subsonic

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
