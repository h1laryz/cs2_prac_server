#!/bin/bash

echo "/home/root/cs2/game/bin/linuxsteamrt64/cs2 \
    -dedicated \
    -console \
    -usercon \
    -autoupdate \
    -port 27015 \
    +map de_dust2 \
    +sv_visiblemaxplayers $MAX_PLAYERS \
    +game_type 0 \
    +game_mode 1 \
    +mapgroup mg_active \
        +sv_lan $LAN \
        +rcon_password $RCON_PASSWORD"

/home/root/cs2/game/bin/linuxsteamrt64/cs2 \
    -dedicated \
    -console \
    -usercon \
    -autoupdate \
    -port 27015 \
    +map de_dust2 \
    +sv_visiblemaxplayers $MAX_PLAYERS \
    +game_type 0 \
    +game_mode 1 \
    +mapgroup mg_active \
	+sv_lan $LAN \
	+rcon_password $RCON_PASSWORD

