FROM registry.cn-hangzhou.aliyuncs.com/openjdk:8-alpine

COPY target/*.jar /root/demo.jar

ENTRYPOINT java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -jar /root/demo.jar