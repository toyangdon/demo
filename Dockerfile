FROM maven:3-jdk-8-alpine as builder

WORKDIR /root
COPY src ./
COPY pom.xml ./

RUN mvn install
RUN mv target/*.jar target/demo.jar

FROM openjdk:8-alpine
COPY --from=builder /root/target/demo.jar /root/demo.jar

ENTRYPOINT java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -jar demo.jar ]