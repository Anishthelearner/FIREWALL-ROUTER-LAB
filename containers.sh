#!/bin/bash

# Port mappings per container
PORTS_FIREWALL="-p 1020:20 -p 1021:21 -p 1022:22 -p 1023:23 -p 1025:25 -p 1053:53 -p 1069:69 -p 1080:80 -p 1110:110 -p 1143:143 -p 1443:443 -p 1800:8080"
PORTS_CLIENT1="-p 2020:20 -p 2021:21 -p 2022:22 -p 2023:23 -p 2025:25 -p 2053:53 -p 2069:69 -p 2080:80 -p 2110:110 -p 2143:143 -p 2443:443 -p 2800:8080"
PORTS_CLIENT2="-p 3020:20 -p 3021:21 -p 3022:22 -p 3023:23 -p 3025:25 -p 3053:53 -p 3069:69 -p 3080:80 -p 3110:110 -p 3143:143 -p 3443:443 -p 3800:8080"
PORTS_CLIENT3="-p 4020:20 -p 4021:21 -p 4022:22 -p 4023:23 -p 4025:25 -p 4053:53 -p 4069:69 -p 4080:80 -p 4110:110 -p 4143:143 -p 4443:443 -p 4800:8080"

echo "Creating firewall/router container..."

# Create the firewall/router container
docker run -dit --name firewall --hostname firewall --privileged \
  --network labnet192 --ip 192.168.100.1 \
  $PORTS_FIREWALL \
  ubuntu-lab

# Connect firewall to the second network
docker network connect --ip 172.24.0.1 labnet172 firewall

echo "Creating client1 on labnet192..."

# Client 1
docker run -dit --name client1 --hostname client1 --privileged \
  --network labnet192 --ip 192.168.100.2 \
  $PORTS_CLIENT1 \
  ubuntu-lab

echo "Creating client2 and client3 on labnet172..."

# Client 2
docker run -dit --name client2 --hostname client2 --privileged \
  --network labnet172 --ip 172.24.0.2 \
  $PORTS_CLIENT2 \
  ubuntu-lab

# Client 3
docker run -dit --name client3 --hostname client3 --privileged \
  --network labnet172 --ip 172.24.0.3 \
  $PORTS_CLIENT3 \
  ubuntu-lab

echo "All containers created and ports mapped to host successfully."
