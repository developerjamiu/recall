# Recall — Shelf Backend

The Shelf backend implementation of the Recall API. This is a pure `shelf` + `shelf_router` server that exposes the same REST API as the Dart Frog backend, demonstrating how to build a production-grade API with explicit routing and middleware pipelines.

## Running

```bash
# Start PostgreSQL
docker compose -f ../../docker-compose.yml up -d

# Generate Jao model code
dart run build_runner build

# Run migrations
jao migrate

# Start the server
dart run bin/server.dart
```

The server starts on port **8081** by default.

## Architecture

```
lib/
├── config/
│   ├── database.dart         # Jao + PostgreSQL config
│   └── environment.dart      # Environment variable access
├── handlers/
│   ├── auth_handler.dart     # OAuth, refresh, logout
│   └── notes_handler.dart    # CRUD notes
├── middleware/
│   ├── auth_middleware.dart   # JWT bearer validation
│   └── rate_limiter.dart     # In-memory rate limiting
├── models/                   # Jao ORM model definitions
├── repositories/             # Jao repository implementations
├── services/
│   ├── jwt_service.dart      # JWT creation + validation
│   └── oauth_service.dart    # Google + GitHub OAuth
├── router.dart               # Route definitions + middleware pipelines
└── utils/                    # Response helpers
```

## Key Differences from Dart Frog

| Aspect | Dart Frog | Shelf |
|--------|-----------|-------|
| Routing | File-based (`routes/`) | Explicit (`shelf_router`) |
| Middleware | `_middleware.dart` files | `Pipeline().addMiddleware()` |
| DI | `provider<T>()` + `context.read<T>()` | Constructor injection |
| Request body | `context.request.body()` | `request.readAsString()` |
| Query params | `request.uri.queryParameters` | `request.requestedUri.queryParameters` |

Both backends share the same abstract repository interfaces from `packages/recall_data/`.
