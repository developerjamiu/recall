# ─── Build stage ──────────────────────────────────────────────────────────────
FROM dart:stable AS builder

WORKDIR /app

# Copy workspace manifest and only the packages this service needs
COPY pubspec.yaml .
COPY packages/common ./packages/common
COPY packages/recall_data ./packages/recall_data
COPY apps/shelf_backend ./apps/shelf_backend

# Remove workspace members we're not building — dart pub get requires every
# listed member to exist, and apps/frontend needs the Flutter SDK
RUN sed -i '/apps\/frontend/d; /apps\/backend$/d' pubspec.yaml

# Resolve workspace dependencies
RUN dart pub get

# Compile to a self-contained native executable
WORKDIR /app/apps/shelf_backend
RUN dart compile exe bin/server.dart -o /app/server

# ─── Runtime stage ────────────────────────────────────────────────────────────
FROM debian:bookworm-slim

# ca-certificates is required for TLS connections to PostgreSQL and OAuth providers
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/server /server

EXPOSE 8080

CMD ["/server"]
