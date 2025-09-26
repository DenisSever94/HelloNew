FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/HelloNew-1.0-SNAPSHOT.jar app.jar
EXPOSE 9090
ENTRYPOINT ["java", "-jar", "app.jar"]