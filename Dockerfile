# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory inside the container
WORKDIR /app

# Copy project files
COPY . .

# Build the project and package the Spring Boot application
RUN mvn clean package -DskipTests -Dmaven.compiler.release=17

# Stage 2: Runtime
FROM eclipse-temurin:17

# Set working directory inside the container
WORKDIR /app

# Expose the application's port (Render will override with PORT env variable)
EXPOSE 8081

# Copy the built JAR from the previous stage
COPY --from=build /app/target/*.jar app.jar

# Configure environment variables for PostgreSQL connection
ENV SPRING_DATASOURCE_URL=${postgresql://bookapi_db_vm9i_user:Q1vz8rn5lb8CRm2RcAvuiXkzeE3uQIVY@dpg-d0q7dc0dl3ps73bda850-a/bookapi_db_vm9i}
ENV SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.postgresql.Driver
ENV SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT=org.hibernate.dialect.PostgreSQLDialect
ENV SPRING_JPA_HIBERNATE_DDL_AUTO=update
# Ensure Spring Boot uses Render's assigned port
ENV SERVER_PORT=${PORT:8081}

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]