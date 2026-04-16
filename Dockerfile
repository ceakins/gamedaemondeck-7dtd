FROM cm2network/steamcmd:latest

LABEL maintainer="GameDaemonDeck.com"
LABEL description="7 Days to Die Dedicated Server with Auto-Config"

# Document the ports this image requires
EXPOSE 26900/tcp 26900/udp 26901/udp 26902/udp 8082/tcp

# Use root to ensure we can set up the internal environment correctly
USER root

# Create the internal directories that map to your host volumes
RUN mkdir -p /home/steam/7dtd /home/steam/.local/share/7DaysToDie && \
    chown -R steam:steam /home/steam/7dtd /home/steam/.local/share/7DaysToDie

# Copy and prepare the startup script
COPY --chown=steam:steam entrypoint.sh /home/steam/entrypoint.sh
RUN chmod +x /home/steam/entrypoint.sh

# Switch back to the 'steam' user for security
USER steam
WORKDIR /home/steam/7dtd

# Default Environment Variables (Overridden by your docker-compose.yml)
ENV SERVER_NAME="!GameDaemonDeck.com! 7 Days to Die"
ENV SERVER_PASSWORD=""
ENV MAX_PLAYERS="8"
ENV ADMIN_STEAM_ID=""

ENTRYPOINT ["/home/steam/entrypoint.sh"]