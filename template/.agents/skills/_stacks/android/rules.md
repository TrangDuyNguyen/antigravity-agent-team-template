## Android Native (Kotlin & Jetpack Compose) Guidelines

### 1. Core Technologies & Dependencies
- **Language**: Kotlin (Idiomatic Kotlin, Coroutines, Flow)
- **UI Toolkit**: Jetpack Compose (100% declarative UI)
- **Architecture**: MVI / MVVM với Android Architecture Components
- **Dependency Injection**: Hilt / Koin
- **Local Persistence**: Room Database
- **Network**: Retrofit / Ktor Client + Kotlinx Serialization

### 2. Architecture & Layer Constraints (Clean Architecture)
```
app/src/main/java/com/example/app/
├── core/                         # Design system, theme, base utilities
├── domain/                       # Pure Kotlin models, repository interfaces, use cases
├── data/                         # Room entities, DAOs, API services, repository impls
└── feature/                      # Feature packages
    └── <feature>/
        ├── ui/                   # Compose screens & components
        └── presentation/         # ViewModel & UIState / UIEvent (MVI)
```

### 3. Conventions & Rules
- Giữ Compose Recomposition ở mức tối thiểu (`@Stable`, `@Immutable`, remember, derivedStateOf).
- Không chạy bất kỳ tác vụ I/O nào trên Main/UI Thread (dùng `Dispatchers.IO`).
- Quản lý vòng đời chặt chẽ với `repeatOnLifecycle`.
