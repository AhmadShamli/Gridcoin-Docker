# Minimal docker image to run Gridcoin fullnode using pre-built .deb package
# Using trixie-slim as specified in the previous prompt's context
FROM debian:trixie-slim

ENV DEBIAN_FRONTEND='noninteractive'

# ... (entrypoint.sh COPY and CMD lines from your original file) ...
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
#CMD ["gridcoinresearchd"]
CMD ["/usr/bin/gridcoinresearchd"]

# Install base system dependencies
RUN apt update && \
    apt upgrade -y -o Dpkg::Options::="--force-confold" && \
    apt install -y \
    curl \
    gosu \
    wget \
    procps

# Add non-free and contrib components (Trixie uses deb822 format)
RUN sed -i 's/Components: main non-free-firmware/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources && \
    apt update

# COMBINED STEP: Update again and install application dependencies
# We also use the correct Boost 1.83.0 names for Trixie, as previously advised
RUN apt update && apt install -y \
    libboost-filesystem1.83.0 \
    libboost-iostreams1.83.0 \
    libboost-thread1.83.0 \
    libcurl4 \
    libcurl4-gnutls-dev \
    libdb5.3++t64 \
    libzip5 \
    libminiupnpc18

# ... (Rest of your Dockerfile remains the same) ...
RUN useradd -d /home/grc -U -m grc && \
    ln -s /entrypoint.sh /usr/local/bin/cli && \
    ln -s /entrypoint.sh /usr/local/bin/asgrc

RUN apt clean && \
    apt autoclean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Optional: Enable TCP Fast Open for network performance
#RUN echo "net.ipv4.tcp_fastopen=3" >> /etc/sysctl.conf && sysctl -p
# run it on host with: sudo sysctl -w net.ipv4.tcp_fastopen=3

# Install Gridcoin from .deb package
ARG GRIDCOIN_DEB_URL
RUN if [ -n "$GRIDCOIN_DEB_URL" ]; then \
        wget -O /tmp/gridcoin.deb "$GRIDCOIN_DEB_URL" && \
        # Attempt install, fix dependencies, then force re-install to be sure
        (dpkg -i /tmp/gridcoin.deb || apt-get install -f -y) && \
        dpkg -i /tmp/gridcoin.deb && \
        rm /tmp/gridcoin.deb; \
    else \
        exit 1; \
    fi


WORKDIR /home/grc
VOLUME ["/home/grc"]
