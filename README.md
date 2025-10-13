# Eclipse Temurin Docker 镜像

这个仓库包含了基于 Eclipse Temurin 的定制 Docker 镜像构建文件。

## 概述

本项目提供了两个不同架构的 Dockerfile：

- `Dockerfile` - 基于 Alpine Linux 的 x86_64 架构镜像
- `Dockerfile-arm32v7` - 基于 Ubuntu Noble 的 ARM32v7 架构镜像

## 镜像特性

### Dockerfile (x86_64/Alpine)
- **基础镜像**: `eclipse-temurin:25-jdk-alpine`
- **运行时**: Alpine Linux
- **Java 版本**: JDK 25
- **特点**:
  - 使用 `jlink` 创建自定义 JRE，只包含必要的模块
  - 包含字体支持 (fontconfig, ttf-dejavu)
  - 包含 CA 证书管理工具
  - 支持多语言环境 (musl-locales)
  - 包含时区数据
  - 优化的 JVM 参数

### Dockerfile-arm32v7 (ARM32v7/Ubuntu)
- **基础镜像**: `arm32v7/eclipse-temurin:17-jre-noble`
- **运行时**: Ubuntu Noble
- **Java 版本**: JRE 17
- **特点**:
  - 针对 ARM32v7 架构优化
  - 包含 `su-exec` 工具用于安全执行
  - 包含网络工具 (iputils-ping)
  - 优化的 JVM 参数

## 环境变量

两个镜像都设置了以下环境变量：

- `JAVA_TOOL_OPTIONS`: JVM 优化参数
- `JAVA_HOME`: Java 安装路径
- `PATH`: 包含 Java 二进制文件路径
- `PUID/PGID`: 用户和组 ID (默认为 0)
- `UMASK`: 文件权限掩码 (022)
- `TZ`: 时区设置 (Asia/Shanghai)

## 构建镜像

### 构建 x86_64 镜像
```bash
docker build -t eclipse-temurin-custom:25-alpine -f Dockerfile .
```

### 构建 ARM32v7 镜像
```bash
docker build -t eclipse-temurin-custom:17-arm32v7 -f Dockerfile-arm32v7 .
```

## 使用示例

### 运行 Java 应用
```bash
# 使用 x86_64 镜像
docker run -it --rm eclipse-temurin-custom:25-alpine java -version

# 使用 ARM32v7 镜像
docker run -it --rm eclipse-temurin-custom:17-arm32v7 java -version
```

### 挂载应用代码
```bash
docker run -it --rm \
  -v /path/to/your/app:/app \
  -w /app \
  eclipse-temurin-custom:25-alpine \
  java -jar your-app.jar
```

## 技术细节

### JRE 模块 (x86_64 镜像)
x86_64 镜像使用 `jlink` 创建的自定义 JRE 包含以下模块：
- `java.base` - 核心 Java 类库
- `java.desktop` - 桌面应用支持
- `java.logging` - 日志框架
- `java.naming` - JNDI 命名服务
- `java.net.http` - HTTP 客户端
- `java.sql` - 数据库连接
- `java.sql.rowset` - 数据库行集
- `java.xml` - XML 处理
- `jdk.httpserver` - HTTP 服务器
- `jdk.naming.dns` - DNS 命名服务
- `jdk.unsupported` - 非标准 API

### 优化特性
- **压缩**: 使用 zip-6 压缩级别
- **调试信息**: 已剥离调试信息以减小镜像大小
- **文档**: 已移除头文件和手册页
- **字体支持**: 包含 DejaVu 字体以支持图形应用
- **证书管理**: 自动同步 CA 证书

## 许可证

本项目基于 Eclipse Temurin 项目，遵循相应的开源许可证。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这些 Docker 镜像。

## 相关链接

- [Eclipse Temurin](https://adoptium.net/)
- [Docker Hub - Eclipse Temurin](https://hub.docker.com/_/eclipse-temurin)
- [Alpine Linux](https://alpinelinux.org/)
- [Ubuntu](https://ubuntu.com/)
