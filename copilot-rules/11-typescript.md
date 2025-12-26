---
description: TypeScript conventions and patterns for ScopeGuard
globs: **/*.{ts,tsx}
alwaysApply: false
---

# TypeScript Patterns - ScopeGuard

## Type Definitions

### Interface for Object Shapes
`\tsx
// Good
interface ScopeDocumentProps {
  reference_number: string;
  scope_of_work: string;
  cost_breakdown: CostBreakdown;
  materials: string;
  customer_name: string | null;
  customer_contact: string | null;
}

// Also acceptable
type ScopeDocumentProps = {
  reference_number: string;
  // ...
};
`

### Type for Unions and Primitives
`\tsx
// Good
type State = 'idle' | 'recording' | 'processing' | 'done' | 'analyzing';
type InputMode = 'voice' | 'text';

// Bad
interface State {
  value: 'idle' | 'recording';
}
`

### Nullable Fields
`\tsx
// Use | null for optional data that can be explicitly null
interface CostBreakdown {
  materials_cost: number | null;
  labor_cost: number | null;
  tax_amount: number | null;
  total: number | null;
}

// Use ? for optional properties that may not exist
interface OptionalProps {
  contractor_info?: ContractorInfo;
  tax_config?: TaxConfig;
}
`

## React Component Types

### Functional Component Props
`\tsx
interface ButtonProps {
  label: string;
  onClick: () => void;
  disabled?: boolean;
}

export function Button({ label, onClick, disabled = false }: ButtonProps) {
  return <button onClick={onClick} disabled={disabled}>{label}</button>;
}
`

### Children Prop
`\tsx
interface LayoutProps {
  children: React.ReactNode;
}

export function Layout({ children }: LayoutProps) {
  return <div>{children}</div>;
}
`

### Event Handlers
`\tsx
// Form events
const handleSubmit = (e: React.FormEvent) => {
  e.preventDefault();
};

// Input events
const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  setValue(e.target.value);
};

// Click events
const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
  console.log('clicked');
};
`

## Hooks

### useState
`\tsx
// Simple types
const [count, setCount] = useState(0);
const [name, setName] = useState('');

// Complex types
const [state, setState] = useState<State>('idle');
const [data, setData] = useState<ScopeDocumentProps | null>(null);

// Array
const [items, setItems] = useState<string[]>([]);
`

### useRef
`\tsx
// DOM refs
const inputRef = useRef<HTMLInputElement>(null);

// Mutable values
const recorderRef = useRef<MediaRecorder | null>(null);
const chunksRef = useRef<Blob[]>([]);
`

### useCallback
`\tsx
const handleClick = useCallback(() => {
  console.log('clicked');
}, []); // Dependencies array
`

## API Response Types

### Define Response Shapes
`\tsx
interface TranscribeResponse {
  text: string;
}

interface AnalyzeResponse extends ScopeDocumentProps {}

// Usage
const response = await fetch('/api/transcribe', { method: 'POST', body: form });
const data: TranscribeResponse = await response.json();
`

## Utility Types

### Use Built-in Utility Types
`\tsx
// Pick specific properties
type CustomerInfo = Pick<ScopeDocumentProps, 'customer_name' | 'customer_contact'>;

// Make all properties optional
type PartialSettings = Partial<SettingsData>;

// Make all properties required
type RequiredSettings = Required<SettingsData>;

// Exclude properties
type OmitCustomer = Omit<ScopeDocumentProps, 'customer_name' | 'customer_contact'>;
`

## Type Guards

### Check for null/undefined
`\tsx
if (scopeData === null) {
  return <div>No data</div>;
}

// Now scopeData is not null
return <div>{scopeData.reference_number}</div>;
`

### Type predicates
`\tsx
function isError(value: unknown): value is Error {
  return value instanceof Error;
}

// Usage
if (isError(error)) {
  console.error(error.message);
}
`

## Enums vs Union Types

### Prefer Union Types
`\tsx
// Good
type State = 'idle' | 'recording' | 'processing';

// Avoid enums unless necessary
enum State {
  Idle = 'idle',
  Recording = 'recording',
}
`

## Generic Types

### Use When Reusable
`\tsx
interface ApiResponse<T> {
  data: T;
  error: string | null;
}

// Usage
type DocumentResponse = ApiResponse<ScopeDocumentProps>;
type TranscriptResponse = ApiResponse<string>;
`

## Type Assertions

### Use \tas Sparingly
`\tsx
// Acceptable when you know better than TypeScript
const settings = JSON.parse(stored) as SettingsData;

// Avoid when possible - prefer type guards
if (typeof value === 'string') {
  // TypeScript knows value is string here
}
`

### Never use \tany
`\tsx
// Bad
function process(data: any) {}

// Good - use unknown and narrow
function process(data: unknown) {
  if (typeof data === 'string') {
    // Now data is string
  }
}
`

## Const Assertions

### For Immutable Objects
`\tsx
const CONTRACTOR_INFO = {
  businessName: 'Cabinet Craft',
  phone: '289 923 9595',
  email: 'info@cabinetcraft.ca',
} as const;

// Now all properties are readonly
`

## Function Return Types

### Explicit for Exported Functions
`\tsx
// Good - explicit return type
export function formatPrice(price: number): string {
  return new Intl.NumberFormat('en-CA', {
    style: 'currency',
    currency: 'CAD',
  }).format(price);
}

// Acceptable for internal functions
const helper = (x: number) => x * 2; // return type inferred
`

## Async Functions

### Always type Promise returns
`\tsx
async function fetchData(): Promise<ScopeDocumentProps> {
  const res = await fetch('/api/data');
  return res.json();
}
`

## Common Patterns in This Project

### Settings Data
`\tsx
interface SettingsData {
  businessName: string;
  phone: string;
  email: string;
  taxRate: number;
  taxLabel: string;
}
`

### Cost Breakdown
`\tsx
export interface CostBreakdown {
  materials_cost: number | null;
  labor_cost: number | null;
  tax_amount: number | null;
  total: number | null;
}
`

### Payment Terms
`\tsx
export interface PaymentTerms {
  deposit_percentage: number | null;
  deposit_amount: number | null;
  payment_schedule: string[];
  payment_method: string | null;
}
`

## Type Safety Rules

1. ✅ **Always define prop types** for components
2. ✅ **Use strict null checks** (| null when appropriate)
3. ✅ **Type event handlers** correctly
4. ✅ **Avoid \tany** - use unknown instead
5. ✅ **Use utility types** (Partial, Pick, Omit) when appropriate
6. ❌ **Don't use enums** unless absolutely necessary
7. ❌ **Don't use type assertions** unless unavoidable
8. ❌ **Don't disable type checking** with @ts-ignore

## tsconfig.json Settings

Our strict settings:
`json
{
  'strict': true,
  'noEmit': true,
  'esModuleInterop': true,
  'skipLibCheck': true,
  'forceConsistentCasingInFileNames': true
}
`
