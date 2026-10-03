# Multi-stage production Dockerfile for Serverpod on GCP Cloud Run
# Build from repository root with:
#   docker build -f server/chat_server/Dockerfile -t chat-server:latest .

FROM dart:stable AS build

# Install build tools required for native C assets compilation (sqlite3, argon2)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy server project files
COPY server/chat_server/ ./

# Strip out workspace resolution so the server builds as a self-contained Dart package
RUN sed -i '/resolution: workspace/d' pubspec.yaml

# Resolve dependencies
RUN dart pub get

# Compile native Serverpod CLI bundle (includes binary and dynamic native libraries)
RUN dart build cli -t bin/main.dart -o build/cli

# Production runtime stage based on debian:bookworm-slim (guarantees glibc compatibility)
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    dumb-init \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime bundle (contains bin/main and lib/ with native assets)
COPY --from=build /app/build/cli/bundle/ /app/
# Symlink bin/server to bin/main for compatibility
RUN ln -s /app/bin/main /app/bin/server

# Copy server assets, configuration, migrations, and protocols
COPY --from=build /app/config/ /app/config/
COPY --from=build /app/web/ /app/web/
COPY --from=build /app/migrations/ /app/migrations/
COPY --from=build /app/lib/src/generated/protocol.yaml /app/lib/src/generated/protocol.yaml

# Cloud Run defaults to port 8080
EXPOSE 8080 8081 8082

# dumb-init handles PID 1 signal forwarding for graceful shutdown
ENTRYPOINT ["/usr/bin/dumb-init", "--", "./bin/server"]
CMD ["--mode=production", "--server-id=default", "--logging=normal", "--role=monolith"]
