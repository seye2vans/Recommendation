# Stage 2: Runtime
FROM eclipse-temurin:17

WORKDIR /app

EXPOSE 8081

COPY --from=build /app/target/*.jar app.jar

# Pass env variables to Spring Boot at runtime
ENV SPRING_DATASOURCE_URL="\$DATABASE_URL"
ENV SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.postgresql.Driver
ENV SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT=org.hibernate.dialect.PostgreSQLDialect
ENV SPRING_JPA_HIBERNATE_DDL_AUTO=update
ENV SERVER_PORT="\$PORT"

ENTRYPOINT ["java", "-jar", "app.jar"]
