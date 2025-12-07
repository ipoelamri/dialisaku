# Dialisaku Flutter App - AI Coding Agent Instructions

## Project Overview

Dialisaku is a Flutter mobile application focused on user authentication and health/profile management. Currently in early development with bootstrap scaffolding. The app targets multiple platforms (Android, iOS, Web, Linux, Windows) and uses Riverpod for state management.

## Architecture & Key Patterns

### Directory Structure

- `lib/main.dart` - App entry point (currently using default Flutter demo structure)
- `lib/services/` - Business logic layer (e.g., `authentication_service.dart`)
- `lib/models/` - Data models and API contracts (e.g., `authenticaiton_models.dart` with Register/Login request/response)
- `lib/commons/` - Shared constants and utilities (`constant.dart` contains `AppColors` and `DrawerItem` widget)
- `lib/providers/` - Riverpod state management (currently empty, expand here)
- `lib/screens/` - UI screens (currently empty, scaffold screens here)
- `lib/widget/` - Reusable UI components (currently empty)
- `lib/utils/` - Helper utilities (currently empty)

### State Management

- **Framework**: Riverpod 3.0.3
- **Pattern**: Use Riverpod providers in `lib/providers/` for:
  - AuthenticationProvider for auth state (register/login logic)
  - User profile providers for health/user data
  - See `authenticaiton_models.dart` for existing RegisterRequest/LoginRequest/Response models
- **Key Models**: `RegisterRequest`, `LoginRequest`, `RegisterResponse`, `RegisterResponseData`

### Authentication Flow

- Base URL configured via `.env` file using `dotenv` package
- `AuthenticationService.baseUrl` reads from `dotenv.env['url_local']`
- API expected to return tokens (`access_token`, `token_type`) in responses
- Models include register fields: NIK, name, gender, age, education, address, initial weight

### UI/Design System

- **Colors** (in `constant.dart`):
  - Primary: `0xFF9A1D01` (Deep Red/Brown)
  - Secondary: `0xFFFC886E` (Salmon)
  - Third: `0xFF120677` (Dark Blue)
  - Fourth: `0xFFF5F5F5` (Off White)
  - Supporting: lightBlue, darkBlue, lightGrey, darkGrey
- **Standard Component**: `DrawerItem()` widget for navigation drawers
- **Theme**: Using Material Design with ColorScheme.fromSeed

### Development Conventions

- Use PascalCase for classes and widgets (Flutter standard)
- Use camelCase for variables and functions
- API request/response models use snake_case field names in JSON (e.g., `jenis_kelamin`, `bb_awal`)
- Always use `required` for constructor parameters; prefer named constructors with `factory` for JSON deserialization
- Use `toJson()` for request serialization, `fromJson()` factory for response parsing

## Build & Development Workflow

### Flutter Commands

```bash
# Run the app (uses hot reload)
flutter run

# Build release APK (Android)
flutter build apk --release

# Build iOS app
flutter build ios

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Get dependencies
flutter pub get
```

### Environment Setup

- **SDK**: Dart 3.7.0+
- **Dependencies**: flutter, riverpod 3.0.3, dotenv 4.2.0, cupertino_icons
- **Dev**: flutter_lints 5.0.0
- **.env file**: Configure `url_local` for API base URL (loaded by dotenv)

### Platform-Specific Notes

- **Android**: Configured in `android/app/build.gradle.kts` (Kotlin DSL)
- **iOS**: Runner app in `ios/Runner/` with Swift AppDelegate
- **Web/Linux/Windows**: Flutter supports out of box; ensure platform-specific assets configured

## Testing

- Test file location: `test/widget_test.dart`
- Framework: flutter_test (built-in)
- Convention: Create tests alongside feature implementation

## Key Files to Know

- `pubspec.yaml` - Dependencies and app metadata
- `analysis_options.yaml` - Lint rules (uses Flutter recommended lints)
- `.env` - Environment variables (API URLs, secrets)
- `lib/models/authenticaiton_models.dart` - Core API contracts
- `lib/commons/constant.dart` - Design tokens and reusable widgets

## Common Tasks

### Adding a New Screen

1. Create file in `lib/screens/new_screen.dart`
2. Build as StatelessWidget or StatefulWidget (prefer StatelessWidget with Riverpod)
3. Use color constants from `lib/commons/constant.dart`
4. Use `DrawerItem` for navigation options

### Adding API Integration

1. Extend `AuthenticationService` in `lib/services/authentication_service.dart`
2. Add request/response models to `lib/models/authenticaiton_models.dart`
3. Create Riverpod provider in `lib/providers/` to wrap service calls
4. Use `.env` for API configuration

### Updating State Management

1. Create providers in `lib/providers/` (organized by feature)
2. Use `riverpod` for `FutureProvider` (async), `StateNotifierProvider` (mutable state)
3. Reference models from `lib/models/`

## Notable Decisions & Gotchas

- **API Integration**: Base URL is dynamic (`.env`-based), not hardcoded
- **Platform Support**: App targets 6 platforms; test changes across Android/iOS at minimum
- **Typo Alert**: Model file is named `authenticaiton_models.dart` (note: "authenticaiton" not "authentication")—preserve this naming for consistency
- **Lint Enforcement**: Default Flutter lints are active; run `flutter analyze` before commits
- **Hot Reload**: Useful for UI/data changes but use hot restart for dependency/provider changes
