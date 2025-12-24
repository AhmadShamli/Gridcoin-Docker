#!/bin/bash
set -e

CFG_FILE="/home/grc/.GridcoinResearch/gridcoinresearch.conf"

if [ "$1" = 'gridcoinresearchd' ]; then
    mkdir -p /home/grc/.GridcoinResearch
    if [ ! -f "${CFG_FILE}" ]; then
        # Use environment variables if set, otherwise fall back to defaults
        RPC_USER="${GRIDCOIN_RPC_USER:-grc_user}"
        RPC_PASS="${GRIDCOIN_RPC_PASS:-grc_pass}"

        echo -e "rpcuser=${RPC_USER}" >> "${CFG_FILE}"
        echo -e "rpcpassword=${RPC_PASS}" >> "${CFG_FILE}"
    fi
    echo "Setting printtoconsole to true"
    ! grep -q 'printtoconsole=1' "${CFG_FILE}" && \
        sed \
            -e '/^\(printtoconsole=\).*/{s//\11/;:a;n;ba;q}' \
            -e '$aprinttoconsole=1' \
            -i "${CFG_FILE}"
    chmod 0600 "${CFG_FILE}"
    chown -R grc.grc /home/grc/.GridcoinResearch

    exec gosu grc:grc $@
fi

if [ "$(basename $0)" = 'cli' ]; then
    exec gosu grc:grc gridcoinresearchd $@
fi

if [ "$(basename $0)" = 'asgrc' ]; then
    exec gosu grc:grc $@
fi

exec $@
