#!/bin/bash

# Define network details
NET1_NAME="labnet192"
NET1_SUBNET="192.168.100.0/24"
NET1_GATEWAY="192.168.100.254"

NET2_NAME="labnet172"
NET2_SUBNET="172.24.0.0/24"
NET2_GATEWAY="172.24.0.254"

# Create the first Docker network
docker network create \
  --driver bridge \
  --subnet=$NET1_SUBNET \
  --gateway=$NET1_GATEWAY \
  $NET1_NAME

# Create the second Docker network
docker network create \
  --driver bridge \
  --subnet=$NET2_SUBNET \
  --gateway=$NET2_GATEWAY \
  $NET2_NAME

echo "Docker networks '$NET1_NAME' and '$NET2_NAME' created successfully."
