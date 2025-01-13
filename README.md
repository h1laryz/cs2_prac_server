# CS2 server for pracs via MatchZy


## This server uses following mods/frameworks/plugins:
- [Metamod](https://www.sourcemm.net/downloads.php?branch=stable) — **CSSharp doesn't work without metamod.**
- [CSSharp](https://github.com/roflmuffin/CounterStrikeSharp) — **Best framework for writing plugins for CS2 servers.**
- [MatchZy](https://github.com/shobhit-pathak/MatchZy) — **Used for practice and competitive matches.**
- [CS2Rcon](https://github.com/LordFetznschaedl/CS2Rcon) — **Allows to use !rcon via chat.**


## Usage
1. Clone repository or download latest release.
2. Add environment variables to your system:
```
export RCON_PASSWORD="changeme"
export SERVER_PASSWORD="changeme"
export PORT="27015"
export MAXPLAYERS="changeme"
```
3. Edit admins.json file and add your nickname and steamid.
4. Launch **_start_cs2_server.sh_**.


## Launch server on system startup 
### Systemctl
1. Create `/etc/systemd/system/cs2pracserver.service` file
2. Add following lines and change **_ExecStart_** field to your path of **_start_cs2_server.sh_**.
```
[Unit]
Description=CS2 Prac Server
After=network.target

[Service]
ExecStart=/root/start_cs2_server.sh
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
```
3. Run following terminal commands:
```
sudo systemctl enable cs2pracserver.service
sudo systemctl start cs2pracserver.service
```


## Supported distros:
- Ubuntu
- Debian
