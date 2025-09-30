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
#
#FROM jenkins/jenkins:lts
#USER root

#FROM jenkins/agent:latest
#
## Установка Git
#RUN apt-get update && apt-get install -y git
#
## Установка Maven
#RUN apt-get install -y maven
#
## Установка других инструментов
#RUN apt-get install -y curl docker.io kubectl
#
## Настройка Maven (опционально)
#ENV MAVEN_HOME /usr/share/maven
#ENV MAVEN_CONFIG "/var/jenkins_home/.m2"

# Устанавливаем пакеты
#RUN apt-get update && \
#    apt-get install -y \
#    maven \
#    git \
#    curl \
#    sudo && \
#    rm -rf /var/lib/apt/lists/*
#
## Устанавливаем Docker
#RUN curl -fsSL https://get.docker.com | sh
#
## Устанавливаем kubectl (простой способ)
#RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
#    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
#    rm kubectl
#
## Настраиваем пользователя
#RUN usermod -aG docker jenkins && \
#    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#
#USER jenkins

FROM maven:3.9.11-openjdk-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:17-jre-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]