# Multi-stage production Dockerfile for Serverpod on GCP Cloud Run
# Build from repository root with:
#   docker build -f server/chat_server/Dockerfile -t chat-server:latest .

FROM dart:stable AS build

WORKDIR /app

# Copy root workspace and server manifests for layer caching
COPY pubspec.yaml pubspec.lock melos.yaml ./
COPY server/chat_server/pubspec.yaml server/chat_server/
COPY server/chat_client/pubspec.yaml server/chat_client/
COPY packages/domain_models/pubspec.yaml packages/domain_models/

# Resolve dependencies across the workspace
RUN dart pub get

# Copy source code
COPY server/chat_server/ server/chat_server/
COPY server/chat_client/ server/chat_client/
COPY packages/domain_models/ packages/domain_models/

# Compile the native Serverpod server binary
WORKDIR /app/server/chat_server
RUN dart compile exe bin/main.dart -o bin/server

# Minimal production runtime stage
FROM alpine:3.20

RUN apk add --no-cache ca-certificates libstdc++ libc6-compat dumb-init

WORKDIR /app

ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies and compiled binary
COPY --from=build /runtime/ /
COPY --from=build /app/server/chat_server/bin/server bin/server
COPY --from=build /app/server/chat_server/config/ config/
COPY --from=build /app/server/chat_server/web/ web/
COPY --from=build /app/server/chat_server/migrations/ migrations/
COPY --from=build /app/server/chat_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Cloud Run defaults to port 8080
EXPOSE 8080 8081 8082

# dumb-init handles PID 1 signal forwarding for graceful shutdown
ENTRYPOINT ["/usr/bin/dumb-init", "--", "./bin/server"]
CMD ["--mode=production", "--server-id=default", "--logging=normal", "--role=monolith"]
