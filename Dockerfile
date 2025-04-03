FROM ubuntu:24.10

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y sudo wget unzip curl apt-utils dotnet-sdk-9.0

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    apt install --quiet --yes --no-install-recommends tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Set working directory for scripts
WORKDIR /scripts

# Copy the installation script
COPY install_deps.sh ./
COPY start_cs2_server.sh ./

# Ensure the script is executable
RUN chmod +x install_deps.sh
RUN chmod +x start_cs2_server.sh

RUN ./install_deps.sh

# Set the entrypoint to log in as the 'steam' user and execute the server start script
ENTRYPOINT ["bash", "-c", "./start_cs2_server.sh"]

