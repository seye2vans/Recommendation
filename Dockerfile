# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 AS build

# Set working directory inside the container
WORKDIR /app

# Copy project files
COPY . .

# Build the project and package the Spring Boot application
RUN mvn clean package -DskipTests -Dmaven.compiler.release=17

# Stage 2: Runtime
FROM openjdk:17-jdk

# Set working directory inside the container
WORKDIR /app

# Expose the application's port (Render will override with PORT env variable)
EXPOSE 8081

# Copy the built JAR from the previous stage
COPY --from=build /app/target/*.jar app.jar

# Configure environment variables for PostgreSQL connection
ENV SPRING_DATASOURCE_URL=${DATABASE_URL}
ENV SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.postgresql.Driver
ENV SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT=org.hibernate.dialect.PostgreSQLDialect
ENV SPRING_JPA_HIBERNATE_DDL_AUTO=update

# Use PORT env var provided by platform like Render


# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
