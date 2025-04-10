# Use official OpenJDK image
# FROM openjdk:11-jdk-slim
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy source code
# COPY . .
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Build the application using Maven
# RUN apt-get update && apt-get install -y maven && \
#     mvn clean package && \
#     mv target/*.jar app.jar && \
#     apt-get remove -y maven && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
