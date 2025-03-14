FROM maven:3.9.9-amazoncorretto-17-al2023 AS build
WORKDIR /build
COPY . /build
RUN mvn install 

FROM openjdk:24-ea-17-oraclelinux9
WORKDIR /app
COPY --from=build /build/target/*.jar app.jar
EXPOSE 80
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=80"]
