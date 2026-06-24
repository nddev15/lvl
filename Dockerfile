# ── Lavalink v4 – Render.com Dockerfile ──────────────────────────────────────
FROM eclipse-temurin:17-jre-alpine

WORKDIR /lavalink

# Tải Lavalink.jar từ GitHub releases (tránh commit file 100MB vào git)
ARG LAVALINK_VERSION=4.0.8
RUN wget -q \
    "https://github.com/lavalink-devs/Lavalink/releases/download/${LAVALINK_VERSION}/Lavalink.jar" \
    -O Lavalink.jar

# Copy config
COPY application.yml application.yml

# Tạo thư mục cần thiết
RUN mkdir -p logs plugins

# Render inject $PORT → Lavalink đọc qua SERVER_PORT
ENV SERVER_PORT=2333

# Dùng shell form để $PORT được expand đúng lúc runtime
EXPOSE ${SERVER_PORT}

# Chạy Lavalink với memory limit phù hợp free plan (512MB RAM)
# Render inject $PORT vào env, application.yml map nó sang SERVER_PORT
CMD sh -c "java -Xmx400m -jar Lavalink.jar --server.port=${PORT:-2333}"
