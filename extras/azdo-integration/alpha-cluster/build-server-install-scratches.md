#!/bin/bash

# kubectl create secret generic dynatrace-otelcol-dt-api-credentials --from-literal=DT_ENDPOINT=https://sro97894.live.dynatrace.com/api/v2/otlp --from-literal=DT_API_TOKEN=dt0c01.4IM3DHAT2JIT5OFNLEHHDIML.XXX --namespace astroshop


# when compiling on MAC; those images can be deployed in GKE/ACE
# hence, ubildserver and synch with git. SSHFS (also not working)


## Ubuntu 20
### Install in UBUNTU
sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-9.0
# C++ Build Essentials
sudo apt update && sudo apt install build-essential
# Golang
sudo apt install golang-go
# Java
sudo apt install default-jre
sudo apt install default-jdk
# Node
sudo apt install nodejs

# Php
sudo apt install php libapache2-mod-php
sudo apt install composer

# Python 3
sudo apt install python3

# Ruby
sudo apt install ruby-full

# Rust
sudo apt install rustc

# Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# https://gist.github.com/jniltinho/bcb28a99aef33dcb5f35c297bf71e4ae
touch install_buildkit.sh
vi install_buildkit.sh



#### Scratches

astroshop.34.48.119.107.nip.io
kubectl set image deployment/astroshop-adservice adservice=shinojosa/astroshop:1.11.1-adservice -n astroshop


kubectl set image deployment/astroshop-productcatalogservice productcatalogservice=shinojosa/astroshop:1.11.1-productcatalogservice -n astroshop

kubectl set image deployment/astroshop-productcatalogservice productcatalogservice=ghcr.io/open-telemetry/demo:1.11.1-productcatalogservice -n astroshop