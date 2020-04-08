FROM openjdk:8-alpine

COPY target/*.jar /root/demo.jar

ENTRYPOINT java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -jar /root/demo.jar