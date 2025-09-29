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

# Устанавливаем kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Настраиваем пользователя
RUN usermod -aG docker jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER jenkins