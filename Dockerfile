# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy only pom.xml first to leverage Docker layer caching
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Download dependencies (cached unless pom.xml changes)
RUN ./mvnw dependency:go-offline -B

# Copy source code and build the application
COPY src src
RUN ./mvnw clean package -DskipTests -Dmaven.compiler.release=17

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-focal

# Set working directory
WORKDIR /app

# Expose the port specified in application.properties
EXPOSE 8081

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]