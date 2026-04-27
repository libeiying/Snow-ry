FROM maven:3.9.9-eclipse-temurin-8 AS builder

WORKDIR /build

# 先复制 pom 以提升缓存命中率
COPY pom.xml ./
COPY Snow-admin/pom.xml Snow-admin/pom.xml
COPY Snow-framework/pom.xml Snow-framework/pom.xml
COPY Snow-business/pom.xml Snow-business/pom.xml
COPY Snow-system/pom.xml Snow-system/pom.xml
COPY Snow-quartz/pom.xml Snow-quartz/pom.xml
COPY Snow-generator/pom.xml Snow-generator/pom.xml
COPY Snow-common/pom.xml Snow-common/pom.xml

# 复制源码并打包（跳过测试，加快镜像构建）
COPY . .
RUN mvn -T 1C -DskipTests clean package


FROM eclipse-temurin:8-jre

WORKDIR /app

# 阿里云容器环境通常通过环境变量配置端口
ENV SERVER_PORT=8080
ENV JAVA_OPTS="-Xms512m -Xmx512m"

COPY --from=builder /build/Snow-admin/target/snow-admin.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Dserver.port=${SERVER_PORT} -jar /app/app.jar"]
