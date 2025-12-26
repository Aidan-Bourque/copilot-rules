---
description: UI patterns and component guidelines for ScopeGuard
globs: app/components/**/*.tsx,app/**/*page.tsx
alwaysApply: false
---

# UI Patterns - ScopeGuard

## Design System

### Brand Colors

` sx
// Primary (red)
className='bg-[#dc2626] text-white' // Solid background
className='text-[#dc2626]' // Text
className='border-[#dc2626]' // Border

// Accent (lighter red)
className='bg-[#ef4444]' // Hover states
className='text-[#ef4444]' // Lighter text

// Semantic colors
className='text-foreground' // Primary text
className='bg-background' // Background
className='text-foreground/60' // Muted text
className='bg-foreground/5' // Subtle background
`

### Spacing

` sx
// Padding
className='p-4' // 16px
className='px-6' // Horizontal 24px
className='py-3' // Vertical 12px

// Margin
className='mt-8' // Top 32px
className='mb-12' // Bottom 48px
className='gap-3' // Flexbox gap 12px
`

### Borders

` sx
// Standard border
className='border border-(--foreground)/10'

// Hover border
className='border-(--foreground)/10 hover:border-[#dc2626]/50'

// Rounded corners
className='rounded-lg' // 8px
className='rounded-xl' // 12px
className='rounded-full' // Circle/pill
`

## Component Patterns

### Buttons

#### Primary Button

` sx
<button
type='button'
onClick={handleClick}
disabled={isLoading}
className='flex items-center justify-center gap-2 rounded-lg bg-[#dc2626] px-4 py-3 font-medium text-white transition-all hover:bg-[#ef4444] disabled:opacity-50 disabled:hover:bg-[#dc2626]'

>   <Icon className='h-5 w-5' />
>   Button Text
> </button>
> `

#### Secondary Button

` sx
<button
type='button'
onClick={handleClick}
className='rounded-lg border border-(--foreground)/20 px-4 py-2.5 text-sm text-(--foreground)/60 transition-all hover:border-(--foreground)/40 hover:text-(--foreground)/80'

> Secondary Action
> </button>
> `

#### Icon Button

` sx
<button
type='button'
className='rounded-lg border border-(--foreground)/10 bg-(--foreground)/5 p-2 transition-all hover:border-[#dc2626]/50 hover:bg-[#dc2626]/10'

>   <Icon className='h-5 w-5 text-(--foreground)/60' />
> </button>
> `

### Inputs

#### Text Input

`\tsx
<input
  type='text'
  value={value}
  onChange={(e) => setValue(e.target.value)}
  className='w-full rounded-lg border border-(--foreground)/20 bg-(--foreground)/5 px-4 py-2.5 text-foreground placeholder:text-(--foreground)/30 focus:border-[#dc2626]/50 focus:outline-none focus:ring-2 focus:ring-[#dc2626]/20'
  placeholder='Placeholder text'
/>
`

#### Textarea

`\tsx
<textarea
  value={value}
  onChange={(e) => setValue(e.target.value)}
  className='h-48 w-full resize-none rounded-xl border border-(--foreground)/10 bg-(--foreground)/5 p-4 text-(--foreground)/90 placeholder:text-(--foreground)/30 focus:border-[#dc2626]/50 focus:outline-none focus:ring-2 focus:ring-[#dc2626]/20'
  rows={4}
/>
`

### Cards

#### Standard Card

` sx

<div className='rounded-xl border border-(--foreground)/10 bg-(--foreground)/5 p-6'>
  <h2 className='mb-4 text-xl font-semibold text-foreground'>Card Title</h2>
  <p className='text-(--foreground)/80'>Card content</p>
</div>
`

#### Highlighted Card (Brand Color)

` sx

<div className='rounded-xl border border-[#dc2626]/30 bg-[#dc2626]/5 p-6'>
  <div className='flex items-center gap-2'>
    <CheckCircle className='h-4 w-4 text-[#dc2626]' />
    <span className='text-xs font-medium uppercase tracking-wider text-[#dc2626]'>
      Highlighted
    </span>
  </div>
  <p className='mt-3 text-(--foreground)/80'>Content</p>
</div>
`

### Alerts

#### Error Alert

` sx

<div className='rounded-lg border border-amber-500/30 bg-amber-500/10 p-4'>
  <div className='flex items-start gap-3'>
    <AlertTriangle className='h-5 w-5 shrink-0 text-amber-600' />
    <div>
      <p className='text-amber-900 dark:text-amber-200'>{error}</p>
    </div>
  </div>
</div>
`

#### Success Alert

` sx

<div className='rounded-lg border border-green-500/30 bg-green-500/10 p-4'>
  <div className='flex items-center gap-2'>
    <div className='h-2 w-2 rounded-full bg-green-500' />
    <span className='font-medium text-green-700 dark:text-green-400'>
      Success message
    </span>
  </div>
</div>
`

### Loading States

#### Spinner

` sx

<div className='h-8 w-8 animate-spin rounded-full border-4 border-(--foreground)/30 border-t-foreground' />
`

#### Button Loading

`\tsx
<button disabled={isLoading} className='...'>
  {isLoading ? (
    <>
      <div className='h-4 w-4 animate-spin rounded-full border-2 border-white/30 border-t-white' />
      Loading...
    </>
  ) : (
    'Submit'
  )}
</button>
`

### Badges

#### Status Badge

`\tsx
<span className='rounded bg-(--foreground)/5 px-2 py-1 font-mono text-xs text-(--foreground)/70'>
  REF-001
</span>
`

#### Colored Badge

`\tsx
<span className='rounded-lg bg-[#dc2626]/10 px-3 py-2.5 font-mono text-sm font-medium text-[#dc2626]'>
  13.00%
</span>
`

## Layout Patterns

### Centered Container

` sx

<div className='mx-auto w-full max-w-2xl'>
  {/* Content */}
</div>
`

### Full Height Page

` sx

<div className='relative flex min-h-screen flex-col items-center justify-center bg-background px-6 py-12'>
  {/* Content */}
</div>
`

### Background Gradient

` sx

<div className='pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_at_center,rgba(220,38,38,0.12)_0%,transparent_70%)]' />
`

## Icons (Lucide React)

### Standard Usage

` sx
import { Mic, Download, Settings } from 'lucide-react';

<Mic className='h-5 w-5' />
<Download className='h-4 w-4' />
<Settings className='h-6 w-6' />
`

### Colored Icons

`\tsx
<CheckCircle className='h-4 w-4 text-[#dc2626]' />
<AlertTriangle className='h-5 w-5 text-amber-600' />
`

## Responsive Design

### Mobile-First Approach

` sx
// Base (mobile)
className='px-4'

// Tablet and up
className='px-4 md:px-8'

// Desktop
className='px-4 md:px-8 lg:px-12'
`

### Hide/Show Based on Screen Size

`\tsx
className='hidden md:block'  // Hidden on mobile, visible on tablet+
className='block md:hidden'  // Visible on mobile, hidden on tablet+
`

## Dark Mode

### Use Semantic Variables

` sx
// Good - adapts automatically
className='text-(--foreground) bg-background'

// Bad - hardcoded
className='text-gray-900 bg-white'
`

### Dark Mode Specific

` sx
className='text-(--foreground)/80 dark:text-(--foreground)/60'
className='bg-amber-50 dark:bg-amber-500/10'
`

## Transitions

### Standard Transition

` sx
className='transition-all'
className='transition-colors duration-200'
`

### Hover Effects

` sx
className='hover:bg-(--foreground)/15 transition-all'
className='hover:scale-105 transition-transform'
`

## Accessibility

### Button Accessibility

` sx
<button
type='button'
aria-label='Record audio'
disabled={isDisabled}

>   <Mic aria-hidden='true' />
> </button>
> `

### Form Labels

`\tsx
<label htmlFor='email' className='mb-2 block text-sm font-medium'>
  Email Address
</label>
<input id='email' type='email' />
`

## Common Patterns in This Project

### Page Header

` sx

<div className='mb-8'>
  <h1 className='text-3xl font-bold text-foreground'>Page Title</h1>
  <p className='mt-1 text-(--foreground)/60'>Description text</p>
</div>
`

### Section Title

` sx

<h2 className='mb-4 text-xl font-semibold text-foreground'>
  Section Title
</h2>
`

### Info Box

` sx

<div className='rounded-lg border border-(--foreground)/10 bg-(--foreground)/5 p-3'>
  <div className='mb-2 text-xs font-medium uppercase tracking-wider text-(--foreground)/75'>
    Label
  </div>
  <div className='space-y-1.5'>
    {/* Content */}
  </div>
</div>
`

## Best Practices

1. ✅ **Use semantic color variables** for dark mode support
2. ✅ **Include disabled states** for all interactive elements
3. ✅ **Add transitions** for hover/focus states
4. ✅ **Use Lucide React** for all icons
5. ✅ **Include aria-labels** for icon-only buttons
6. ✅ **Make forms accessible** with labels and proper types
7. ❌ **Don't use inline styles** (use Tailwind classes)
8. ❌ **Don't hardcode colors** (use theme variables)
