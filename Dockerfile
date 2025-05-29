FROM ubuntu:plucky-20250415

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    telnet \
    ftp \
    apache2 \
    nginx \
    iputils-ping \
    net-tools \
    iproute2 \
    elinks \
    iptables \
    curl \
    nano \
    sudo \
    vim \
    && apt-get clean

CMD ["/bin/bash"]
