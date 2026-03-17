# ─── Build stage ──────────────────────────────────────────────────────────────
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Copy workspace manifest and only the packages this service needs
COPY pubspec.yaml .
COPY packages/common ./packages/common
COPY apps/frontend ./apps/frontend

# Remove workspace members the frontend doesn't need.
# dart pub get requires every listed member to exist; the backends and
# recall_data are server-only and not required for the Flutter web build.
RUN sed -i '/apps\/backend$/d; /apps\/shelf_backend/d; /packages\/recall_data/d' pubspec.yaml

# Resolve workspace dependencies
RUN flutter pub get

# API_URL is baked in at compile time via --dart-define (String.fromEnvironment)
# Pass it as a Docker build arg: docker build --build-arg API_URL=https://...
ARG API_URL=http://localhost:8080

# Build the Flutter web app
WORKDIR /app/apps/frontend
RUN flutter build web --release --dart-define=API_URL=$API_URL

# ─── Runtime stage ────────────────────────────────────────────────────────────
FROM nginx:alpine

COPY --from=builder /app/apps/frontend/build/web /usr/share/nginx/html

# Handle Flutter's client-side routing — all paths serve index.html
# Listen on 8080 to match Railway's expected PORT
RUN printf 'server {\n\
    listen 8080;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
