## Flutter & Dart Tech Stack Guidelines

### 1. Core Technologies & Dependencies
- **Flutter / Dart**: Flutter 3.x, Dart `>=3.0.0 <4.0.0`
- **State Management**: `flutter_riverpod: ^2.6.1`, `riverpod_annotation: ^2.6.1`, `riverpod_generator: ^2.6.3`
- **Routing**: `auto_route: ^9.2.2`, `auto_route_generator: ^9.0.0`
- **Data Modeling**: `freezed: ^3.0.2`, `json_serializable: ^6.9.4`
- **HTTP / Network**: `dio` or standard `http` with clean interceptors
- **Testing**: `flutter_test`, `mocktail` or `mockito`

### 2. Architecture & Layer Constraints (Feature-First Clean Architecture)
```
lib/
├── core/                         # Cross-cutting concerns & foundational layer
│   ├── constants/                # App strings, numerical constraints
│   ├── router/                   # AutoRoute setup
│   ├── theme/                    # Theme tokens & typography
│   └── utils/                    # Parsers & calculation logic
├── features/                     # Business domain modules
│   └── <feature_name>/
│       ├── domain/               # Pure Dart entities (@freezed)
│       ├── data/                 # Repositories & DTOs
│       └── presentation/         # Riverpod controllers & UI screens (@RoutePage)
└── shared/                       # Reusable widgets without domain coupling
```

### 3. Coding & State Management Conventions
- Prefer code-generation syntax (`@riverpod`) over legacy global provider declarations.
- Use `AsyncValue` for asynchronous state handling (loading, error, data).
- Keep side-effects inside Notifier methods; never call asynchronous business logic directly in `build()` methods.
- Run code generation: `dart run build_runner build --delete-conflicting-outputs`.
- Verify tests: `flutter test`.
