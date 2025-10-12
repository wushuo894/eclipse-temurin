FROM eclipse-temurin:25-jdk-alpine AS jre-builder

# 使用 jlink 创建一个只包含必要模块的自定义 JRE
RUN $JAVA_HOME/bin/jlink \
    --add-modules java.base,java.desktop,java.logging,java.naming,java.net.http,java.sql,java.sql.rowset,java.xml,jdk.httpserver,jdk.naming.dns,jdk.unsupported \
    --strip-debug \
    --no-header-files \
    --no-man-pages \
    --compress=zip-6 \
    --output /openjdk

FROM alpine:latest

COPY --from=jre-builder /openjdk /opt/java/openjdk

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN set -eux; \
    apk add --no-cache ca-certificates su-exec bash; \
    rm -rf /var/cache/apk/*; \
    chmod -R 777 /opt/java/openjdk

ENV JAVA_TOOL_OPTIONS="-XX:+IgnoreUnrecognizedVMOptions -XX:+IdleTuningGcOnIdle"
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="$JAVA_HOME/bin:$PATH"
ENV PUID=0 PGID=0 UMASK=022 TZ=Asia/Shanghai
