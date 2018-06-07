FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
  echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y git zip unzip balance libpcap-dev tar
RUN apt-get install -y build-essential
RUN apt-get install -y libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev g++
RUN apt-get install -y libkrb5-dev
RUN apt-get install -y vim
RUN apt-get install -y mysql-client
RUN apt-get install -y rpm createrepo
RUN apt-get install -y yum-utils
RUN apt-get install -y sudo
RUN apt-get install -y mongodb-org-tools

COPY start.sh /start.sh

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer
RUN npm config set registry https://registry.npmjs.org/ 2> /dev/null
RUN npm install -g grunt 2> /dev/null
RUN npm install -g bower 2> /dev/null
USER developer
WORKDIR /home/developer

ENTRYPOINT ["/start.sh"]
