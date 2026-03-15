# Recall Backend (Dart Frog)

A [Dart Frog](https://dartfrog.vgv.dev/) API server that powers the Recall notes application. Uses file-based routing, PostgreSQL via [Jao ORM](https://pub.dev/packages/jao), OAuth 2.0 authentication, JWT-based authorization, and refresh token rotation.

## Prerequisites

- [Dart SDK](https://dart.dev/get-dart) ^3.9.2
- [Dart Frog CLI](https://dartfrog.vgv.dev/docs/getting-started/installation)
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
# Development (hot reload)
dart_frog dev

# Production
dart_frog build
dart run build/bin/server.dart
```

The API runs on `http://localhost:8080` by default.

## Project Structure

```
apps/backend/
├── lib/
│   ├── handlers/
│   │   ├── auth_handler.dart       # OAuth flow, refresh, logout, current user
│   │   └── notes_handler.dart      # Notes CRUD operations
│   ├── middleware/
│   │   └── rate_limiter.dart       # In-memory rate limiting (10 req/min per IP)
│   └── utils/
│       └── app_response.dart       # Standardized JSON response helpers
├── routes/
│   ├── _middleware.dart             # Root: provides repositories, services, handlers
│   ├── index.dart                   # GET / health check
│   ├── auth/
│   │   ├── _middleware.dart         # Applies rate limiter to auth routes
│   │   ├── google/
│   │   │   ├── index.dart           # GET /auth/google
│   │   │   └── callback/index.dart  # GET /auth/google/callback
│   │   ├── github/
│   │   │   ├── index.dart           # GET /auth/github
│   │   │   └── callback/index.dart  # GET /auth/github/callback
│   │   ├── refresh/index.dart       # POST /auth/refresh
│   │   └── logout/index.dart        # POST /auth/logout
│   └── api/
│       ├── _middleware.dart         # JWT bearer authentication
│       ├── me/index.dart            # GET /api/me
│       └── notes/
│           ├── _middleware.dart     # Provides NotesHandler
│           ├── index.dart           # GET, POST /api/notes
│           └── [id].dart            # GET, PATCH, DELETE /api/notes/:id
└── test/
    └── routes/
        └── index_test.dart
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
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
| `GET` | `/api/notes/:id` | Returns a specific note |
| `PATCH` | `/api/notes/:id` | Updates a note's title and/or content |
| `DELETE` | `/api/notes/:id` | Deletes a note |

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

## OAuth Setup

### GitHub

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Create a new OAuth App
3. Set **Authorization callback URL** to `{BASE_URL}/auth/github/callback`
4. Copy the Client ID and Client Secret to `.env`

### Google

1. Go to [Google Cloud Console](https://console.cloud.google.com/) > **APIs & Services** > **Credentials**
2. Create OAuth 2.0 credentials (Web application)
3. Add `{BASE_URL}/auth/google/callback` to **Authorized redirect URIs**
4. Copy the Client ID and Client Secret to `.env`

## Database

The backend uses [Jao ORM](https://pub.dev/packages/jao) with PostgreSQL. Models and repositories live in the shared `packages/recall_data/` package.

### Tables

- **app_users** — id, email, firstName, lastName, provider, providerId, avatarUrl, timestamps
- **app_notes** — id, userId (FK), title, content, timestamps
- **refresh_token_entrys** — id, userId (FK), tokenHash, expiresAt, revokedAt, timestamps

### Running Migrations

```bash
cd packages/recall_data
dart run bin/migrate.dart
```

## Testing

```bash
dart test
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `dart_frog` | Web framework with file-based routing |
| `dart_frog_auth` | Bearer token authentication middleware |
| `jao` | ORM for PostgreSQL |
| `recall_data` | Shared repositories, services, and models |
| `common` | Shared data classes and utilities |
| `shelf_cors_headers` | CORS middleware |
| `crypto` | Token hashing |
| `http` | HTTP client for OAuth provider APIs |

## Troubleshooting

**Port already in use:**
```bash
lsof -ti:8080 | xargs kill -9
```

**OAuth callback fails:** Verify your callback URLs match exactly — `{BASE_URL}/auth/google/callback` and `{BASE_URL}/auth/github/callback`.

**Database connection refused:** Ensure PostgreSQL is running with `docker compose up -d` and your `.env` credentials match the `docker-compose.yml` config.
