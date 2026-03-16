# Recall

A full-stack **Dart on the Server** showcase — a notes application demonstrating production-grade Dart backend development with dual server implementations, PostgreSQL, OAuth 2.0 with refresh token rotation, and a Flutter Web frontend.

## Project Purpose

Recall exists to demonstrate that Dart is a viable, productive choice for full-stack web development:

- **Dual Backend Comparison**: Side-by-side [Dart Frog](https://dartfrog.vgv.dev/) and [Shelf](https://pub.dev/packages/shelf) implementations sharing the same data layer
- **Production Patterns**: JWT auth with refresh token rotation, rate limiting, abstract repository pattern, proper input validation
- **Educational Resource**: Companion project for Dart backend workshops, conference talks, and written guides

## Architecture

```
recall/
├── apps/
│   ├── backend/            # Dart Frog API server (port 8080)
│   ├── shelf_backend/      # Shelf API server (port 8081)
│   └── frontend/           # Flutter Web application
├── packages/
│   ├── common/             # Shared models and DTOs
│   └── recall_data/        # Abstract repository interfaces
└── docker-compose.yml      # PostgreSQL for local development
```

Both backends expose identical REST APIs and share the same abstract repository interfaces from `recall_data`, making it easy to compare the two frameworks.

### Tech Stack

**Backends (Dart Frog & Shelf):**
- [Jao ORM](https://pub.dev/packages/jao) — Django-inspired ORM for Dart
- [PostgreSQL 16](https://www.postgresql.org/) — Production database
- OAuth 2.0 (Google & GitHub) with refresh token rotation
- JWT authentication (15-min access tokens, 7-day refresh tokens)
- Rate limiting on auth endpoints (10 req/min per IP)

**Frontend:**
- [Flutter](https://flutter.dev/) for Web
- [Riverpod 3](https://riverpod.dev/) — State management
- [Go Router](https://pub.dev/packages/go_router) — Navigation with deep linking (`/notes/:id`)
- [Flutter Quill](https://pub.dev/packages/flutter_quill) — Rich text editor with auto-save

**Shared Packages:**
- [Dart Mappable](https://pub.dev/packages/dart_mappable) — Serialization code generation
- [Luthor](https://pub.dev/packages/luthor) — Schema validation

## Quick Start

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) ^3.9.0
- [Flutter SDK](https://flutter.dev/docs/get-started/install) ^3.9.0
- [Docker](https://docs.docker.com/get-docker/) (for PostgreSQL)

### 1. Clone and Install

```bash
git clone https://github.com/developerjamiu/recall.git
cd recall
dart pub get   # Pub workspaces resolves all packages
```

### 2. Start PostgreSQL

```bash
docker compose up -d
```

This starts PostgreSQL 16 on port 5432 with database `recall_dev`.

### 3. Set Up OAuth Applications

#### GitHub OAuth

1. Go to [GitHub Developer Settings](https://github.com/settings/developers) > **OAuth Apps** > **New OAuth App**
2. Set **Authorization callback URL** to `http://localhost:8080/auth/github/callback`
3. Copy your **Client ID** and **Client Secret**

#### Google OAuth

1. Go to [Google Cloud Console](https://console.cloud.google.com/) > **APIs & Services** > **Credentials**
2. Create an **OAuth client ID** (Web application)
3. Add **Authorized redirect URI**: `http://localhost:8080/auth/google/callback`
4. Copy your **Client ID** and **Client Secret**

### 4. Configure Environment

Copy and fill in the env files for your chosen backend:

```bash
cp apps/backend/env.example apps/backend/.env
# or
cp apps/shelf_backend/env.example apps/shelf_backend/.env
```

```env
BASE_URL=http://localhost:8080
CLIENT_URL=http://localhost:3000
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
JWT_SECRET=your_jwt_secret_key
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=recall_dev
DATABASE_USER=recall
DATABASE_PASSWORD=recall
```

### 5. Run Migrations

```bash
cd apps/backend   # or apps/shelf_backend
dart run build_runner build   # Generate Jao model code
dart run bin/migrate.dart     # Create database tables
```

### 6. Run the Backend

**Dart Frog** (port 8080):
```bash
cd apps/backend
dart_frog dev
```

**Shelf** (port 8081):
```bash
cd apps/shelf_backend
dart run bin/server.dart
```

### 7. Run the Frontend

```bash
cd apps/frontend
flutter run -d web-server --web-port 3000
```

## API Endpoints

Both backends expose identical routes:

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| `GET` | `/` | No | Health check |
| `GET` | `/auth/google` | No | Get Google OAuth URL |
| `GET` | `/auth/google/callback` | No | Google OAuth callback |
| `GET` | `/auth/github` | No | Get GitHub OAuth URL |
| `GET` | `/auth/github/callback` | No | GitHub OAuth callback |
| `POST` | `/auth/refresh` | No | Refresh access token |
| `POST` | `/auth/logout` | No | Revoke refresh token |
| `GET` | `/api/me` | Yes | Get current user |
| `GET` | `/api/notes` | Yes | List all notes |
| `POST` | `/api/notes` | Yes | Create a note |
| `GET` | `/api/notes/:id` | Yes | Get a note |
| `PATCH` | `/api/notes/:id` | Yes | Update a note |
| `DELETE` | `/api/notes/:id` | Yes | Delete a note |

## Features

- **OAuth 2.0 Authentication** with Google and GitHub providers
- **Refresh Token Rotation** — short-lived access tokens (15 min) with automatic refresh
- **Rate Limiting** on auth endpoints (10 requests/min per IP)
- **Rich Text Editor** with toolbar, formatting, and auto-expanding height
- **Auto-Save** with 2-second debounce and visual status indicator
- **Deep Linking** — navigate directly to `/notes/:id`
- **Keyboard Shortcuts** — `Ctrl/Cmd+N` new note, `Ctrl/Cmd+S` save, `Esc` deselect
- **Skeleton Loaders** for loading states
- **Error States** with retry buttons
- **Dark/Light Theme** toggle
- **Responsive Design** — desktop and mobile layouts

## Testing

```bash
# Backend tests
cd apps/backend && dart test

# Frontend tests
cd apps/frontend && flutter test

# Common package tests
cd packages/common && dart test
```

## Educational Resources

This project is a companion to various Dart backend educational materials:

- [Dart Backend Handbook](https://github.com/developerjamiu/dart-backend-handbook) — Comprehensive guide to building backends with Dart
- [Articles on Medium](https://medium.com/@developerjamiu) and [Hashnode](https://developerjamiu.hashnode.dev/)
- Conference talks and workshops at [FlutterBytes Conference](https://www.flutterbytesconf.com/) and other events

## Documentation

- [Backend (Dart Frog)](./apps/backend/README.md)
- [Backend (Shelf)](./apps/shelf_backend/README.md)
- [Frontend](./apps/frontend/README.md)
- [Common Package](./packages/common/README.md)
- [Data Layer](./packages/recall_data/README.md)

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](./CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Backend frameworks: [Dart Frog](https://dartfrog.vgv.dev/) and [Shelf](https://pub.dev/packages/shelf)
- ORM: [Jao](https://pub.dev/packages/jao) by [Daniil Shumko](https://github.com/WiseVladlen)
- UI: [Flutter](https://flutter.dev/)

---

**Recall** — Built by [Developer Jamiu](https://github.com/developerjamiu)
