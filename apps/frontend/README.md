# Recall Frontend

A Flutter web application for Recall — a notes app showcasing full-stack Dart. Features responsive desktop/mobile layouts, OAuth authentication, a rich text editor (Flutter Quill), auto-save, keyboard shortcuts, and dark/light theme support.

## Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ^3.9.0
- A running backend (see [backend](../backend/README.md) or [shelf_backend](../shelf_backend/README.md))

## Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the Application

```bash
flutter run -d chrome --web-port 3000
```

The app runs at `http://localhost:3000` and connects to the backend at `http://localhost:8080` by default.

### 3. Custom API URL

```bash
flutter run -d chrome --web-port 3000 --dart-define=API_URL=https://your-api-url.com
```

### 4. Build for Production

```bash
flutter build web --dart-define=API_URL=https://your-api-url.com
```

## Project Structure

```
apps/frontend/
├── lib/
│   ├── main.dart                           # App entry point, MaterialApp.router setup
│   └── src/
│       ├── config/
│       │   └── environment.dart            # API_URL from dart-define
│       ├── models/
│       │   └── edit_note_params.dart       # Note editing parameters
│       ├── presentation/
│       │   ├── landing/                    # Landing / sign-in page
│       │   │   ├── pages/
│       │   │   │   └── landing_page.dart
│       │   │   └── widgets/
│       │   │       ├── desktop_landing_content.dart
│       │   │       ├── mobile_landing_content.dart
│       │   │       ├── landing_header.dart
│       │   │       ├── landing_hero.dart
│       │   │       ├── landing_footer.dart
│       │   │       ├── sign_in_card.dart
│       │   │       ├── terms_and_condition.dart
│       │   │       └── theme_toggle.dart
│       │   └── notes/                      # Notes management
│       │       ├── pages/
│       │       │   ├── note_page.dart              # Desktop/mobile router
│       │       │   ├── mobile_notes_list_page.dart # Mobile notes list
│       │       │   └── mobile_note_editor_page.dart # Mobile editor
│       │       └── widgets/
│       │           ├── desktop_note_content.dart    # Desktop split view
│       │           ├── note_sidebar.dart            # Desktop sidebar
│       │           ├── my_notes_section.dart        # Notes list in sidebar
│       │           ├── note_item.dart               # Desktop note list item
│       │           ├── mobile_note_item.dart        # Mobile note card
│       │           ├── mobile_empty_notes.dart      # Mobile empty state
│       │           ├── note_content_area.dart       # Editor container
│       │           ├── note_header.dart             # Title + actions bar
│       │           ├── title_section.dart           # Editable title field
│       │           ├── note_text_editor.dart        # Desktop Quill editor
│       │           ├── mobile_note_text_editor.dart # Mobile Quill editor
│       │           ├── toolbar_and_actions.dart     # Desktop toolbar + actions
│       │           ├── toolbar_button.dart          # Individual toolbar button
│       │           ├── action_buttons.dart          # Delete button
│       │           ├── save_status_indicator.dart   # Auto-save status display
│       │           ├── delete_confirmation_dialog.dart
│       │           ├── note_menu.dart               # Mobile bottom sheet menu
│       │           ├── notes_app_bar.dart           # Mobile app bar
│       │           ├── note_footer.dart             # Desktop footer
│       │           ├── account_dropdown.dart        # User account menu
│       │           └── large_button.dart            # New note button
│       ├── providers/
│       │   ├── auth_provider.dart          # Auth state (Riverpod)
│       │   ├── notes_provider.dart         # Notes list state
│       │   ├── selected_note_provider.dart # Currently selected/editing note
│       │   ├── note_mutations.dart         # Create, save, delete mutations
│       │   ├── auto_save_provider.dart     # 2-second debounced auto-save
│       │   └── theme_provider.dart         # Light/dark mode toggle
│       ├── services/
│       │   ├── auth_service.dart           # OAuth sign-in, token management
│       │   ├── authenticated_client.dart   # HTTP client with JWT + refresh
│       │   ├── notes_service.dart          # Notes API calls
│       │   ├── user_service.dart           # User profile API
│       │   └── theme_service.dart          # Theme persistence
│       └── shared/
│           ├── extensions/
│           │   └── responsivex.dart        # context.isMobile breakpoint
│           ├── router/
│           │   └── app_router.dart         # GoRouter config with all routes
│           ├── theme/
│           │   ├── app_colors.dart         # Brand color palette
│           │   ├── color_scheme.dart       # Light/dark color schemes
│           │   ├── text_theme.dart         # Satoshi font typography
│           │   └── theme_data.dart         # RecallTheme InheritedWidget
│           ├── utils/
│           │   ├── note_validation.dart    # Title/content validation
│           │   └── snackbar_utils.dart     # Success/error snackbar helpers
│           └── widgets/
│               ├── action_button.dart      # Styled text button
│               ├── app_icon.dart           # SVG icon factory
│               ├── error_state.dart        # Error + retry widget
│               ├── keyboard_shortcuts.dart # Ctrl+N, Ctrl+S, etc.
│               ├── loading_indicator.dart  # Centered spinner
│               ├── recall_logo.dart        # Brand logo widget
│               ├── skeleton_loader.dart    # Shimmer loading placeholders
│               ├── social_icon.dart        # Clickable social link
│               └── social_icons.dart       # Footer social links row
├── assets/
│   ├── fonts/                              # Satoshi font files (.otf)
│   └── icons/                              # SVG icons
├── web/
│   └── index.html                          # Web entry point
├── test/
│   └── widget_test.dart
└── pubspec.yaml
```

## Key Features

### Responsive Layout
- **Desktop** (>= 768px): Sidebar with notes list + editor split view
- **Mobile** (< 768px): Separate list and editor pages with slide transitions

### Auto-Save
Notes are automatically saved 2 seconds after the last keystroke. A status indicator shows "Saving..." / "Saved" / "Save failed".

### Rich Text Editor
Powered by [Flutter Quill](https://pub.dev/packages/flutter_quill) with formatting toolbar (bold, italic, underline, lists, quotes, undo/redo). Content is stored as Quill Delta JSON.

### Keyboard Shortcuts
- `Ctrl+N` — New note
- `Ctrl+S` — Save note
- `Escape` — Deselect note
- `Delete` — Delete note

### Authentication
OAuth 2.0 via Google or GitHub. Tokens are stored in native storage with automatic refresh on expiry.

### Routing
[GoRouter](https://pub.dev/packages/go_router) with deep linking:
- `/` — Landing page
- `/auth/callback` — OAuth callback
- `/notes` — Notes list/editor
- `/notes/edit` — Mobile editor (new note)
- `/notes/:id` — Deep link to specific note

## Design System

### Colors
- **Primary**: Bondi Blue `#00A3AF`
- **Secondary**: Skobeloff `#00727A`
- **Accent**: Atomic Tangerine `#FFA368`
- **Surfaces**: Neutral greys (no teal tint)

### Typography
[Satoshi](https://www.fontshare.com/fonts/satoshi) font family at weights 300–900.

### Theme
Access via `RecallTheme.of(context)`:
```dart
final colorScheme = RecallTheme.of(context).colorScheme;
final textTheme = RecallTheme.of(context).textTheme;
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Declarative routing with deep links |
| `flutter_quill` | Rich text editor |
| `flutter_svg` | SVG icon rendering |
| `http` | HTTP client |
| `native_storage` | Persistent token storage |
| `url_launcher` | Opening OAuth URLs |
| `timeago` | Relative date formatting |
| `dart_mappable` | JSON serialization |
| `common` | Shared data classes |

## Testing

```bash
flutter test
```

## Troubleshooting

**CORS errors:** Ensure the backend's CORS config allows `http://localhost:3000`.

**OAuth redirect fails:** The backend's `CLIENT_URL` must match the frontend's URL (e.g. `http://localhost:3000`).

**Build errors after changes:**
```bash
flutter clean && flutter pub get
```
