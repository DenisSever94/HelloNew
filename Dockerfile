#FROM jenkins/jenkins:lts
#USER root
#
#RUN apt-get update && \
#    apt-get install -y \
#    maven \
#    git \
#    docker.io \
#    sudo && \
#    rm -rf /var/lib/apt/lists/*
#RUN usermod -aG docker jenkins && \
#    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#USER jenkins

FROM jenkins/jenkins:lts
USER root

# Устанавливаем необходимые пакеты
RUN apt-get update && \
    apt-get install -y \
    maven \
    git \
    curl \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем Docker CLI
RUN curl -fsSL https://get.docker.com | sh

# Настраиваем пользователя jenkins
RUN usermod -aG docker jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Устанавливаем плагины Jenkins
RUN jenkins-plugin-cli --plugins \
    git:4.14.1 \
    workflow-aggregator:2.6 \
    pipeline-maven:3.10.12 \
    blueocean:1.25.8 \
    docker-workflow:1.29 \
    docker-plugin:1.2.10

USER jenkins