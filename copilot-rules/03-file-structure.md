---
description: Project folder structure and file organization conventions
globs: **/*
alwaysApply: false
---

# File Structure - ScopeGuard

## Current Structure

`
scopeguard/
├── .cursor/
│   ├── README.md
│   ├── rules/           # Cursor AI rules
│   └── commands/        # Reusable commands
├── app/
│   ├── api/
│   │   ├── analyze/
│   │   │   └── route.ts      # AI analysis endpoint
│   │   └── transcribe/
│   │       └── route.ts      # Audio transcription endpoint
│   ├── components/
│   │   ├── ScopeDocument.tsx # PDF component
│   │   ├── ThemeProvider.tsx # Theme context
│   │   └── ThemeToggle.tsx   # Theme switcher
│   ├── settings/
│   │   └── page.tsx          # Settings page
│   ├── favicon.ico
│   ├── globals.css           # Global styles + Tailwind
│   ├── layout.tsx            # Root layout
│   │   └── page.tsx              # Home page
├── public/
│   ├── SG-Full_Logo.svg
│   ├── SG-Full_Logo-dark.svg
│   └── SG-Icon.svg
├── .env.local               # Environment variables (not in git)
├── .gitignore
├── biome.json               # Biome config
├── next.config.ts           # Next.js config
├── package.json
├── postcss.config.mjs       # PostCSS/Tailwind config
├── README.md
└── tsconfig.json            # TypeScript config
`

## Naming Conventions

### Folders
- **lowercase with hyphens** for routes: \tapp/settings/, \tapp/my-documents/
- **PascalCase** not used for folders

### Files
- **Routes**: page.tsx, layout.tsx, 
oute.ts (Next.js convention)
- **Components**: PascalCase.tsx - ScopeDocument.tsx
- **Utilities**: camelCase.ts - \tormatPrice.ts
- **Types**: \ttypes.ts or inline in component files

## Where Things Go

### Components (\tapp/components/)
- Reusable UI components
- PDF templates
- Layout components (Theme, Nav, etc.)

**Example:**
- \tapp/components/ScopeDocument.tsx - PDF template
- \tapp/components/ThemeToggle.tsx - Theme switcher
- \tapp/components/Button.tsx - Reusable button (future)

### API Routes (\tapp/api/)
- Each endpoint gets its own folder
- Use 
oute.ts for the handler

**Pattern:**
`
app/api/
├── analyze/
│   └── route.ts          # POST /api/analyze
└── transcribe/
    └── route.ts          # POST /api/transcribe
`

### Pages (\tapp/)
- Each route is a folder with page.tsx
- Root page is \tapp/page.tsx

**Pattern:**
`
app/
├── page.tsx              # /
├── settings/
│   └── page.tsx          # /settings
└── documents/            # Future
    └── page.tsx          # /documents
`

### Assets (public/)
- Images, fonts, static files
- Accessed via /filename.ext in code

### Styles (\tapp/globals.css)
- ONE global CSS file
- Contains Tailwind imports + CSS variables
- No component-specific CSS files

## Future Structure (When Adding Database)

`
app/
├── api/
│   ├── analyze/
│   ├── transcribe/
│   ├── documents/        # CRUD for documents
│   │   └── route.ts
│   └── customers/        # CRUD for customers
│       └── route.ts
├── components/
│   ├── ui/               # shadcn/ui components
│   │   ├── button.tsx
│   │   ├── input.ts
│   │   └── dialog.ts
│   ├── ScopeDocument.tsx
│   └── DocumentList.tsx  # New
├── documents/
│   └── page.tsx          # Document history
├── customers/
│   └── page.tsx          # Customer list
└── lib/
    ├── supabase.ts       # Supabase client
    └── utils.ts          # Helper functions
`

## Co-location Strategy

### Keep Related Files Together
`	sx
// Good - component with types in same file
// app/components/ScopeDocument.tsx
export interface ScopeDocumentProps {
  reference_number: string;
  // ...
}

export function ScopeDocument(props: ScopeDocumentProps) {
  // ...
}
`

### Separate Only When Shared
`	sx
// app/types/document.ts - only if used in multiple files
export interface Document {
  id: string;
  // ...
}
`

## Import Path Strategy

### Use Absolute Imports (When Configured)
`	sx
// Good (requires tsconfig paths)
import { ScopeDocument } from '@/app/components/ScopeDocument';

// Current (relative is fine for now)
import { ScopeDocument } from './components/ScopeDocument';
`

## File Size Guidelines

- **Components**: < 500 lines (split if larger)
- **Pages**: < 300 lines (extract components if larger)
- **API Routes**: < 200 lines (extract logic to utils if larger)
- **Rule Files**: < 500 lines (split into multiple rules if larger)

## What NOT to Include

- ❌ No /src/ folder (use /app/ directly)
- ❌ No /components/ at root (keep in /app/components/)
- ❌ No /styles/ folder (use globals.css only)
- ❌ No /utils/ yet (add when needed as /app/lib/)
- ❌ No /config/ folder (keep configs at root)
