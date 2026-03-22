# Stage 1: Build the app
FROM maven:3.6.3-jdk-8 AS builder

WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the app
FROM openjdk:8-jdk-alpine

WORKDIR /app
COPY --from=builder /build/target/bookmyshow-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
