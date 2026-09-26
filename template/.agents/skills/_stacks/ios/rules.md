## iOS Native (Swift & SwiftUI) Guidelines

### 1. Core Technologies & Dependencies
- **Language**: Swift 5.9+ / Swift 6 (Strict Concurrency checking)
- **UI Frameworks**: SwiftUI (chính) kết hợp UIKit khi cần custom sâu
- **State Management & Concurrency**: Observation framework (`@Observable`), async/await, Actors
- **Data Persistence**: SwiftData / CoreData
- **Package Management**: Swift Package Manager (SPM) hoặc CocoaPods

### 2. Architecture & Layer Constraints
```
App/
├── Core/                         # Extensions, Design System, Networking, Logger
├── Domain/                       # Models, UseCases, Repository Protocols
├── Data/                         # API Client, Persistence implementations
└── Features/                     # Feature modules
    └── <FeatureName>/
        ├── Views/                # SwiftUI Views
        └── ViewModels/           # @Observable ViewModels
```

### 3. Conventions & Rules
- Không để xảy ra memory leak (luôn kiểm soát `[weak self]` trong closures).
- Đo đạc hiệu năng với Xcode Instruments (Leaks, Time Profiler).
- Tuân thủ Human Interface Guidelines (HIG) của Apple.
