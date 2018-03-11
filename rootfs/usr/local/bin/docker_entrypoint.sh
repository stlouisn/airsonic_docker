#!/bin/bash

# Fix user and group ownerships for '/config'
if [[ ! -d /config ]]; then
    echo -e "\nError: volume '/config' not mounted.\n" >&2
    exit 1
elif [[ `mount | grep '/config' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nError: volume '/config' is readonly.\n" >&2
    exit 1
else
    chown -R airsonic:airsonic /config
fi

# Fix user and group ownerships for '/music'
if [[ ! -d /music ]]; then
    echo -e "\nWarning: volume '/music' not mounted.\n" >&2
elif [[ `mount | grep '/music' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nWarning: volume '/music' is readonly.\n" >&2
else
    chown -R airsonic:airsonic /music
fi

# Fix user and group ownerships for '/playlists'
if [[ ! -d /playlists ]]; then
    echo -e "\nWarning: volume '/playlists' not mounted.\n" >&2
elif [[ `mount | grep '/playlists' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nWarning: volume '/playlists' is readonly.\n" >&2
else
    chown -R airsonic:airsonic /playlists
fi

# Fix user and group ownerships for '/podcasts'
if [[ ! -d /podcasts ]]; then
    echo -e "\nWarning: volume '/podcasts' not mounted.\n" >&2
elif [[ `mount | grep '/podcasts' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nWarning: volume '/podcasts' is readonly.\n" >&2
else
    chown -R airsonic:airsonic /podcasts
fi

# Change workdir
cd /usr/lib/airsonic

# Start airsonic in console mode
exec gosu airsonic /usr/bin/java \
    -Dairsonic.defaultMusicFolder=/music \
    -Dairsonic.defaultPlaylistFolder=/playlists \
    -Dairsonic.defaultPodcastFolder=/podcasts \
    -Dairsonic.home=/config \
    -Djava.awt.headless=true \
    -Dserver.host=0.0.0.0 \
    -Dserver.port=4040 \
    -Xmx512m \
    -jar /usr/lib/airsonic/airsonic.war
