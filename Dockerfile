# Stage 1: Build the application
FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY . /app
RUN mvn clean package -DskipTests

# Stage 2: Create the final image with only the JAR file
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=build /app/target/jenboot-0.0.1-SNAPSHOT.jar /app/jenboot.jar
EXPOSE 6060

CMD ["java", "-jar", "jenboot.jar"]
