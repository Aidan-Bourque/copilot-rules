---
description: Code style conventions and patterns for ScopeGuard
globs: **/*.{ts,tsx,js,jsx}
alwaysApply: false
---

# Code Style - ScopeGuard

## File Naming

- **Components**: PascalCase - ScopeDocument.tsx, ThemeToggle.tsx
- **Pages**: kebab-case - page.tsx, layout.tsx
- **API Routes**: kebab-case -
  route.ts in folder structure
- **Utilities**: camelCase - FormatPrice.ts, generateId.ts
- **Types**: PascalCase - ScopeDocumentProps, SettingsData

## TypeScript Patterns

### Always Define Types

` sx
// Good
interface SettingsData {
businessName: string;
phone: string;
email: string;
}

// Bad - no interface
const settings = { businessName: '', phone: '', email: '' };
`

### Use Type Inference When Obvious

` sx
// Good
const [state, setState] = useState<State>('idle');
const count = 5;

// Bad - over-typing
const count: number = 5;
`

### Prefer Interface Over Type for Objects

` sx
// Good
interface Props { name: string; }

// Acceptable but less preferred
type Props = { name: string; }
`

## React Patterns

### Server Components by Default

` sx
// Good - Server Component (default)
export default function Page() {
return <div>Hello</div>;
}

// Only add 'use client' when needed
'use client';
export default function InteractiveButton() {
const [count, setCount] = useState(0);
return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
`

### Use Functional Components Only

` sx
// Good
export function MyComponent() {}

// Bad - no class components
export class MyComponent extends React.Component {}
`

### Destructure Props

` sx
// Good
export function Greeting({ name, age }: Props) {
return <div>Hello {name}</div>;
}

// Bad
export function Greeting(props: Props) {
return <div>Hello {props.name}</div>;
}
`

## State Management

### Use useState for Simple State

`	sx
const [isOpen, setIsOpen] = useState(false);
const [name, setName] = useState('');
`

### Use useCallback for Event Handlers

` sx
// Good
const handleClick = useCallback(() => {
console.log('clicked');
}, []);

// Acceptable for simple cases
const handleClick = () => console.log('clicked');
`

### Avoid Unnecessary useEffect

` sx
// Bad - derived state in useEffect
const [fullName, setFullName] = useState('');
useEffect(() => {
setFullName(firstName + ' ' + lastName);
}, [firstName, lastName]);

// Good - compute during render
const fullName = firstName + ' ' + lastName;
`

## Styling with Tailwind

### Consistent Patterns

` sx
// Border
className='border border-(--foreground)/10'

// Hover states
className='hover:bg-(--foreground)/15 transition-all'

// Button
className='rounded-lg bg-[#dc2626] px-4 py-3 text-white hover:bg-[#ef4444] transition-all'

// Input
className='rounded-lg border border-(--foreground)/20 bg-(--foreground)/5 px-4 py-2.5'
`

### Use Semantic Color Variables

` sx
// Good
className='text-(--foreground)/80 bg-background'

// Avoid - hardcoded colors except brand colors
className='text-gray-800 bg-white'
`

## Error Handling

### Always Handle API Errors

`	sx
try {
  const res = await fetch('/api/analyze', { ... });
  if (!res.ok) throw new Error('Failed');
  const data = await res.json();
} catch (error) {
  setError('User-friendly message here');
  setState('idle');
}
`

### User-Friendly Error Messages

` sx
// Good
setError('Failed to generate document. Please try again.');

// Bad
setError(error.message); // Raw error message
`

## Imports

### Order: React, Next, External, Internal

`	sx
import { useState, useEffect } from 'react';
import Image from 'next/image';
import { Mic, Download } from 'lucide-react';
import { ScopeDocument } from './components/ScopeDocument';
`

### Use Named Imports

`	sx
// Good
import { pdf } from '@react-pdf/renderer';

// Bad
import \* as ReactPDF from '@react-pdf/renderer';
`

## Comments

### Use Comments for Why, Not What

` sx
// Good - explains why
// Audio visualization setup - required for real-time feedback
const ctx = new AudioContext();

// Bad - obvious from code
// Create new audio context
const ctx = new AudioContext();
`

### JSDoc for Complex Functions

` sx
/\*\*

- Generates a unique reference number for documents
- Format: SGD-YYYYMMDD-XXXX
  \*/
  function generateReferenceNumber(): string {
  // implementation
  }
  `

## Formatting Rules

- **Indentation**: 2 spaces (not tabs)
- **Max line length**: 100 characters (soft limit)
- **Semicolons**: Optional (Biome handles it)
- **Quotes**: Single quotes for strings, double for JSX attributes
- **Trailing commas**: Yes (for multi-line)

## Do NOT

- ❌ Use \tany type (use unknown if truly needed)
- ❌ Use \tvar (use const or let)
- ❌ Mutate state directly (always use setState)
- ❌ Use inline styles (use Tailwind classes)
- ❌ Create unused variables (Biome will catch this)
- ❌ Leave console.log in production code
- ❌ Use deprecated React patterns (componentDidMount, etc.)
