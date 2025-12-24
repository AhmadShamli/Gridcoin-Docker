#!/bin/bash

# Example usage script for Gridcoin .deb Docker setup
# This script demonstrates how to build and run Gridcoin using pre-built .deb packages

set -e

echo "=== Gridcoin .deb Docker Example ==="
echo ""

# Example .deb URLs for different Ubuntu/Debian versions
echo "Available .deb package examples:"
echo "Ubuntu 24.04 (Noble): https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.noble-1_amd64.deb"
echo "Ubuntu 22.04 (Jammy): https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.jammy-1_amd64.deb"
echo "Ubuntu 20.04 (Focal): https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.focal-1_amd64.deb"
echo "Debian 12 (Bookworm): https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.bookworm-1_amd64.deb"
echo "Debian 11 (Bullseye): https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.bullseye-1_amd64.deb"
echo "Debian 13 (Trixie): https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.trixie-1_amd64.deb"
echo ""

# Build command
echo "=== Step 1: Build the Docker image ==="
echo "Use one of these commands:"
echo ""
echo "# For Ubuntu 24.04:"
echo "docker build -t gridcoin-deb \\"
echo "  --build-arg GRIDCOIN_DEB_URL=https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.noble-1_amd64.deb \\"
echo "  ."
echo ""
echo "# For Ubuntu 22.04:"
echo "docker build -t gridcoin-deb \\"
echo "  --build-arg GRIDCOIN_DEB_URL=https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.jammy-1_amd64.deb \\"
echo "  ."
echo ""

# Create directories
echo "=== Step 2: Create data directories ==="
echo "mkdir -p blockchain"
echo ""

# Run container
echo "=== Step 3: Run the container ==="
echo "docker run -d \\"
echo "  --name gridcoin_node \\"
echo "  -v \$(pwd)/blockchain:/home/grc \\"
echo "  -p 32749:32749 \\"
echo "  gridcoin-deb"
echo ""

# CLI usage
echo "=== Step 4: Use the CLI ==="
echo "# Get help"
echo "docker exec -it gridcoin_node cli help"
echo ""
echo "# Check mining info"
echo "docker exec -it gridcoin_node cli getmininginfo"
echo ""
echo "# Create alias for convenience"
echo "alias grccli='docker exec -it gridcoin_node cli'"
echo ""

# Docker Compose usage
echo "=== Alternative: Using Docker Compose ==="
echo "# Edit the GRIDCOIN_DEB_URL in docker-compose.yml"
echo "# Then run:"
echo "docker-compose up -d"
echo ""
echo "# View logs"
echo "docker-compose logs -f"
echo ""
echo "# Stop container"
echo "docker-compose down"