---
description: Core engineering principles - simplicity, modularity, and avoiding tech debt
globs: **/*.{ts,tsx,js,jsx}
alwaysApply: true
---

# Engineering Principles - ScopeGuard

## 🎯 Core Philosophy

**Build for 99% of cases, not the 1%.**

Write code as if you're explaining it to a junior developer. If they can't understand it in 5 minutes, it's too complex.

## The Golden Rules

### 1. KISS - Keep It Simple, Stupid

**Principle:** The simplest solution that works is almost always the best solution.

**Bad (Over-engineered):**
`\tsx
// Abstract factory pattern for a button
class ButtonFactory {
  private static instance: ButtonFactory;
  private constructor() {}
  
  static getInstance(): ButtonFactory {
    if (!ButtonFactory.instance) {
      ButtonFactory.instance = new ButtonFactory();
    }
    return ButtonFactory.instance;
  }
  
  createButton(type: ButtonType, config: ButtonConfig): IButton {
    switch (type) {
      case ButtonType.Primary:
        return new PrimaryButton(config);
      case ButtonType.Secondary:
        return new SecondaryButton(config);
      default:
        throw new Error('Invalid button type');
    }
  }
}

// Usage (way too complex for a button)
const factory = ButtonFactory.getInstance();
const button = factory.createButton(ButtonType.Primary, { label: 'Click' });
`

**Good (Simple):**
`\tsx
// Just a button component
interface ButtonProps {
  label: string;
  variant?: 'primary' | 'secondary';
  onClick: () => void;
}

export function Button({ label, variant = 'primary', onClick }: ButtonProps) {
  const isPrimary = variant === 'primary';
  return (
    <button
      onClick={onClick}
      className={isPrimary 
        ? 'bg-[#dc2626] text-white hover:bg-[#ef4444]'
        : 'border border-(--foreground)/20 hover:border-(--foreground)/40'
      }
    >
      {label}
    </button>
  );
}
`

**Why Simple Wins:**
- ✅ Any developer can understand it immediately
- ✅ Easy to modify and debug
- ✅ No hidden complexity
- ✅ Fewer bugs
- ✅ Faster to write and test

---

### 2. YAGNI - You Aren't Gonna Need It

**Principle:** Don't build features or abstractions for hypothetical future needs. Build what you need NOW.

**Bad (Premature Abstraction):**
`\tsx
// Building a complex database abstraction when we're using localStorage
interface IStorage {
  get<T>(key: string): Promise<T | null>;
  set<T>(key: string, value: T): Promise<void>;
  delete(key: string): Promise<void>;
  query<T>(predicate: (item: T) => boolean): Promise<T[]>;
}

class LocalStorageAdapter implements IStorage {
  async get<T>(key: string): Promise<T | null> {
    // Complex implementation with error handling, serialization, etc.
  }
  // ... more complex methods
}

class DatabaseAdapter implements IStorage {
  // We don't even have a database yet!
}
`

**Good (Build What You Need):**
`\tsx
// Simple localStorage helpers for current needs
export function getSettings(): SettingsData | null {
  const stored = localStorage.getItem('scopeguard_settings');
  if (!stored) return null;
  try {
    return JSON.parse(stored);
  } catch {
    return null;
  }
}

export function saveSettings(settings: SettingsData): void {
  localStorage.setItem('scopeguard_settings', JSON.stringify(settings));
}

// When we add a database later, we'll refactor. That's OK!
`

**When to Add Abstraction:**
- ✅ You're using it in 3+ places (DRY principle)
- ✅ The pattern is proven and stable
- ✅ It reduces actual complexity (not adds it)
- ❌ We might need it later
- ❌ This is how big companies do it
- ❌ It's more scalable (when you have 10 users)

---

### 3. DRY - Don't Repeat Yourself (Single Source of Truth)

**Principle:** Every piece of knowledge should have one authoritative source.

**Bad (Multiple Sources of Truth):**
`\tsx
// Settings defined in 3 places!

// app/page.tsx
const DEFAULT_TAX_RATE = 0.13;
const DEFAULT_BUSINESS_NAME = 'Cabinet Craft';

// app/settings/page.tsx
const DEFAULT_SETTINGS = {
  taxRate: 0.13,
  businessName: 'Cabinet Craft',
};

// app/components/ScopeDocument.tsx
const CONTRACTOR_INFO = {
  businessName: 'Cabinet Craft',
  taxRate: 0.13,
};
`

**Good (Single Source of Truth):**
`\tsx
// app/lib/constants.ts (ONE place)
export const DEFAULT_SETTINGS = {
  businessName: 'Cabinet Craft',
  phone: '289 923 9595',
  email: 'info@cabinetcraft.ca',
  taxRate: 0.13,
  taxLabel: 'HST',
} as const;

// Used everywhere
import { DEFAULT_SETTINGS } from '@/app/lib/constants';
`

**When to Extract to Single Source:**
- ✅ Used in 2+ places
- ✅ Configuration/constants
- ✅ Business logic
- ✅ Validation rules
- ✅ Utility functions

---

### 4. Modularity - Build Lego Blocks, Not Monoliths

**Principle:** Each piece should do ONE thing well and be reusable.

**Bad (God Component):**
`\tsx
// One massive component doing everything
export default function Page() {
  // 100 lines of state management
  const [state1, setState1] = useState();
  const [state2, setState2] = useState();
  // ... 20 more states
  
  // 200 lines of business logic
  const handleSubmit = () => { /* 50 lines */ };
  const handleAnalyze = () => { /* 80 lines */ };
  const handleDownload = () => { /* 70 lines */ };
  
  // 300 lines of JSX
  return (
    <div>
      {/* All UI inline, no components */}
      {/* Impossible to test or reuse */}
    </div>
  );
}
`

**Good (Modular):**
`\tsx
// Small, focused modules
import { useRecording } from './hooks/useRecording';
import { useTranscription } from './hooks/useTranscription';
import { RecordingButton } from './components/RecordingButton';
import { TranscriptionDisplay } from './components/TranscriptionDisplay';
import { DownloadButton } from './components/DownloadButton';

export default function Page() {
  const { isRecording, startRecording, stopRecording } = useRecording();
  const { transcription, analyze } = useTranscription();
  
  return (
    <div>
      <RecordingButton 
        isRecording={isRecording}
        onStart={startRecording}
        onStop={stopRecording}
      />
      <TranscriptionDisplay text={transcription} />
      <DownloadButton onDownload={analyze} />
    </div>
  );
}
`

**Modularity Checklist:**
- ✅ Each function does ONE thing
- ✅ Functions are < 50 lines (guideline, not strict rule)
- ✅ Components are < 200 lines
- ✅ Files are < 500 lines
- ✅ Logic is extracted to hooks/utils when used 2+ times
- ✅ UI is broken into composable components

---

### 5. Readability Over Cleverness

**Principle:** Code is read 100x more than it's written. Optimize for reading.

**Bad (Clever but Confusing):**
`\tsx
// Clever one-liner that requires deep thought
const x = data?.reduce((a, b) => ({ ...a, [b.k]: b.v }), {}) ?? {};

// Nested ternaries
const status = isLoading ? 'loading' : error ? 'error' : data ? 'success' : 'idle';

// Clever regex
const clean = text.replace(/(?:https?|ftp):\/\/[\n\S]+/g, '').replace(/\s+/g, ' ');
`

**Good (Clear and Obvious):**
`\tsx
// Clear, self-documenting code
const keyValueMap: Record<string, string> = {};
if (data) {
  for (const item of data) {
    keyValueMap[item.key] = item.value;
  }
}

// Clear conditionals
let status: Status;
if (isLoading) status = 'loading';
else if (error) status = 'error';
else if (data) status = 'success';
else status = 'idle';

// Clear regex with comments
const cleanedText = text
  .replace(/(?:https?|ftp):\/\/[\n\S]+/g, '') // Remove URLs
  .replace(/\s+/g, ' '); // Normalize whitespace
`

**Readability Guidelines:**
- ✅ Descriptive variable names (no x, \tmp, data2)
- ✅ One operation per line when clarity suffers
- ✅ Comments explain WHY, not WHAT
- ✅ Early returns over nested conditionals
- ✅ Guard clauses for error handling
- ❌ Clever one-liners
- ❌ Nested ternaries
- ❌ Cryptic abbreviations

---

### 6. Avoid Premature Optimization

**Principle:** Make it work first, make it right second, make it fast third (if needed).

**Bad (Premature Optimization):**
`\tsx
// Optimizing before measuring
const MemoizedButton = memo(Button, (prev, next) => {
  return prev.label === next.label && 
         prev.onClick === next.onClick &&
         prev.variant === next.variant;
});

// Using useMemo for everything
const buttonLabel = useMemo(() => 'Click Me', []);
const isDisabled = useMemo(() => !isValid, [isValid]);

// Complex caching when we have 10 users
class CacheManager {
  // 200 lines of caching logic
}
`

**Good (Optimize When Needed):**
`\tsx
// Simple, working code
export function Button({ label, onClick, variant }: ButtonProps) {
  return <button onClick={onClick}>{label}</button>;
}

// If profiler shows this component is slow (it won't be),
// THEN add memo. Not before.

// Optimize based on real data:
// 1. Use React DevTools Profiler
// 2. Identify actual bottlenecks
// 3. Fix the slowest thing first
// 4. Measure again
`

**When to Optimize:**
- ✅ After profiling shows an actual problem
- ✅ User-facing performance issue
- ✅ Bundle size > 300KB
- ✅ Lighthouse score < 90
- ❌ This might be slow
- ❌ Best practice to always memo
- ❌ Before measuring

---

### 7. One-Off Solutions Are Tech Debt

**Principle:** If you solve a problem, solve it in a way that handles similar problems.

**Bad (One-Off Solution):**
`\tsx
// Duplicated logic everywhere
function formatPriceInPage() {
  return '$' + price.toFixed(2);
}

function showPriceInComponent() {
  return price.toFixed(2) + ' CAD';
}

function displayCostInPDF() {
  return 'CA$' + price.toFixed(2);
}
`

**Good (Reusable Solution):**
`\tsx
// app/lib/utils.ts
export function formatPrice(
  price: number,
  options?: {
    currency?: 'CAD' | 'USD';
    locale?: string;
  }
): string {
  const { currency = 'CAD', locale = 'en-CA' } = options ?? {};
  
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency,
  }).format(price);
}

// Used everywhere consistently
formatPrice(100);              // .00
formatPrice(100, { currency: 'USD' }); // .00 (USD)
`

**Reusability Checklist:**
- ✅ Logic used 2+ times → extract to function
- ✅ UI pattern used 3+ times → create component
- ✅ Similar problems → generalize solution
- ✅ Configuration → extract to constants
- ❌ This is special (99% of the time it's not)

---

## Decision Framework

### When Adding Complexity, Ask:

1. **Does this solve a CURRENT problem?**
   - ❌ We might need this later → Don't build it
   - ✅ We need this now → Build it simple

2. **Can a junior understand this in 5 minutes?**
   - ❌ No → Simplify or add clear comments
   - ✅ Yes → Good to go

3. **Is this the simplest solution?**
   - ❌ No → Simplify it
   - ✅ Yes → Ship it

4. **Does this follow a proven pattern in this codebase?**
   - ✅ Yes → Consistent, good
   - ❌ No → Why? Is there a simpler way?

5. **Am I repeating myself?**
   - ✅ Yes (2+ times) → Extract it
   - ❌ No → Leave it for now

### Red Flags (Stop and Simplify)

- 🚩 This is how [Big Tech Company] does it
- 🚩 We need to be ready to scale
- 🚩 Best practice says to always...
- 🚩 Future-proofing
- 🚩 Enterprise-grade
- 🚩 Industry standard architecture
- 🚩 Just in case we need...

### Green Lights (This is Good)

- ✅ This solves our current problem
- ✅ Anyone can understand this
- ✅ This is used in 3 places
- ✅ This makes the code clearer
- ✅ This removes duplication
- ✅ This fixes a real performance issue
- ✅ This makes testing easier

---

## Practical Examples

### Example 1: Form Validation

**Bad (Over-engineered):**
`\tsx
// Full validation framework for one form
import { z } from 'zod';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';

const schema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
});

type FormData = z.infer<typeof schema>;
`

**Good (Simple):**
`\tsx
// Just validate on submit
function handleSubmit(e: FormEvent) {
  e.preventDefault();
  
  if (!name.trim()) {
    setError('Name is required');
    return;
  }
  
  if (!email.includes('@')) {
    setError('Invalid email');
    return;
  }
  
  // Submit form
}
`

**When to Add Zod:**
- ✅ You have 5+ forms with complex validation
- ✅ API responses need runtime validation
- ❌ You have 1-2 simple forms

### Example 2: State Management

**Bad (Over-engineered):**
`\tsx
// Redux for settings
const settingsSlice = createSlice({
  name: 'settings',
  initialState,
  reducers: {
    setBusinessName: (state, action) => { ... },
    setPhone: (state, action) => { ... },
    setEmail: (state, action) => { ... },
  },
});
`

**Good (Simple):**
`\tsx
// Just useState
const [settings, setSettings] = useState(DEFAULT_SETTINGS);

// If shared across many components, use Context
const SettingsContext = createContext(DEFAULT_SETTINGS);
`

**When to Add Redux:**
- ✅ 10+ components need shared state
- ✅ Complex state logic with middleware
- ❌ Simple settings (use Context)

---

## Refactoring Triggers

Refactor to a more complex solution ONLY when:

1. **Rule of Three:** Used in 3+ places (then DRY it up)
2. **Performance Issue:** Profiler shows it's slow
3. **Actual Scale Issue:** 1000+ users hitting real limits
4. **Team Growth:** 5+ developers need clear patterns
5. **Real Bug Pattern:** Same type of bug recurring

**Never refactor because:**
- ❌ Might be useful someday
- ❌ More professional looking
- ❌ Learned this pattern in a course
- ❌ Big companies use this

---

## Summary: The Simplicity Checklist

Before writing ANY code, ask:

- [ ] Is this the simplest solution that works?
- [ ] Can a junior understand this?
- [ ] Am I building for 99% of cases (not the 1%)?
- [ ] Am I avoiding duplication (single source of truth)?
- [ ] Is this modular and reusable?
- [ ] Am I solving a CURRENT problem (not future maybes)?
- [ ] Is this readable over clever?

If you can't check all boxes, simplify.

---

**Remember:** Simple code is not junior code. Simple code is professional code. The best developers write code that looks easy.

**Complexity is easy. Simplicity is hard. Choose simplicity.**