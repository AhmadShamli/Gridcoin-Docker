# Minimal docker image to run Gridcoin fullnode using pre-built .deb package
FROM ubuntu:noble

ENV DEBIAN_FRONTEND='noninteractive'

# Copy entrypoint script
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["gridcoinresearchd"]

# Install system dependencies and Gridcoin from .deb
RUN apt update && \
    apt upgrade -y -o Dpkg::Options::="--force-confold" && \
    apt install -y \
    curl \
    gosu \
    wget \
    libboost-filesystem1.83.0 \
    libboost-iostreams1.83.0 \
    libboost-thread1.83.0 \
    libcurl4 \
    libcurl4-gnutls-dev \
    libdb5.3++ \
    libzip4 \
    && \
    useradd -d /home/grc -U -m grc && \
    ln -s /entrypoint.sh /usr/local/bin/cli && \
    ln -s /entrypoint.sh /usr/local/bin/asgrc && \
    apt clean && \
    apt autoclean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Install Gridcoin from .deb package
# Users should download the appropriate .deb file from:
# https://github.com/gridcoin-community/Gridcoin-Research/releases
# Example: https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.trixie-1_amd64.deb
ARG GRIDCOIN_DEB_URL
RUN if [ -n "$GRIDCOIN_DEB_URL" ]; then \
        echo "Downloading Gridcoin .deb from: $GRIDCOIN_DEB_URL" && \
        wget -O /tmp/gridcoin.deb "$GRIDCOIN_DEB_URL" && \
        dpkg -i /tmp/gridcoin.deb || apt-get install -f -y && \
        rm /tmp/gridcoin.deb; \
    else \
        echo "GRIDCOIN_DEB_URL not provided. Please provide --build-arg GRIDCOIN_DEB_URL=<url>" && \
        exit 1; \
    fi

WORKDIR /home/grc
VOLUME ["/home/grc"]