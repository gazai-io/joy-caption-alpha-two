#!/bin/sh

export HF_HOME=/home/gazai/MyPrograms/joy-caption-alpha-two/.hf_cache
export GRADIO_SERVER_NAME="0.0.0.0"
export GRADIO_SERVER_PORT="7866"

PIDFILE="/home/gazai/MyPrograms/joy-caption-alpha-two/app.pid"

PID=$(cat $PIDFILE)

# Check if PID file exists and process is running
if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")
    if [ -n "$PID" ] && [ -d "/proc/$PID" ]; then
        echo "joy-caption-alpha-two is already running (PID: $PID). Exiting."
        exit 1
    fi
fi

# Save the PID of the current script
echo $$ > "$PIDFILE"

cd /home/gazai/MyPrograms/joy-caption-alpha-two

# Start the application in background.
./venv/bin/python ./app.py &

# Get the PID of the Python process
APP_PID=$!

# Schedule shutdown after 10 minutes (600 seconds)
(
    sleep 600
    echo "Shutting down the server after 10 minutes..."
    kill $APP_PID
    rm -f "$PIDFILE"
) &

wait $APP_PID  # Wait for the app process to finish

