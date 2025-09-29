FROM jenkins/jenkins:lts
USER root

RUN apt-get update && \
    apt-get install -y \
    maven \
    git \
    docker.io \
    sudo && \
    rm -rf /var/lib/apt/lists/*

RUN usermod -aG docker jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jenkins