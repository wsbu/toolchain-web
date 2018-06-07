FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
  echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - # Will run `apt-get update` again automatically
RUN apt-get install -y nodejs \
  git zip unzip balance libpcap-dev tar \
  build-essential \
  libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev g++ \
  libkrb5-dev \
  vim \
  mysql-client \
  rpm createrepo \
  yum-utils \
  sudo \
  mongodb-org-tools

# Install build tools
RUN npm config set registry https://registry.npmjs.org/ 2> /dev/null
RUN npm install -g grunt 2> /dev/null
RUN npm install -g bower 2> /dev/null

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer
USER developer
WORKDIR /home/developer

COPY start.sh /start.sh
ENTRYPOINT ["/start.sh"]
