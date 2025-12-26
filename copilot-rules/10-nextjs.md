---
description: Next.js specific patterns and conventions for ScopeGuard
globs: app/**/*.{ts,tsx}
alwaysApply: false
---

# Next.js Patterns - ScopeGuard

## App Router Structure

We use **App Router** (NOT Pages Router). All routes live in \tapp/.

### Route Definition
`
app/
├── page.tsx              # / (home)
├── layout.tsx            # Root layout (wraps all pages)
├── settings/
│   └── page.tsx          # /settings
└── documents/
    ├── page.tsx          # /documents
    └── [id]/
        └── page.tsx      # /documents/:id (dynamic route)
`

## Server vs Client Components

### Default to Server Components
`\tsx
// app/page.tsx - Server Component (default)
export default function Page() {
  // Can fetch data here directly
  const data = await fetchData();
  return <div>{data}</div>;
}
`

### Use 'use client' Only When Needed
`\tsx
// app/components/ThemeToggle.tsx
'use client'; // Required for useState, useEffect, onClick, etc.

import { useState } from 'react';

export function ThemeToggle() {
  const [theme, setTheme] = useState('light');
  return <button onClick={() => setTheme('dark')}>Toggle</button>;
}
`

### When to Use Client Components
- ✅ Using React hooks (useState, useEffect, useContext, etc.)
- ✅ Event handlers (onClick, onChange, onSubmit, etc.)
- ✅ Browser APIs (localStorage, window, navigator, etc.)
- ✅ Third-party libraries that use hooks

### When to Use Server Components
- ✅ Static content rendering
- ✅ Data fetching (future with database)
- ✅ No interactivity needed
- ✅ SEO-critical content

## API Routes

### File: \tapp/api/[name]/route.ts

`\tsx
// app/api/analyze/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Process request
    const result = await processData(body);
    
    return NextResponse.json(result);
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to process' },
      { status: 500 }
    );
  }
}
`

### HTTP Methods
`\tsx
export async function GET(request: NextRequest) { /* ... */ }
export async function POST(request: NextRequest) { /* ... */ }
export async function PUT(request: NextRequest) { /* ... */ }
export async function DELETE(request: NextRequest) { /* ... */ }
`

### Environment Variables in API Routes
`\tsx
// Good - server-side only
export async function POST() {
  const apiKey = process.env.OPENAI_API_KEY;
  // Use apiKey safely
}

// Bad - never expose to client
'use client';
const apiKey = process.env.OPENAI_API_KEY; // ❌ Will be exposed!
`

## Layouts

### Root Layout (\tapp/layout.tsx)
`\tsx
import { ThemeProvider } from './components/ThemeProvider';
import './globals.css';

export const metadata = {
  title: 'ScopeGuard',
  description: 'AI-powered contractor documentation',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang='en' suppressHydrationWarning>
      <body>
        <ThemeProvider>
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
`

### Nested Layouts (Future)
`\tsx
// app/dashboard/layout.tsx
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div>
      <Sidebar />
      <main>{children}</main>
    </div>
  );
}
`

## Metadata

### Static Metadata
`\tsx
// app/page.tsx
export const metadata = {
  title: 'ScopeGuard - Contractor Documentation',
  description: 'Transform conversations into professional PDFs',
};
`

### Dynamic Metadata (Future)
`\tsx
// app/documents/[id]/page.tsx
export async function generateMetadata({ params }) {
  const doc = await fetchDocument(params.id);
  return {
    title: Document ,
  };
}
`

## Data Fetching (Future with Database)

### Server Component Fetch
`\tsx
// app/documents/page.tsx
async function getDocuments() {
  const res = await fetch('https://api.example.com/docs', {
    cache: 'no-store', // Always fresh
  });
  return res.json();
}

export default async function DocumentsPage() {
  const docs = await getDocuments();
  return <DocumentList documents={docs} />;
}
`

### Client Component Fetch (Current Pattern)
`\tsx
'use client';
import { useState, useEffect } from 'react';

export default function Page() {
  const [data, setData] = useState(null);
  
  useEffect(() => {
    fetch('/api/data')
      .then(res => res.json())
      .then(setData);
  }, []);
  
  return <div>{data}</div>;
}
`

## Images

### Use Next.js Image Component
`\tsx
import Image from 'next/image';

// Good
<Image 
  src='/SG-Full_Logo.svg' 
  alt='ScopeGuard'
  width={280}
  height={48}
  priority // For above-the-fold images
/>

// Bad
<img src='/logo.svg' alt='Logo' />
`

## Links

### Use Next.js Link Component
`\tsx
import Link from 'next/link';

// Good - client-side navigation
<Link href='/settings'>Settings</Link>

// Bad - full page reload
<a href='/settings'>Settings</a>
`

## Loading States (Future)

### Loading UI
`\tsx
// app/documents/loading.tsx
export default function Loading() {
  return <div>Loading documents...</div>;
}
`

### Error UI
`\tsx
// app/documents/error.tsx
'use client';

export default function Error({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
`

## Route Handlers Best Practices

### Always Validate Input
`\tsx
export async function POST(request: NextRequest) {
  const body = await request.json();
  
  // Validate
  if (!body.transcription) {
    return NextResponse.json(
      { error: 'transcription is required' },
      { status: 400 }
    );
  }
  
  // Process...
}
`

### Set Proper Status Codes
- 200: Success
- 201: Created
- 400: Bad Request (validation error)
- 401: Unauthorized
- 404: Not Found
- 500: Internal Server Error

### CORS Headers (When Needed)
`\tsx
export async function POST(request: NextRequest) {
  const response = NextResponse.json({ success: true });
  
  // Only if external clients need access
  response.headers.set('Access-Control-Allow-Origin', '*');
  
  return response;
}
`

## Common Patterns in This Project

### Main Page (\tapp/page.tsx)
- Client component (uses useState, audio recording)
- Handles voice/text input
- Calls API routes
- Generates and downloads PDF

### Settings Page (\tapp/settings/page.tsx)
- Client component (localStorage, forms)
- Persists user preferences
- Loads/saves settings

### API Routes (\tapp/api/*/route.ts)
- Server-side only
- No 'use client'
- Handle OpenAI API calls
- Return JSON responses
