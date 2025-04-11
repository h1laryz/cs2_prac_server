# Env variables
```
export MAX_PLAYERS="changeme"
export LAN="0/1"
export RCON_PASSWORD="changeme"
```

# At first you need to build docker updater

`docker build --no-cache -f Dockerfile_Install_Update -t cs2-server-updater .`

# Then run updater container with

`docker run --rm --name cs2_updater -v ~/cs2_server/cs2/:/home/root/cs2/ cs2-server-updater`

# Next we need to build image for cs2 server
`docker build --no-cache -f Dockerfile -t cs2-server-runner .`

# Now we're ready to run cs2 server container
```
docker run -i -d --rm --name cs2_server_1 \
 -v ~/cs2_server/cs2:/home/root/cs2/ \
 -e MAX_PLAYERS="$MAX_PLAYERS" \
 -e LAN="$LAN" \
 -e RCON_PASSWORD="$RCON_PASSWORD" \
 -p 27015:27015/udp -p 27015:27015/tcp \
 cs2-server-runner
```

# Let's create autoupdate on system restart via systemctl
1. Create **_/etc/systemd/system/cs2_server_updater.service_** file
2. Add following lines and change **_ExecStart_** field to your path of directory and launch script
```
[Unit]
Description=CS2 Server updater
After=docker.service
Requires=docker.service

[Service]
ExecStart=/bin/bash -c 'cd /root/cs2_server && docker rm -f cs2_updater && docker run --rm --name cs2_updater -v /root/cs2_server/cs2/:/home/root/cs2/ cs2-server-updater'
Restart=no
User=root
Group=root
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

# Now create 3 servers that launches on startup also via systemctl
1. Create **_/etc/systemd/cs2_server@.service_**
2. Add following data:
```
[Unit]
Description=CS2 Server Instance %i
After=cs2_server_updater.service
Requires=cs2_server_updater.service

[Service]
User=root
Group=root
Restart=always
ExecStart=/bin/bash -c 'docker run -d -i --rm --name cs2_server_%i \
  -v /root/cs2_server/cs2:/home/root/cs2/ \
  -e MAX_PLAYERS="$MAX_PLAYERS" \
  -e LAN="$LAN" \
  -e RCON_PASSWORD="$RCON_PASSWORD" \
  -p $((27015 + %i)):27015/udp -p $((27015 + %i)):27015/tcp \
  cs2-server-runner'
ExecStop=/usr/bin/docker stop cs2_server_%i
ExecStopPost=/usr/bin/docker rm -f cs2_server_%i

[Install]
WantedBy=multi-user.target
```

# Enable systemctl services
```
sudo systemctl daemon-reload
sudo systemctl enable cs2_server_updater
sudo systemctl start cs2_server_updater 
```

```
sudo systemctl enable cs2_server@1 cs2_server@2 cs2_server@3
sudo systemctl start cs2_server@1 cs2_server@2 cs2_server@3
```

### To get console app you need to write **_docker attach cs2_server_1_**

