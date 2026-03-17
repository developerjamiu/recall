# ─── Build stage ──────────────────────────────────────────────────────────────
FROM dart:stable AS builder

WORKDIR /app

# Copy workspace manifest and only the packages this service needs
COPY pubspec.yaml .
COPY packages/common ./packages/common
COPY packages/recall_data ./packages/recall_data
COPY apps/backend ./apps/backend

# Remove workspace members we're not building — dart pub get requires every
# listed member to exist, and apps/frontend needs the Flutter SDK
RUN sed -i '/apps\/frontend/d; /apps\/shelf_backend/d' pubspec.yaml

# Activate Dart Frog CLI for the production build step
RUN dart pub global activate dart_frog_cli
ENV PATH="/root/.pub-cache/bin:$PATH"

# Resolve workspace dependencies
RUN dart pub get

# Generate the production server (code-generates route handlers into build/)
WORKDIR /app/apps/backend
RUN dart_frog build

# Compile the generated server to a native executable.
# Run from the workspace root so dart compile can resolve the workspace packages
# via the .dart_tool/package_config.json set up by dart pub get above.
RUN dart compile exe build/bin/server.dart -o /app/server

# ─── Runtime stage ────────────────────────────────────────────────────────────
FROM debian:bookworm-slim

# ca-certificates is required for TLS connections to PostgreSQL and OAuth providers
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/server /server

EXPOSE 8080

CMD ["/server"]
