# ! /bin/bash

#=========================================================================================

# Fix user and group ownerships for '/config'
chown -R airsonic:airsonic /config

# Fix user and group ownerships for '/music'
if [[ `mount | grep '/music' | awk -F '(' {'print $2'} | cut -c -2` == "rw" ]]; then
    chown -R airsonic:airsonic /music
else
    echo -e "\nWarning: volume '/music' is readonly.\n" >&2
fi

# Fix user and group ownerships for '/playlists'
if [[ `mount | grep '/playlists' | awk -F '(' {'print $2'} | cut -c -2` == "rw" ]]; then
    chown -R airsonic:airsonic /playlists
else
    echo -e "\nWarning: volume '/playlists' is readonly.\n" >&2
fi

# Fix user and group ownerships for '/podcasts'
if [[ `mount | grep '/podcasts' | awk -F '(' {'print $2'} | cut -c -2` == "rw" ]]; then
    chown -R airsonic:airsonic /podcasts
else
    echo -e "\nWarning: volume '/podcasts' is readonly.\n" >&2
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
    -Dairsonic.home=/config \
    -Djava.awt.headless=true \
    -Dserver.host=0.0.0.0 \
    -Dserver.port=4040 \
    -Xmx512m \
    -jar /usr/lib/airsonic/airsonic.war
