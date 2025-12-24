# Gridcoin Docker - .deb Package Installation

This Docker setup uses pre-built Gridcoin .deb packages instead of building from source, making it faster and simpler to deploy.

## Quick Start

### Build the Docker Image

```bash
# Build with a specific .deb package URL
docker build -t gridcoin-deb \
  --build-arg GRIDCOIN_DEB_URL=https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.trixie-1_amd64.deb \
  .

# Or build with a local .deb file (copy to build context first)
docker build -t gridcoin-deb .
```

### Run the Container

```bash
docker run -d \
  --name gridcoin_node \
  -v /path/to/blockchain/dir:/home/grc \
  -v /path/to/boinc/dir:/var/lib/boinc \
  -p 32749:32749 \
  gridcoin-deb
```

## Available .deb Packages

You can find .deb packages for different Ubuntu/Debian versions at:
https://github.com/gridcoin-community/Gridcoin-Research/releases

### Common Package Examples

- **Ubuntu 24.04 (Noble)**: `gridcoinresearchd_5.4.9.0.noble-1_amd64.deb`
- **Ubuntu 22.04 (Jammy)**: `gridcoinresearchd_5.4.9.0.jammy-1_amd64.deb`  
- **Ubuntu 20.04 (Focal)**: `gridcoinresearchd_5.4.9.0.focal-1_amd64.deb`
- **Debian 12 (Bookworm)**: `gridcoinresearchd_5.4.9.0.bookworm-1_amd64.deb`
- **Debian 11 (Bullseye)**: `gridcoinresearchd_5.4.9.0.bullseye-1_amd64.deb`
- **Debian 13 (Trixie)**: `gridcoinresearchd_5.4.9.0.trixie-1_amd64.deb`

## Configuration

### Data Volumes

- `/home/grc` - Blockchain data directory (contains `.GridcoinResearch` folder)

### Default Configuration

The container creates a basic `gridcoinresearch.conf` file if none exists:
- RPC username: `grc_user`
- RPC password: `grc_pass`
- Console output enabled: `printtoconsole=1`

**Important**: Change these default credentials for production use!

### Custom Configuration

Place your custom `gridcoinresearch.conf` file in your mounted volume:
```
/path/to/blockchain/dir/.GridcoinResearch/gridcoinresearch.conf
```

## Using the CLI

### Interactive Commands
```bash
# Get help
docker exec -it gridcoin_node cli help

# Check mining info
docker exec -it gridcoin_node cli getmininginfo

# Get wallet info
docker exec -it gridcoin_node cli getwalletinfo
```

### Using Alias (Recommended)
Add to your `.bashrc` or `.zshrc`:
```bash
alias grccli='docker exec -it gridcoin_node cli'
```

Then use: `grccli getmininginfo`

### Execute Commands as Gridcoin User
```bash
# Run commands as the grc user
docker exec -it gridcoin_node asgrc ls -la /home/grc
```

## Docker Compose Example

Create a `docker-compose.yml`:

```yaml
services:
  gridcoin:
    build:
      context: .
      args:
        GRIDCOIN_DEB_URL: https://github.com/gridcoin-community/Gridcoin-Research/releases/download/5.4.9.0/gridcoinresearchd_5.4.9.0.noble-1_amd64.deb
    container_name: gridcoin_node
    restart: unless-stopped
    ports:
      - "32749:32749"
    volumes:
      - ./blockchain:/home/grc
    environment:
      - GRPC_MULTIPLEX_TIMEOUT=10
```

## Advantages of .deb Approach

1. **Faster Build Times**: No compilation required
2. **Smaller Image Size**: No build dependencies included
3. **Simplified Maintenance**: Use official releases
4. **Platform Compatibility**: Works with official Ubuntu/Debian packages
5. **Easy Updates**: Just rebuild with new .deb URL

## Troubleshooting

### Container Exits Immediately
Check logs: `docker logs gridcoin_node`

### Permission Issues
The entrypoint automatically sets correct permissions, but verify:
```bash
docker exec -it gridcoin_node asgrc ls -la /home/grc
```

### Network Issues
Ensure port 32749 is open:
```bash
netstat -tulpn | grep 32749
```
Add port to firewall:
```
sudo ufw allow 32749
sudo ufw status verbose
```
## Security Notes

1. **Change default RPC credentials** in your config file
2. **Use strong passwords** for wallet encryption
3. **Keep the container updated** with latest .deb packages
4. **Monitor logs** for suspicious activity

## Support

- Gridcoin Official: https://gridcoin.us/
- GitHub Releases: https://github.com/gridcoin-community/Gridcoin-Research/releases
- Community Forum: https://www.gridcoin.us/forum/