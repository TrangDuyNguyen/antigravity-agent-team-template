## React Native (Standard Bare CLI) Guidelines

### 1. Core Technologies & Dependencies
- **Runtime & CLI**: React Native Community CLI (`react-native init`, Bare Workflow - No Expo)
- **Language**: TypeScript Strict Mode (`strict: true`)
- **Navigation**: `@react-navigation/native`, `@react-navigation/native-stack`
- **State Management**: Zustand or TanStack Query (React Query)
- **Animations & Gestures**: `react-native-reanimated`, `react-native-gesture-handler`
- **Native Package Managers**: CocoaPods (`pod install` for iOS), Gradle for Android

### 2. Architecture & Layer Constraints (Feature-First)
```
src/
├── core/                         # Cross-cutting (theme, network client, storage, constants)
├── features/                     # Feature domain modules
│   └── <feature_name>/
│       ├── api/                  # API endpoints & TanStack query hooks
│       ├── components/           # Feature UI widgets
│       ├── hooks/                # Business logic hooks
│       └── screens/              # Screen components
├── navigation/                   # Root stack & tab navigators
└── shared/                       # Global UI components (buttons, cards, inputs)
```

### 3. Conventions & Rules
- **No Expo SDK**: Luôn sử dụng Bare React Native CLI tiêu chuẩn.
- **Native Bridging**: Quản lý `ios/Podfile` và `android/build.gradle` sạch sẽ.
- **Performance**: Duy trì 60 FPS mượt mà qua Reanimated worklets (chạy trên UI thread), hạn chế re-render qua `React.memo` và `useCallback`.
- **Testing**: Chạy Jest qua `npm test` hoặc `yarn test`.
