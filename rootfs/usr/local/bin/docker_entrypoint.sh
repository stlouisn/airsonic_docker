#!/bin/bash

#=========================================================================================

# Fix user and group ownerships for '/config'
chown -R airsonic:airsonic /config

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
cd /airsonic/

# Start airsonic in console mode
exec gosu airsonic \
    /usr/bin/java \
    -Dairsonic.defaultMusicFolder=/music \
    -Dairsonic.defaultPlaylistFolder=/playlists \
    -Dairsonic.defaultPodcastFolder=/podcasts \
    -Dairsonic.home=/config \
    -Djava.awt.headless=true \
    -Dserver.host=0.0.0.0 \
    -Dserver.port=4040 \
    -Xmx512m \
    -jar /airsonic/airsonic.war
