# recall_data

Abstract data layer interfaces for the Recall application. This package defines the repository contracts that both backend implementations (Dart Frog and Shelf) implement.

## Interfaces

### UserRepository

```dart
abstract class UserRepository {
  Future<User> createUser(User user);
  Future<User?> getUserByEmail(String email);
  Future<User?> getUserById(String id);
}
```

### NotesRepository

```dart
abstract class NotesRepository {
  Future<Note> addNote(String userId, CreateNoteParams params);
  Future<List<Note>> getAllNotes(String userId);
  Future<Note?> getNoteById(String id, String userId);
  Future<Note> updateNote(String id, String userId, UpdateNoteParams params);
  Future<void> deleteNote(String id, String userId);
}
```

### RefreshTokenRepository

```dart
abstract class RefreshTokenRepository {
  Future<void> storeRefreshToken({...});
  Future<String?> validateRefreshToken(String tokenHash);
  Future<void> revokeRefreshToken(String tokenHash);
  Future<void> revokeAllUserTokens(String userId);
}
```

## Usage

Add `recall_data` as a dependency and implement the interfaces with your chosen ORM/database. See `apps/backend/lib/repositories/` for Jao ORM implementations.
