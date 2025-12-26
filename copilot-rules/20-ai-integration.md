---
description: OpenAI API integration patterns and best practices for ScopeGuard
globs: app/api/**/*.ts
alwaysApply: false
---

# AI Integration Patterns - ScopeGuard

## OpenAI API Setup

### Environment Variables
`env
# .env.local (never commit this file)
OPENAI_API_KEY=sk-...
`

### API Configuration
`\typescriptt
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});
`

## Transcription API (/api/transcribe)

### Current Implementation Pattern
`\typescriptt
import { NextRequest, NextResponse } from 'next/server';
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export async function POST(request: NextRequest) {
  try {
    const formData = await request.formData();
    const audio = formData.get('audio') as File;

    if (!audio) {
      return NextResponse.json(
        { error: 'No audio file provided' },
        { status: 400 }
      );
    }

    const transcription = await openai.audio.transcriptions.create({
      file: audio,
      model: 'whisper-1',
      language: 'en', // Optional: specify language for better accuracy
    });

    return NextResponse.json({ text: transcription.text });
  } catch (error) {
    console.error('Transcription error:', error);
    return NextResponse.json(
      { error: 'Transcription failed' },
      { status: 500 }
    );
  }
}
`

### Best Practices

1. **Validate File Size** (Whisper limit: 25MB)
`\typescriptt
if (audio.size > 25 * 1024 * 1024) {
  return NextResponse.json(
    { error: 'File too large. Max size: 25MB' },
    { status: 400 }
  );
}
`

2. **Validate File Type**
`\typescriptt
const allowedTypes = ['audio/webm', 'audio/mpeg', 'audio/wav', 'audio/mp4'];
if (!allowedTypes.includes(audio.type)) {
  return NextResponse.json(
    { error: 'Invalid audio format' },
    { status: 400 }
  );
}
`

3. **Add Timeout Handling**
`\typescriptt
const controller = new AbortController();
const timeout = setTimeout(() => controller.abort(), 60000); // 60s

try {
  const transcription = await openai.audio.transcriptions.create(
    { file: audio, model: 'whisper-1' },
    { signal: controller.signal }
  );
  clearTimeout(timeout);
  // ...
} catch (error) {
  clearTimeout(timeout);
  // Handle error
}
`

## Analysis API (/api/analyze)

### Current Implementation Pattern
`\typescriptt
export async function POST(request: NextRequest) {
  try {
    const { transcription } = await request.json();

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o',
      messages: [
        {
          role: 'system',
          content: You are an expert at extracting structured data from contractor-customer conversations...,
        },
        {
          role: 'user',
          content: transcription,
        },
      ],
      response_format: { type: 'json_object' },
      temperature: 0.3, // Lower = more consistent
    });

    const result = JSON.parse(completion.choices[0].message.content);
    return NextResponse.json(result);
  } catch (error) {
    console.error('Analysis error:', error);
    return NextResponse.json(
      { error: 'Analysis failed' },
      { status: 500 }
    );
  }
}
`

### Prompt Engineering Best Practices

#### 1. Be Specific About Format
`\typescriptt
const systemPrompt = Extract the following information in JSON format:
{
  'scope_of_work': 'detailed description',
  'materials': 'list of materials',
  'cost_breakdown': {
    'materials_cost': number or null,
    'labor_cost': number or null,
    'tax_amount': number or null,
    'total': number or null
  }
};
`

#### 2. Handle Edge Cases
`\typescriptt
const systemPrompt = ...
If a field cannot be determined, set it to null.
For prices, extract numeric values only (remove currency symbols).
For dates, use natural language format (e.g., 'Within 2 weeks').
;
`

#### 3. Provide Examples (Few-Shot Learning)
`\typescriptt
const systemPrompt = ...
Example input: 'Replace kitchen faucet for  including parts'
Example output: {
  'scope_of_work': 'Replace kitchen faucet',
  'materials': 'Kitchen faucet and installation parts',
  'cost_breakdown': {
    'materials_cost': 200,
    'labor_cost': 150,
    'total': 350
  }
};
`

#### 4. Relevance Filtering
`\typescriptt
const systemPrompt = ...
IMPORTANT: Only process conversations related to contractor work, quotes, or job estimates.
If the input is not relevant (e.g., casual conversation, unrelated topics), return:
{ 'error': 'irrelevant_input', 'message': 'This does not appear to be a contractor conversation' }
;
`

### Response Validation

#### Parse and Validate JSON
`\typescriptt
let result;
try {
  result = JSON.parse(completion.choices[0].message.content);
} catch {
  return NextResponse.json(
    { error: 'Invalid JSON response from AI' },
    { status: 500 }
  );
}

// Check for error response
if (result.error === 'irrelevant_input') {
  return NextResponse.json(
    { error: 'irrelevant_input', message: result.message },
    { status: 400 }
  );
}
`

#### Add Required Fields
`\typescriptt
// Ensure reference number
if (!result.reference_number) {
  result.reference_number = SGD-;
}

// Ensure cost breakdown structure
if (!result.cost_breakdown) {
  result.cost_breakdown = {
    materials_cost: null,
    labor_cost: null,
    tax_amount: null,
    total: null,
  };
}
`

## Error Handling

### Client-Side Error Messages
`\typescriptt
try {
  const res = await fetch('/api/analyze', { ... });
  
  if (!res.ok) {
    const errorData = await res.json().catch(() => ({}));
    
    if (errorData.error === 'irrelevant_input') {
      setError('This doesn't appear to be a contractor conversation...');
      return;
    }
    
    throw new Error('Analysis failed');
  }
  
  const data = await res.json();
  // Process data
} catch (error) {
  if (error.message.includes('API key')) {
    setError('OpenAI API key not configured');
  } else {
    setError('Failed to generate document. Please try again.');
  }
}
`

### Server-Side Error Logging
`\typescriptt
catch (error) {
  // Log detailed error for debugging
  console.error('OpenAI API error:', {
    message: error instanceof Error ? error.message : 'Unknown error',
    code: error?.code,
    status: error?.status,
  });
  
  // Return user-friendly error
  return NextResponse.json(
    { error: 'Analysis failed' },
    { status: 500 }
  );
}
`

## Cost Optimization

### 1. Use Appropriate Models
`\typescriptt
// Transcription: Only one model available
model: 'whisper-1' // ~.006 per minute

// Analysis: Choose based on complexity
model: 'gpt-4o'     // Best quality, higher cost
model: 'gpt-4o-mini' // Good quality, lower cost (future)
model: 'gpt-3.5-turbo' // Fast, cheapest (may lack accuracy)
`

### 2. Reduce Token Usage
`\typescriptt
// Use lower temperature for consistency
temperature: 0.3,

// Limit output tokens if possible
max_tokens: 2000,

// Use concise prompts
const systemPrompt = Extract data from contractor conversation in JSON...;
// vs overly verbose prompts
`

### 3. Cache Responses (Future)
`\typescriptt
// Store transcriptions to avoid re-transcribing
// Store common analysis results
// Implement Redis/database cache
`

## Rate Limiting (Future Implementation)

### Per-User Limits
`\typescriptt
// Check rate limit before API call
const rateLimit = await checkUserRateLimit(userId);
if (!rateLimit.allowed) {
  return NextResponse.json(
    { error: 'Rate limit exceeded. Try again in 1 minute.' },
    { status: 429 }
  );
}
`

### Per-IP Limits (Current - No Auth)
`\typescriptt
import { RateLimiter } from 'limiter';

const limiter = new RateLimiter({ tokensPerInterval: 10, interval: 'minute' });

export async function POST(request: NextRequest) {
  const ip = request.ip ?? '127.0.0.1';
  const allowed = await limiter.removeTokens(1);
  
  if (!allowed) {
    return NextResponse.json(
      { error: 'Too many requests' },
      { status: 429 }
    );
  }
  
  // Process request
}
`

## Testing Considerations

### Mock Responses for Development
`\typescriptt
if (process.env.NODE_ENV === 'development' && process.env.MOCK_AI === 'true') {
  return NextResponse.json({
    scope_of_work: 'Mock scope of work',
    materials: 'Mock materials',
    cost_breakdown: { total: 1000 },
  });
}
`

### Log Prompts and Responses
`\typescriptt
if (process.env.NODE_ENV === 'development') {
  console.log('Prompt:', messages);
  console.log('Response:', result);
}
`

## Security Best Practices

1. ✅ **Never expose API key to client**
2. ✅ **Validate all inputs before sending to OpenAI**
3. ✅ **Sanitize user inputs** (remove malicious content)
4. ✅ **Set timeouts** to prevent hanging requests
5. ✅ **Log errors** (but not sensitive data)
6. ✅ **Implement rate limiting**
7. ✅ **Use structured outputs** (JSON mode) for safety
8. ❌ **Don't trust AI responses blindly** (always validate)
9. ❌ **Don't log API keys or user data**
10. ❌ **Don't allow arbitrary prompts from users**

## Model Selection Guide

| Task | Model | Reason |
|------|-------|--------|
| Transcription | whisper-1 | Only option, excellent quality |
| Simple extraction | gpt-4o-mini | Fast, cheap, sufficient accuracy |
| Complex extraction | gpt-4o | Best reasoning, handles edge cases |
| Structured output | Any with JSON mode | Ensures parseable responses |

## Future Enhancements

### Streaming Responses
`\typescriptt
const stream = await openai.chat.completions.create({
  model: 'gpt-4o',
  messages: [...],
  stream: true,
});

for await (const chunk of stream) {
  // Send chunks to client
}
`

### Function Calling
`\typescriptt
const completion = await openai.chat.completions.create({
  model: 'gpt-4o',
  messages: [...],
  tools: [
    {
      type: 'function',
      function: {
        name: 'calculate_tax',
        description: 'Calculate tax amount',
        parameters: { ... },
      },
    },
  ],
});
`

### Fine-Tuning (Advanced)
- Train model on contractor-specific conversations
- Improve extraction accuracy for industry jargon
- Reduce cost per request after training
