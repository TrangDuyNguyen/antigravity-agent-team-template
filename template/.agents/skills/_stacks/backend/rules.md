## Backend & Cloud API Guidelines

### 1. Core Technologies & Architecture
- **Language / Runtime**: Node.js (TypeScript) / Go / Python
- **API Styles**: RESTful JSON, GraphQL, hoặc gRPC
- **Databases**: PostgreSQL (Relational), MongoDB (Document), Redis (Cache & Session)
- **Architecture**: Hexagonal Architecture / Clean Architecture (Domain, Application, Infrastructure, Adapters)
- **Observability**: Structured Logging (JSON), OpenTelemetry, Health checks

### 2. Architecture & Layer Constraints
```
src/
├── domain/                       # Business entities & business rules (zero external dependencies)
├── application/                  # Use cases, DTOs, service interfaces
├── infrastructure/               # Database repositories, external API clients, message brokers
└── interfaces/                   # HTTP controllers, gRPC handlers, CLI commands
```

### 3. Conventions & Rules
- Input validation bắt buộc ở mọi request handler (Zod, Pydantic, hoặc Go validator).
- Quản lý database migrations có version kiểm soát (Prisma, Flyway, Alembic, golang-migrate).
- Triệt tiêu N+1 queries, cấu hình connection pool chuẩn xác.
- Bảo mật: CORS, Rate Limiting, OWASP Top 10 mitigation.
