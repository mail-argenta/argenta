# Build stage
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copy pom first to leverage caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the project
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17.0.1-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar demo.jar
ENTRYPOINT ["java", "-jar", "demo.jar"]
