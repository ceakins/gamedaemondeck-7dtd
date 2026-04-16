#!/bin/bash
# 7 Days to Die Automated Startup Script

# 1. Download/Update the game files
# We use /home/steam/7dtd as the target because it is mapped to your host folder
echo "Downloading 7 Days to Die Server via SteamCMD..."
/home/steam/steamcmd/steamcmd.sh +force_install_dir /home/steam/7dtd +login anonymous +app_update 294420 validate +quit

# 2. Apply automated XML configurations
echo "Applying automated configuration..."
CONFIG_FILE="/home/steam/7dtd/serverconfig.xml"

# Wait for SteamCMD to actually finish writing the file to disk
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Waiting for serverconfig.xml to appear..."
    sleep 5
fi

if [ -f "$CONFIG_FILE" ]; then
    echo "Updating serverconfig.xml properties..."
    # Use comma as delimiter for sed to avoid issues with special characters in Server Name
    sed -i "s,<property name=\"ServerName\" value=\"[^\"]*\",<property name=\"ServerName\" value=\"${SERVER_NAME}\",g" "$CONFIG_FILE"
    sed -i "s,<property name=\"ServerMaxPlayerCount\" value=\"[^\"]*\",<property name=\"ServerMaxPlayerCount\" value=\"${MAX_PLAYERS}\",g" "$CONFIG_FILE"
    sed -i "s,<property name=\"ServerPassword\" value=\"[^\"]*\",<property name=\"ServerPassword\" value=\"${SERVER_PASSWORD}\",g" "$CONFIG_FILE"
else
    echo "ERROR: serverconfig.xml was not found. SteamCMD may have failed to download files."
fi

# 3. Configure Admins
echo "Configuring Admins..."
SAVE_DIR="/home/steam/.local/share/7DaysToDie/Saves"
ADMIN_FILE="$SAVE_DIR/serveradmin.xml"

# Ensure the save directory exists. 
# If this fails, the host volume permissions are likely incorrect.
mkdir -p "$SAVE_DIR"

if [ ! -f "$ADMIN_FILE" ] && [ -f "/home/steam/7dtd/serveradmin.xml" ]; then
    cp "/home/steam/7dtd/serveradmin.xml" "$ADMIN_FILE"
fi

if [ -n "$ADMIN_STEAM_ID" ] && [ -f "$ADMIN_FILE" ]; then
    if ! grep -q "$ADMIN_STEAM_ID" "$ADMIN_FILE"; then
        echo "Adding Admin SteamID: $ADMIN_STEAM_ID"
        sed -i "/<admins>/a \    <admin steamID=\"${ADMIN_STEAM_ID}\" permission_level=\"0\" />" "$ADMIN_FILE"
    fi
fi

# 4. Start the server
echo "Starting 7 Days to Die Server..."
export LD_LIBRARY_PATH=/home/steam/7dtd/7DaysToDieServer_Data/Plugins/x86_64:$LD_LIBRARY_PATH
cd /home/steam/7dtd

# Verification check
if [ ! -f "./7DaysToDieServer.x86_64" ]; then
    echo "CRITICAL ERROR: Game binary not found in /home/steam/7dtd"
    ls -la
    exit 1
fi

exec ./7DaysToDieServer.x86_64 -logfile /dev/stdout -batchmode -nographics -dedicated -configfile="$CONFIG_FILE"