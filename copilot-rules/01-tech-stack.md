---
description: Core technology stack decisions and rationale for ScopeGuard
globs: **/*.{ts,tsx,js,jsx,json}
alwaysApply: true
---

# Tech Stack - ScopeGuard

## Core Stack (2026 Hyper-Stack)

### TypeScript 5+ (Language)
- AI-generated code benefits from compile-time type checking
- Catches hallucinated methods/properties before runtime
- Strict mode enabled

### Next.js 16 App Router (Framework)
- API routes = no separate backend
- React Server Components
- We use App Router (NOT Pages Router)

### React 19 (UI Framework)
- Functional components only
- Hooks for state management
- Server Components by default

### Tailwind CSS 4 (Styling)
- Utility-first = faster development
- Brand colors: #dc2626 (primary), #ef4444 (accent)
- Dark mode with dark: prefix

### Biome (Linting/Formatting)
- 10-100x faster than ESLint
- Handles linting AND formatting
- Commands: npm run lint, npm run lint:fix, npm run format
- IMPORTANT: We removed ESLint. Do not add it back.

### @react-pdf/renderer (PDF Generation)
- Location: app/components/ScopeDocument.tsx
- Limitations: Helvetica fonts only, Flexbox only (no Grid), React Native StyleSheet

### OpenAI API (AI Services)
- Routes: /api/transcribe (Whisper), /api/analyze (GPT-4o)
- API key in .env.local (NEVER client-side)
- Always use server-side routes

## What We DON'T Use
- Redux/Zustand (useState sufficient)
- CSS-in-JS (Tailwind only)
- GraphQL (REST simpler)
- ESLint (using Biome)

## Planned Additions (Q1 2026)
- Supabase (Database + Auth)
- shadcn/ui (UI Components)
- Resend or SendGrid (Email)

## Security Rules
1. NEVER expose API keys to client
2. Validate all API inputs
3. Rate limiting on API routes (future)
4. CORS: Same origin only
