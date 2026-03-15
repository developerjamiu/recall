# Recall Backend (Shelf)

A pure [Shelf](https://pub.dev/packages/shelf) + [shelf_router](https://pub.dev/packages/shelf_router) API server that provides the same REST API as the Dart Frog backend. Demonstrates how to build a production-grade Dart server with explicit routing, middleware pipelines, and constructor-based dependency injection.

## Prerequisites

- [Dart SDK](https://dart.dev/get-dart) ^3.9.2
- [Docker](https://docs.docker.com/get-docker/) (for PostgreSQL)

## Getting Started

### 1. Start PostgreSQL

From the project root:

```bash
docker compose up -d
```

This starts a PostgreSQL 16 instance on port 5432 with database `recall_dev`.

### 2. Set Up Environment Variables

```bash
cp env.example .env
```

Fill in your OAuth credentials and JWT secret. See [env.example](env.example) for all required variables.

### 3. Run Migrations

From `packages/recall_data/`:

```bash
dart run bin/migrate.dart
```

### 4. Run the Server

```bash
dart run bin/server.dart
```

The API runs on `http://localhost:8080` by default (configurable via `PORT` env var).

## Project Structure

```
apps/shelf_backend/
├── bin/
│   └── server.dart                  # Entry point: wires dependencies, starts server
├── lib/
│   ├── handlers/
│   │   ├── auth_handler.dart        # OAuth flow, refresh, logout, current user
│   │   └── notes_handler.dart       # Notes CRUD operations
│   ├── middleware/
│   │   ├── auth_middleware.dart      # JWT bearer token validation
│   │   └── rate_limiter.dart        # In-memory rate limiting (10 req/min per IP)
│   ├── router.dart                  # All route definitions and middleware pipelines
│   └── utils/
│       └── app_response.dart        # Standardized JSON response helpers
├── env.example
├── pubspec.yaml
└── analysis_options.yaml
```

## How It Works

### Entry Point (`bin/server.dart`)

The server initializes all dependencies explicitly — no service locator or file-based DI:

```dart
final authHandler = AuthHandler(
  userRepository: userRepository,
  oauthService: oauthService,
  jwtService: jwtService,
  refreshTokenRepository: refreshTokenRepository,
);
```

### Routing (`lib/router.dart`)

Routes are defined using `shelf_router` with middleware applied via `Pipeline`:

- **`/auth/*`** — Rate-limited auth routes (OAuth, refresh, logout)
- **`/api/*`** — JWT-protected routes (user profile, notes CRUD)

### Middleware Pipeline

```
Request → logRequests() → corsHeaders() → router
                                            ├── /auth/* → rateLimiter() → authRouter
                                            └── /api/*  → authMiddleware() → apiRouter
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `PORT` | Server port (default: `8080`) | No |
| `BASE_URL` | Backend server URL (e.g. `http://localhost:8080`) | Yes |
| `CLIENT_URL` | Frontend URL for OAuth redirects (e.g. `http://localhost:3000`) | Yes |
| `DATABASE_HOST` | PostgreSQL host | Yes |
| `DATABASE_PORT` | PostgreSQL port | Yes |
| `DATABASE_NAME` | PostgreSQL database name | Yes |
| `DATABASE_USER` | PostgreSQL username | Yes |
| `DATABASE_PASSWORD` | PostgreSQL password | Yes |
| `GITHUB_CLIENT_ID` | GitHub OAuth app client ID | Yes |
| `GITHUB_CLIENT_SECRET` | GitHub OAuth app client secret | Yes |
| `GOOGLE_CLIENT_ID` | Google OAuth client ID | Yes |
| `GOOGLE_CLIENT_SECRET` | Google OAuth client secret | Yes |
| `JWT_SECRET` | Secret key for signing JWTs | Yes |

## API Routes

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/auth/google` | Returns Google OAuth consent URL |
| `GET` | `/auth/google/callback` | Handles Google OAuth callback, issues tokens, redirects to client |
| `GET` | `/auth/github` | Returns GitHub OAuth authorization URL |
| `GET` | `/auth/github/callback` | Handles GitHub OAuth callback, issues tokens, redirects to client |
| `POST` | `/auth/refresh` | Exchanges a refresh token for new access + refresh tokens |
| `POST` | `/auth/logout` | Revokes the provided refresh token |

### Protected Routes (require `Authorization: Bearer <token>`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/me` | Returns the authenticated user's profile |
| `GET` | `/api/notes` | Lists all notes for the authenticated user |
| `POST` | `/api/notes` | Creates a new note |
| `GET` | `/api/notes/<id>` | Returns a specific note |
| `PATCH` | `/api/notes/<id>` | Updates a note's title and/or content |
| `DELETE` | `/api/notes/<id>` | Deletes a note |

### Example Requests

```bash
# Health check
curl http://localhost:8080/

# Create a note
curl -X POST http://localhost:8080/api/notes \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title": "My Note", "content": "Hello world"}'

# List notes
curl http://localhost:8080/api/notes \
  -H "Authorization: Bearer YOUR_TOKEN"

# Update a note
curl -X PATCH http://localhost:8080/api/notes/NOTE_ID \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title": "Updated Title"}'

# Delete a note
curl -X DELETE http://localhost:8080/api/notes/NOTE_ID \
  -H "Authorization: Bearer YOUR_TOKEN"

# Refresh tokens
curl -X POST http://localhost:8080/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{"refreshToken": "YOUR_REFRESH_TOKEN"}'

# Logout
curl -X POST http://localhost:8080/auth/logout \
  -H "Content-Type: application/json" \
  -d '{"refreshToken": "YOUR_REFRESH_TOKEN"}'
```

## Dart Frog vs Shelf Comparison

Both backends share the same `recall_data` package (repositories, services, models) and expose identical APIs. The differences are architectural:

| Aspect | Dart Frog | Shelf |
|--------|-----------|-------|
| Routing | File-based (`routes/` directory) | Explicit (`shelf_router` in code) |
| Middleware | `_middleware.dart` convention files | `Pipeline().addMiddleware()` chains |
| Dependency injection | `provider<T>()` + `context.read<T>()` | Constructor injection |
| Auth middleware | `dart_frog_auth` package | Custom middleware with request context |
| Request body | `request.body()` / `request.json()` | `request.readAsString()` + `jsonDecode` |
| Hot reload | Built-in (`dart_frog dev`) | Manual restart |

## Database

Both backends use the same [Jao ORM](https://pub.dev/packages/jao) models and PostgreSQL database from `packages/recall_data/`. See the [recall_data README](../../packages/recall_data/README.md) for schema details.

## Dependencies

| Package | Purpose |
|---------|---------|
| `shelf` | HTTP server foundation |
| `shelf_router` | Declarative URL routing |
| `shelf_cors_headers` | CORS middleware |
| `jao` | ORM for PostgreSQL |
| `recall_data` | Shared repositories, services, and models |
| `common` | Shared data classes and utilities |
| `crypto` | Token hashing |
| `http` | HTTP client for OAuth provider APIs |

## Troubleshooting

**Port already in use:**
```bash
lsof -ti:8080 | xargs kill -9
```

**OAuth callback fails:** Verify your callback URLs match exactly — `{BASE_URL}/auth/google/callback` and `{BASE_URL}/auth/github/callback`.

**Database connection refused:** Ensure PostgreSQL is running with `docker compose up -d` and your `.env` credentials match the `docker-compose.yml` config.
