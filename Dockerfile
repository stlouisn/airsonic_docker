FROM ubuntu:rolling

COPY rootfs /

RUN \

    export DEBIAN_FRONTEND=noninteractive && \

    # Update apt-cache
    apt update && \

    # Install tzdata
    apt install -y --no-install-recommends \
        tzdata && \

    # Install SSL
    apt install -y --no-install-recommends \
        ca-certificates \
        openssl && \

    # Install curl
    apt install -y --no-install-recommends \
        curl && \

    # Install gosu
    apt install -y --no-install-recommends \
        gosu && \

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

    # Install Java
    apt install -y --no-install-recommends \
        default-jre-headless && \

    # Install airsonic
    wget ${AIRSONIC_DOWNLOAD} && \
    chown -R airsonic:airsonic /usr/lib/airsonic && \

    # Install codecs
    apt install -y --no-install-recommends \
        ffmpeg \
        flac \
        lame \
        xmp && \

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
