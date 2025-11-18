SCRIPT_DIR=$(realpath "$0" | sed 's/\/run_godouse_server.sh//') 
EXECUTABLE_PATH="$SCRIPT_DIR/bin/Godouse.x86_64"


# godot --path "$SCRIPT_DIR" --headless

# nohup ./game.x86_64 --headless --display-driver dummy > server.log 2>&1 &
echo "Starting Godot server..." >> "$SCRIPT_DIR/server.log"
nohup /usr/local/bin/godot --path "$SCRIPT_DIR" --headless > "$SCRIPT_DIR/server.log" 2>&1 &