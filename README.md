**Left 4 Dead 2 Server Docker Image**
====================================

Run a Left 4 Dead 2 server easily inside a Docker container, optimized for ARM64 (using box86).

**Supported tags**
-----------------

* `latest` - the most recent production-ready image, based on `sonroyaalmerol/steamcmd-arm64:root`

**Documentation**
----------------

### Ports
The container uses the following ports:
* `:27015 TCP/UDP` as the game transmission, pings and RCON port
* `:27005 UDP` as the client port

### Environment variables

* `L4D2_ARGS`: Additional arguments to pass to the server.
* `L4D2_CLIENTPORT`: The client port for the server.
* `L4D2_IP`: The IP address for the server.
* `L4D2_LAN`: Whether the server is LAN-only or not.
* `L4D2_MAP`: The map for the server.
* `L4D2_MAXPLAYERS`: The maximum number of players allowed to join the server.
* `L4D2_PORT`: The port for the server.
* `L4D2_SOURCETVPORT`: The Source TV port for the server.
* `L4D2_TICKRATE`: The tick rate for the server.

### Directory structure
The following directories and files are important for the server:

```
📦 /home/steam
|__📁l4d2-server // The server root (l4d2 folder name using env)
|  |__📁l4d2
|  |  |__📁cfg
|  |  |  |__⚙️server.cfg
|__📃srcds_run // Script to start the server
|__📃srcds_run-arm64 // Script to start the server on ARM64
```

### Examples

This will start a simple server in a container named `l4d2-server`:
```sh
docker run -d --name l4d2-server \
  -p 27005:27005/udp \
  -p 27015:27015 \
  -p 27015:27015/udp \
  -e L4D2_ARGS="" \
  -e L4D2_CLIENTPORT=27005 \
  -e L4D2_IP="" \
  -e L4D2_LAN="0" \
  -e L4D2_MAP="c1m1_hotel" \
  -e L4D2_MAXPLAYERS="12" \
  -e L4D2_PORT=27015 \
  -e L4D2_SOURCETVPORT="27020" \
  -e L4D2_TICKRATE="" \
  -v /home/ponfertato/Docker/l4d2-server:/home/steam/l4d2-server/l4d2 \
  ponfertato/l4d2:latest
```

...or Docker Compose:
```sh
version: '3'

services:
  l4d2-server:
    container_name: l4d2-server
    restart: unless-stopped
    image: ponfertato/l4d2:latest
    tty: true
    stdin_open: true
    ports:
      - "27005:27005/udp"
      - "27015:27015"
      - "27015:27015/udp"
    environment:
      - L4D2_ARGS=""
      - L4D2_CLIENTPORT=27005
      - L4D2_IP=""
      - L4D2_LAN="0"
      - L4D2_MAP="c1m1_hotel"
      - L4D2_MAXPLAYERS="12"
      - L4D2_PORT=27015
      - L4D2_SOURCETVPORT="27020"
      - L4D2_TICKRATE=""
    volumes:
      - ./l4d2-server:/home/steam/l4d2-server/l4d2
```

**Health Check**
----------------

This image contains a health check to continually ensure the server is online. That can be observed from the STATUS column of docker ps

```sh
CONTAINER ID        IMAGE                    COMMAND                 CREATED             STATUS                    PORTS                                                                                     NAMES
e9c073a4b262        ponfertato/l4d2            "/home/steam/entry.sh"   21 minutes ago      Up 21 minutes (healthy)   0.0.0.0:27005->27005/udp, 0.0.0.0:27015->27015/tcp, 0.0.0.0:27015->27015/udp   distracted_cerf
```

**License**
----------

This image is under the [MIT license](LICENSE).
