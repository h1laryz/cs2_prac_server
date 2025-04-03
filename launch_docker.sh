#!/bin/zsh

docker build --no-cache -f Dockerfile_Install_Update -t cs2-server-updater .

# Then run updater container with

docker run --rm --name cs2_updater -v ~/cs2_server/cs2/:/home/root/cs2/ cs2-server-updater

# Next we need to build image for cs2 server
docker build --no-cache -f Dockerfile -t cs2-server-runner .

# Now we're ready to run cs2 server container
docker run --rm --name cs2_server_1 \
 -v ~/cs2_server/cs2:/home/root/cs2/ \
 -e MAX_PLAYERS="$MAX_PLAYERS" \
 -e LAN="$LAN" \
 -e RCON_PASSWORD="$RCON_PASSWORD" \
 -p 27016:27015/udp -p 27016:27015/tcp \
 cs2-server-runner
