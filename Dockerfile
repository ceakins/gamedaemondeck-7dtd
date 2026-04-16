# Use the official SteamCMD image as our base
FROM cm2network/steamcmd:latest

LABEL maintainer="GameDaemonDeck.com"
LABEL description="Automated 7 Days to Die (7DtD) dedicated server with dynamic XML configuration and persistent volume support."

# Document the ports this image requires
EXPOSE 26900/tcp 26900/udp 26901/udp 26902/udp 8080/tcp

# The base image uses the user 'steam'
USER steam

# Create the directories where the game and saves will live
RUN mkdir -p /home/steam/7dtd /home/steam/.local/share/7DaysToDie

# Copy our custom startup script into the Docker image
COPY --chown=steam:steam entrypoint.sh /home/steam/entrypoint.sh
RUN chmod +x /home/steam/entrypoint.sh

# Set the working directory
WORKDIR /home/steam/7dtd

# Define default environment variables
ENV SERVER_NAME="!GameDaemonDeck.com! 7 Days to Die"
ENV SERVER_PASSWORD=""
ENV MAX_PLAYERS="8"
ENV ADMIN_STEAM_ID=""

# Tell Docker to run our script when the container starts
ENTRYPOINT ["/home/steam/entrypoint.sh"]
