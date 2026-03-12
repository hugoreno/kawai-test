---
name: voice-learning
description: Learn and refine the user's writing voice from message examples, draft edits, and explicit style preferences. Maintain an evolving voice profile.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Voice Learning Skill

Build and maintain a deep understanding of Hugo's writing voice across all channels.

## When to Use
- Hugo shares examples of messages he's written (texts, emails, DMs)
- Hugo edits a draft you wrote — the delta is a style signal
- Hugo explicitly states a style preference ("I never use exclamation marks")
- Hugo reacts to a draft ("too formal", "perfect", "I'd never say that")
- Called internally after message-drafting to log style feedback

## Voice Signal Types

### Explicit Signals
Direct statements about writing style:
- "I always sign off with 'Best'" → log to Sign-offs
- "I never use emojis in work emails" → log to Channel Rules
- "I hate the word 'synergy'" → log to Blacklist
- "I text in all lowercase" → log to Formatting Patterns

### Edit Signals (highest value)
When Hugo modifies a draft you wrote:
- Shortened text → Hugo prefers more concise
- Changed greeting → log preferred greeting style
- Removed exclamation marks → note punctuation preference
- Added emoji → note emoji comfort by channel
- Rewrote a sentence → compare versions, extract the pattern

### Implicit Signals
Inferred from examples and reactions:
- Sentence length patterns across multiple messages
- Punctuation density and style (periods vs. no periods in texts)
- Capitalization habits (lowercase casual vs. proper)
- Emoji frequency and type preferences
- Greeting and sign-off patterns by relationship type

### Contextual Signals
How voice changes by situation:
- Professional vs. personal tone shifts
- How formality scales with relationship closeness
- Tone when delivering bad news vs. good news
- Response length by channel (texts short, emails longer)

## Processing a Voice Signal

1. **Identify the signal**: what did Hugo do or say that reveals a writing pattern?
2. **Classify by channel**: text, email, DM, Slack — voice may differ
3. **Classify by relationship**: friend, colleague, boss, stranger — tone shifts
4. **Extract the pattern**: what's the generalizable rule?
5. **Log to memory**: update the appropriate section in `memory/VOICE_PROFILE.md`
6. **Acknowledge naturally**: "Got it, no exclamation marks in work emails."

## Updating VOICE_PROFILE.md

### General Voice
Core patterns that apply across all channels:
```markdown
- Sentence length: [short/medium/long, average word count]
- Formality default: [casual/balanced/formal]
- Humor style: [dry/playful/none/situational]
- Directness: [very direct/balanced/soft]
```

### Channel-Specific Patterns
Per-channel voice details:
```markdown
## Texts
- Capitalization: [lowercase/normal/varies]
- Punctuation: [minimal/normal/heavy]
- Emoji use: [frequent/occasional/rare/never]
- Average length: [1-2 lines / 3-5 lines / longer]
- Greeting style: [none / "hey" / name / varies]

## Emails
- Greeting: [Hi X / Hey X / X, / Dear X]
- Sign-off: [Best / Thanks / Cheers / none]
- Structure: [single paragraph / multi-paragraph / bullet points]
- Formality range: [by recipient type]

## DMs
- Tone: [casual/semi-formal/varies]
- Response style: [quick and short / thoughtful / varies]
```

### Relationship-Based Tone Map
How Hugo writes to different people:
```markdown
- Close friends: [tone description, example patterns]
- Work colleagues: [tone description, example patterns]
- Boss/senior: [tone description, example patterns]
- Strangers/new contacts: [tone description, example patterns]
- Family: [tone description, example patterns]
```

### Blacklist (Never Say)
Words and phrases Hugo would never use:
```markdown
- [phrase] — [why, if stated]
```

### Signature Moves
Distinctive patterns that make Hugo's writing recognizable:
```markdown
- [pattern] — [context where it appears]
```

## Edit Analysis

When Hugo edits a draft:
1. Diff the original draft vs. Hugo's edited version
2. Categorize each change: tone, length, word choice, structure, punctuation, emoji
3. Log the pattern in `memory/drafts/YYYY-MM-DD.md`
4. If a pattern appears 3+ times, promote it to VOICE_PROFILE.md
5. Acknowledge: "Noted — you prefer [pattern]. I'll do that from now on."

## Output
- Don't announce "I'm updating your voice profile" — keep it light.
- When you learn something, confirm briefly: "Got it, lowercase in texts."
- When sharing a pattern back: "I've noticed you never use exclamation marks with [person]. Intentional?"
- Periodically share discoveries: "Your texts average 8 words. You're a minimalist."
