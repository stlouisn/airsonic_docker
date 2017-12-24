#!/bin/bash

# Set timezone
TZ=${TZ:-UTC}
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Make sure volumes are mounted correctly
if [ ! -d /var/lib/airsonic ]; then
    printf "\nERROR: volume /var/lib/airsonic not mounted.\n" >&2
    exit 1
fi

# Copy default subsonic.properties file
if [ ! -e /var/lib/airsonic/airsonic.properties ]; then
    cp /etc/airsonic/airsonic.properties /var/lib/airsonic/.
fi

# Create symlinks for transcoding
if [ ! -e /var/lib/airsonic/transcode/ffmpeg ]; then
    mkdir -p /var/lib/airsonic/transcode
    ln -s /usr/bin/ffmpeg /var/lib/airsonic/transcode/ffmpeg
fi
if [ ! -e /var/lib/airsonic/transcode/lame ]; then
    mkdir -p /var/lib/airsonic/transcode
    ln -s /usr/bin/lame /var/lib/airsonic/transcode/lame
fi
if [ ! -e /var/lib/airsonic/transcode/flac ]; then
    mkdir -p /var/lib/airsonic/transcode
    ln -s /usr/bin/flac /var/lib/airsonic/transcode/flac
fi
if [ ! -e /var/lib/airsonic/transcode/xmp ]; then
    mkdir -p /var/lib/airsonic/transcode
    ln -s /usr/bin/xmp /var/lib/airsonic/transcode/xmp
fi

# Fix user and group ownerships
MOUNT_MODE=`mount | grep "/music" | awk -F "(" '{print $2}' | cut -c -2`
if [ $MOUNT_MODE == "rw" ]; then
    chown -R airsonic:airsonic /music
fi
MOUNT_MODE=`mount | grep "/playlists" | awk -F "(" '{print $2}' | cut -c -2`
if [ $MOUNT_MODE == "rw" ]; then
    chown -R airsonic:airsonic /playlists
fi
MOUNT_MODE=`mount | grep "/podcasts" | awk -F "(" '{print $2}' | cut -c -2`
if [ $MOUNT_MODE == "rw" ]; then
    chown -R airsonic:airsonic /podcasts
fi
chown -R airsonic:airsonic /var/lib/airsonic

# Change workdir
cd /usr/lib/airsonic

# Start subsonic in console mode
exec gosu airsonic \
    /usr/bin/java \
        -Dairsonic.defaultMusicFolder=/music \
        -Dairsonic.defaultPlaylistFolder=/playlists \
        -Dairsonic.defaultPodcastFolder=/podcasts \
        -Dairsonic.home=/var/lib/subsonic \
        -Dserver.port=4040 \
        -Xmx512m \
        -Djava.awt.headless=true \
        -jar /usr/lib/airsonic/airsonic.war
