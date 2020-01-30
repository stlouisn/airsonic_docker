#!/usr/bin/env bash

set -euo pipefail

# Output airsonic version from github:airsonic releases
echo "$(curl -fsSL --retry 5 --retry-delay 2 https://github.com/airsonic/airsonic/releases | grep 'airsonic.war' | head -n 1 | awk -F '/v' {'print $2'} | awk -F '/' {'print $1'})"
