## Web Frontend (React / Next.js / TypeScript) Guidelines

### 1. Core Technologies & Dependencies
- **Framework**: Next.js (App Router) hoặc Vite + React
- **Language**: TypeScript Strict Mode
- **Styling**: TailwindCSS hoặc Vanilla CSS Modules (theo spec dự án)
- **State Management**: TanStack Query (React Query) + Zustand
- **Forms**: React Hook Form + Zod validation
- **Icons & UI Primitives**: Lucide React, Radix UI

### 2. Architecture & Layer Constraints
```
src/
├── app/                          # Next.js App Router routes & layouts
├── components/                   # Shared UI primitives (atoms/molecules)
├── features/                     # Domain modules (api, components, hooks, types)
├── lib/                          # Utilities, api-client, auth helpers
└── styles/                       # Global css, design tokens
```

### 3. Conventions & Rules
- Tối ưu Web Vitals: LCP < 2.5s, CLS < 0.1, FID/INP mượt mà.
- Phân tách rõ Server Components (RSC) và Client Components (`use client`).
- Semantic HTML5 và Accessibility (a11y - WCAG 2.1 AA).
