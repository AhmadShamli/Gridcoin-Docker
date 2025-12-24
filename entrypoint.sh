#!/bin/bash
set -e

CONF_DIR="/home/grc/.GridcoinResearch"
CFG_FILE="$CONF_DIR/gridcoinresearch.conf"

cat /home/grc/.GridcoinResearch/gridcoinresearch.conf > /root/.GridcoinResearch/gridcoinresearch.conf

if [[ "$1" == 'gridcoinresearchd' || "$1" == '/usr/bin/gridcoinresearchd' ]]; then
    mkdir -p "$CONF_DIR"
    
    # Check if config file exists, if not create a basic one
    if [ ! -f "${CFG_FILE}" ]; then
        echo "No gridcoinresearch.conf found, creating basic configuration..."
        echo "# Gridcoin configuration file" > "${CFG_FILE}"
        echo "listen=1" >> "${CFG_FILE}"
        echo "server=1" >> "${CFG_FILE}"
        echo "daemon=0" >> "${CFG_FILE}"
        echo "printtoconsole=1" >> "${CFG_FILE}"
    fi

    # Fix chown syntax warning (use grc:grc) and permissions
    chmod 0600 "${CFG_FILE}"
    chown -R grc:grc "${CONF_DIR}"

    # Execute the daemon using the absolute path to fix "not found in $PATH" error
    exec gosu grc:grc /usr/bin/gridcoinresearchd "$@"
fi

# The following blocks assume the user runs the container with 'cli' or 'asgrc' ENTRYPOINT override

if [ "$(basename $0)" = 'cli' ]; then
    # Execute CLI commands as the grc user
    exec gosu grc:grc /usr/bin/gridcoinresearchd "$@"
fi

if [ "$(basename $0)" = 'asgrc' ]; then
    # Execute arbitrary commands as the grc user
    exec gosu grc:grc "$@"
fi

# Fallback: execute the command passed to docker run if not one of the above
exec "$@"
