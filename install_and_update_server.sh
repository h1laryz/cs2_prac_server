#!/bin/bash 

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$BITS" ]; then
    # Determine the operating system architecture
    architecture=$(uname -m)

    # Set OS_BITS based on the architecture
    if [[ $architecture == *"64"* ]]; then
        export BITS=64
    elif [[ $architecture == *"i386"* ]] || [[ $architecture == *"i686"* ]]; then
        export BITS=32
    else
        echo "Unknown architecture: $architecture"
        exit 1
    fi
fi

if [ -f /etc/os-release ]; then
	# freedesktop.org and systemd
	. /etc/os-release
	DISTRO_OS=$NAME
	DISTRO_VERSION=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
	# linuxbase.org
	DISTRO_OS=$(lsb_release -si)
	DISTRO_VERSION=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
	# For some versions of Debian/Ubuntu without lsb_release command
	. /etc/lsb-release
	DISTRO_OS=$DISTRIB_ID
	DISTRO_VERSION=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
	# Older Debian/Ubuntu/etc.
	DISTRO_OS=Debian
	DISTRO_VERSION=$(cat /etc/debian_version)
else
	# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
	DISTRO_OS=$(uname -s)
	DISTRO_VERSION=$(uname -r)
fi

echo "Starting on $DISTRO_OS: $DISTRO_VERSION..."

# Get the free space on the root filesystem in GB
FREE_SPACE=$(df / --output=avail -BG | tail -n 1 | tr -d 'G')

echo "With $FREE_SPACE Gb free space..."

# Check distrib
if ! command -v apt-get &> /dev/null; then
	echo "ERROR: OS distribution not supported (apt-get not available). $DISTRO_OS: $DISTRO_VERSION"
	exit 1
fi

# Check root
if [ "$EUID" -ne 0 ]; then
	echo "ERROR: Please run this script as root..."
	exit 1
fi

echo "Updating Operating System..."
apt-get update -y -q && apt-get upgrade -y -q >/dev/null
if [ "$?" -ne "0" ]; then
	echo "ERROR: Updating Operating System..."
	exit 1
fi

dpkg --configure -a >/dev/null

echo "Adding i386 architecture..."
dpkg --add-architecture i386 >/dev/null
if [ "$?" -ne "0" ]; then
	echo "ERROR: Cannot add i386 architecture..."
	exit 1
fi

echo "Installing required packages for $DISTRO_OS: $DISTRO_VERSION..."
apt-get update -y -q >/dev/null
if [ "${DISTRO_OS}" == "Ubuntu" ]; then
	if [ "${DISTRO_VERSION}" == "16.04" ]; then
		apt-get install -y -q dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat lib32stdc++6 libsdl2-2.0-0:i386 lib32gcc1 steamcmd >/dev/null
	elif [ "${DISTRO_VERSION}" == "18.04" ]; then
		apt-get install -y -q dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc1 steamcmd >/dev/null
	elif [ "${DISTRO_VERSION}" == "20.04" ]; then
		apt-get install -y -q dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc1 steamcmd >/dev/null
	elif [ "${DISTRO_VERSION}" == "22.04" ]; then
		apt-get install -y -q dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc-s1 steamcmd >/dev/null
  	elif [ "${DISTRO_VERSION}" == "24.04" ]; then
		apt-get install -y -q dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat-traditional lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc-s1 steamcmd >/dev/null
	else
		echo "$DISTRO_OS $DISTRO_VERSION not officially supported; using Ubuntu 24.04 config"
		apt-get install -y -q dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat-traditional lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc-s1 steamcmd >/dev/null
	fi
elif [[ $DISTRO_OS == Debian* ]]; then
	if [ "${DISTRO_VERSION}" == "10" ]; then
		apt-get install -y dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat-traditional lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc1 >/dev/null
	elif [ "${DISTRO_VERSION}" == "11" ]; then
		apt-get install -y dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat-traditional lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc-s1 >/dev/null
	elif [ "${DISTRO_VERSION}" == "12" ]; then
		apt-get install -y dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat-traditional lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc-s1 >/dev/null
	elif [ "${DISTRO_VERSION}" == "13" ]; then
		apt-get install -y dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat-traditional lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc-s1 >/dev/null
	else
		echo "$DISTRO_OS: $DISTRO_VERSION not officially supported; using Debian 13 config"
		apt-get install -y dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat-traditional lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc-s1 >/dev/null
	fi
else
	echo "ERROR: OS distribution not supported. $DISTRO_OS: $DISTRO_VERSION"
	exit 1
fi

echo "Checking steamcmd exists..."
if [ ! -d "/steamcmd" ]; then
	mkdir /steamcmd && cd /steamcmd
	wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
	tar -xvzf steamcmd_linux.tar.gz
	mkdir -p /root/.steam/sdk32/
	ln -s /steamcmd/linux32/steamclient.so /root/.steam/sdk32/
	mkdir -p /root/.steam/sdk64/
	ln -s /steamcmd/linux64/steamclient.so /root/.steam/sdk64/
fi

echo "Downloading any updates for CS2..."
# https://developer.valvesoftware.com/wiki/Command_line_options
sudo /steamcmd/steamcmd.sh \
  +api_logging 1 1 \
  +@sSteamCmdForcePlatformType linux \
  +@sSteamCmdForcePlatformBitness $BITS \
  +force_install_dir /home/root/cs2 \
  +login anonymous \
  +app_update 730 \
  +quit

cd /home/root

mkdir -p /root/.steam/sdk32/
ln -s /steamcmd/linux32/steamclient.so /root/.steam/sdk32/
mkdir -p /root/.steam/sdk64/
ln -s /steamcmd/linux64/steamclient.so /root/.steam/sdk64/

mkdir -p /home/root/.steam/sdk32/
ln -s /steamcmd/linux32/steamclient.so /home/root/.steam/sdk32/
mkdir -p /home/root/.steam/sdk64/
ln -s /steamcmd/linux64/steamclient.so /home/root/.steam/sdk64/

if [ "${DISTRO_OS}" == "Ubuntu" ]; then
	if [ "${DISTRO_VERSION}" == "22.04" ]; then
		# https://forums.alliedmods.net/showthread.php?t=336183
		rm /home/root/cs2/bin/libgcc_s.so.1
	fi
fi

# Copy start_cs2_server.sh script
cp /scripts/start_cs2_server.sh /home/root/
chmod +x /home/root/start_cs2_server.sh

# Delete addons folder as if we remove something later in git it won't get deleted
echo "Deleting addons folder..."
rm -rf /home/root/cs2/game/csgo/addons
rm -rf /home/root/cs2/game/csgo/cfg/MatchZy
sleep 1

echo "Downloading metamod"
cd /home/root/cs2/game/csgo/
wget -O metamod.tar.gz https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1315-linux.tar.gz
tar -xzvf metamod.tar.gz
rm -f metamod.tar.gz
rm -f README.md
rm -f LICENSE
sleep 1

#echo "Downloading MatchZy with cssharp"
#cd /home/root/cs2/game/csgo/
#wget -O matchzy-cssharp-latest.zip $(curl -s https://api.github.com/repos/shobhit-pathak/MatchZy/releases/latest | grep -oP '"browser_download_url": "\K[^"]*with-cssharp[^"]*linux[^"]*\.zip')
#unzip matchzy-cssharp-latest.zip
#rm -f matchzy-cssharp-latest.zip
#rm -f README.md
#rm -f LICENSE
#sleep 1

echo "Downloading cssharp"
cd /home/root/cs2/game/csgo/
#wget -O cssharp-latest.zip $(curl -s https://api.github.com/repos/roflmuffin/CounterStrikeSharp/releases/latest | grep -oP '"browser_download_url": "\K[^"]*with-runtime[^"]*linux[^"]*\.zip')
wget -O cssharp-latest.zip https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v1.0.314/counterstrikesharp-with-runtime-linux-1.0.314.zip
unzip cssharp-latest.zip
rm -f cssharp-latest.zip
rm -f README.md
rm -f LICENSE
sleep 1

echo "Downloading MatchZy"
rm -rf /home/root/cs2/game/csgo/cfg/MatchZy
#wget -O MatchZy-latest.zip $(curl -s https://api.github.com/repos/shobhit-pathak/MatchZy/releases/latest | grep -oP '"browser_download_url": "\K[^"]*MatchZy-\d+\.\d+\.\d+\.zip')
wget -O MatchZy-latest.zip https://github.com/shobhit-pathak/MatchZy/releases/download/0.8.8/MatchZy-0.8.8.zip
unzip MatchZy-latest.zip
rm -f MatchZy-latest.zip
rm -f README.md
rm -f LICENSE
echo "matchzy_use_pause_command_for_tactical_pause true" >> /home/root/cs2/game/csgo/cfg/MatchZy/config.cfg
echo "matchzy_enable_tech_pause false" >> /home/root/cs2/game/csgo/cfg/MatchZy/config.cfg
echo "matchzy_tech_pause_flag \"@css/root\"" >> /home/root/cs2/game/csgo/cfg/MatchZy/config.cfg
echo "matchzy_minimum_ready_required 0" >> /home/root/cs2/game/csgo/cfg/MatchZy/config.cfg
sleep 1

echo "Adding admins"
cp /scripts/admins.json /home/root/cs2/game/csgo/addons/counterstrikesharp/configs/admins.json

cd /home/root/cs2

# Define the file name
FILE="game/csgo/gameinfo.gi"

# Define the pattern to search for and the line to add
PATTERN="Game_LowViolence[[:space:]]*csgo_lv // Perfect World content override"
LINE_TO_ADD="\t\t\tGame\tcsgo/addons/metamod"

# Use a regular expression to ignore spaces when checking if the line exists
REGEX_TO_CHECK="^[[:space:]]*Game[[:space:]]*csgo/addons/metamod"

# Check if the line already exists in the file, ignoring spaces
if grep -qE "$REGEX_TO_CHECK" "$FILE"; then
    echo "$FILE already patched for Metamod."
else
    # If the line isn't there, use awk to add it after the pattern
    awk -v pattern="$PATTERN" -v lineToAdd="$LINE_TO_ADD" '{
        print $0;
        if ($0 ~ pattern) {
            print lineToAdd;
        }
    }' "$FILE" > tmp_file && mv tmp_file "$FILE"
    echo "$FILE successfully patched for Metamod."
fi


