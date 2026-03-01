# Agents Guide (deepple_app)

This repo is a Flutter (Dart) app.

## Source Of Truth

- Commands: `Makefile`
- CI: `.github/workflows/flutter_test.yaml` (Flutter `3.35.4` stable, runs `flutter test --coverage`)
- Lints: `analysis_options.yaml` (includes `package:flutter_lints/flutter.yaml`)
- No Cursor/Copilot rules found (`.cursor/rules/`, `.cursorrules`, `.github/copilot-instructions.md`).

## Setup (Env + Init)

- Env template: `.env.example`; create local `dev.env` / `prod.env` (not committed)
- App config loads early via `Config.initialize()` in `lib/main.dart`; missing env can break runtime

```bash
make init
```

`make init` runs: `flutter pub get`, splash/icons generation, then build_runner.

## Daily Commands

Prefer Make targets:

```bash
make generate
make analyze
make test

make run ENV_FILE=dev.env
make android-build ENV_FILE=dev.env
make ios-build ENV_FILE=prod.env
```

Direct equivalents (when not using Makefile):

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run --dart-define-from-file=dev.env
```

Notes:

- `make build` does `flutter build apk --release` (no `--dart-define-from-file`); prefer `make android-build ENV_FILE=...` when env-dependent.
- For Play Store builds, `README.md` documents `flutter build aab --release --dart-define-from-file=prod.env`.

## Tests (Single Test)

```bash
# All tests
flutter test

# Single test file
flutter test test/some_feature/some_test.dart

# Filter by test name
flutter test --plain-name "my test name"
```

If there is no `test/` directory yet, `flutter test` may still run (compilation check).

## Formatting

```bash
dart format .
```

Keep diffs small; avoid mass reformatting unrelated files.

## Code Style (What The Repo Enforces)

From `analysis_options.yaml`:

- `prefer_single_quotes`
- `always_use_package_imports`
- `prefer_const_constructors`, `prefer_const_declarations`
- `prefer_final_fields`

Imports (observed in `lib/main.dart`, `lib/app/app.dart`):

1. `dart:` imports
2. internal `package:deepple_app/...`
3. external `package:` imports
4. `part '...';` directives adjacent after imports

Generated code:

- Do not edit `*.g.dart`, `*.freezed.dart`, `lib/hive_registrar.g.dart`
- Edit the source file and regenerate via `make generate` / build_runner

Naming:

- Files: `snake_case.dart`
- Pages: `lib/features/**/presentation/page/*_page.dart`
- Widgets: `lib/features/**/presentation/widget/*_widget.dart`
- DTOs/states: `_request.dart`, `_response.dart`, `_dto.dart`, `_state.dart`

Types:

- Null-safety everywhere; avoid `dynamic` unless forced by external APIs
- Prefer `final` locals; model state with immutable Freezed classes

Error handling + logging:

- Global crash capture: `runZonedGuarded(..., (error, stack) => Log.e(...))` in `lib/main.dart`
- Use `Log.d/i/w/e` (`lib/core/util/log.dart`); avoid `print()`
- On caught errors: show user feedback via `showToastMessage(...)` when appropriate and log with context

## Architecture Notes

- Structure:
  - `lib/app/` app shell, routing, shared UI
  - `lib/core/` cross-cutting utilities (networking/logging/storage/extensions)
  - `lib/features/<feature>/{data,domain,presentation}/...`
- Routing: `go_router` (`lib/app/router/`)
- State management: Riverpod + codegen
  - Root: `ProviderScope(observers: [DefaultProviderObserver()], child: const App())` in `lib/main.dart`
  - Notifiers commonly use `@riverpod` and `extends _$X` (see `lib/features/home/presentation/provider/home_notifier.dart`)
  - State commonly uses `@freezed` (see `lib/features/home/presentation/provider/home_state.dart`)
- UI foundation: pages often extend base states in `lib/core/state/base_page_state.dart` (shared loading overlay via `commonProvider`)

## Agent Hygiene

- Follow existing patterns; prefer small, localized diffs.
- Regenerate after changing any annotated class.
- Never commit secrets or local env files (`dev.env`, `prod.env`).
