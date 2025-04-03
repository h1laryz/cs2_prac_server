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
		apt-get install -y -q libicu-dev dnsutils curl wget screen nano file tar bzip2 gzip unzip hostname bsdmainutils python3 util-linux xz-utils ca-certificates binutils bc jq tmux netcat-traditional lib32stdc++6 libsdl2-2.0-0:i386 distro-info lib32gcc-s1 steamcmd >/dev/null
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

# https://developer.valvesoftware.com/wiki/Command_line_options
sudo /steamcmd/steamcmd.sh \
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

