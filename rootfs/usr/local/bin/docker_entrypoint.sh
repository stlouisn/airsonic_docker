#!/bin/bash

# Set timezone
TZ=${TZ:-UTC}
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Make sure volumes are mounted correctly
if [[ ! -d /var/lib/airsonic ]]; then
    echo -e "\nError: volume '/var/lib/airsonic/' not mounted.\n" >&2
    exit 1
elif [[ `mount | grep '/var/lib/airsonic' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nError: volume '/var/lib/airsonic/' is readonly.\n" >&2
    exit 1
fi

# Fix user and group ownerships
chown -R airsonic:airsonic /var/lib/airsonic

# Fix user and group ownerships
if [[ ! -d /music ]]; then
    echo -e "\nWarning: volume '/music/' not mounted.\n" >&2
elif [[ `mount | grep '/music' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nWarning: volume '/music/' is readonly.\n" >&2
else
    chown -R airsonic:airsonic /music
fi

# Fix user and group ownerships
if [[ ! -d /playlists ]]; then
    echo -e "\nWarning: volume '/playlists/' not mounted.\n" >&2
elif [[ `mount | grep '/playlists' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nWarning: volume '/playlists/' is readonly.\n" >&2
else
    chown -R airsonic:airsonic /playlists
fi

# Fix user and group ownerships
if [[ ! -d /podcasts ]]; then
    echo -e "\nWarning: volume '/podcasts/' not mounted.\n" >&2
elif [[ `mount | grep '/podcasts' | awk -F '(' {'print $2'} | cut -c -2` == "ro" ]]; then
    echo -e "\nWarning: volume '/podcasts/' is readonly.\n" >&2
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
    -Dairsonic.home=/var/lib/airsonic \
    -Dserver.port=4040 \
    -Xmx512m \
    -jar /usr/lib/airsonic/airsonic.war
