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

RUN apt-get update && \
    apt-get install -y \
    maven \
    git \
    curl \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем Docker CLI
RUN curl -fsSL https://get.docker.com | sh

# Настраиваем пользователя
RUN usermod -aG docker jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Устанавливаем только рабочие плагины
RUN jenkins-plugin-cli --plugins \
    git \
    workflow-aggregator \
    docker-workflow

USER jenkins