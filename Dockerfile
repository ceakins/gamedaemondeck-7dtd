FROM cm2network/steamcmd:latest

LABEL maintainer="GameDaemonDeck.com"
LABEL description="7 Days to Die Dedicated Server with Auto-Config"

EXPOSE 26900/tcp 26900/udp 26901/udp 26902/udp 8080/tcp

# Set user to root briefly to ensure the script is copied and permissions are set
USER root
COPY --chown=steam:steam entrypoint.sh /home/steam/entrypoint.sh
RUN chmod +x /home/steam/entrypoint.sh && \
    mkdir -p /home/steam/7dtd /home/steam/.local/share/7DaysToDie && \
    chown -R steam:steam /home/steam/7dtd /home/steam/.local/share/7DaysToDie

# Switch back to steam user for execution
USER steam
WORKDIR /home/steam/7dtd

ENV SERVER_NAME="!GameDaemonDeck.com! 7 Days to Die"
ENV SERVER_PASSWORD=""
ENV MAX_PLAYERS="8"
ENV ADMIN_STEAM_ID=""

ENTRYPOINT ["/home/steam/entrypoint.sh"]