#!/bin/bash

#=========================================================================================

# Make sure volume '/var/lib/airsonic' is mounted and writeable
if [[ ! -d /var/lib/airsonic ]]; then
    echo -e "\nError: volume '/var/lib/airsonic' is not mounted.\n" >&2
    exit 1
elif [[ `mount | grep '/var/lib/airsonic' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nError: volume '/var/lib/airsonic' is readonly.\n" >&2
    exit 1
fi

# Fix user and group ownerships for '/var/lib/airsonic'
chown -R airsonic:airsonic /var/lib/airsonic

# Fix user and group ownerships for '/music'
if [[ `mount | grep '/music' | awk -F '(' {'print $2'} | cut -c -2` == "rw" ]]; then
    chown -R airsonic:airsonic /music
fi

# Fix user and group ownerships for '/playlists'
if [[ `mount | grep '/playlists' | awk -F '(' {'print $2'} | cut -c -2` == "rw" ]]; then
    chown -R airsonic:airsonic /playlists
fi

# Fix user and group ownerships for '/podcasts'
if [[ `mount | grep '/podcasts' | awk -F '(' {'print $2'} | cut -c -2` == "rw" ]]; then
    chown -R airsonic:airsonic /podcasts
fi

#=========================================================================================

# Change workdir
cd /usr/lib/airsonic

# Start airsonic in console mode
exec gosu airsonic \
    /usr/bin/java \
    -Dairsonic.defaultMusicFolder=/music \
    -Dairsonic.defaultPlaylistFolder=/playlists \
    -Dairsonic.defaultPodcastFolder=/podcasts \
    -Dairsonic.home=/var/lib/airsonic \
    -Djava.awt.headless=true \
    -Dserver.host=0.0.0.0 \
    -Dserver.port=4040 \
    -Xmx512m \
    -jar /usr/lib/airsonic/airsonic.war
