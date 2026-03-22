# Stage 1: Build the app using Maven
FROM maven:3.8.8-openjdk-8 AS builder

WORKDIR /build
COPY pom.xml ./
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the app using lightweight JDK
FROM openjdk:8-jdk-alpine

WORKDIR /app
COPY --from=builder /build/target/bookmyshow-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
