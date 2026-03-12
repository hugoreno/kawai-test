---
name: taste-learning
description: Learn and refine the user's music taste from conversations, reactions to recommendations, and explicit preferences. Maintain an evolving taste profile.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Taste Learning Skill

Build and maintain a deep understanding of Hugo's music taste.

## When to Use
- Hugo mentions liking or disliking a song, artist, album, or genre
- Hugo reacts to a recommendation (loved it, skipped it, it was okay)
- Hugo talks about a concert, DJ set, or music experience
- Hugo asks "find me something like X" (extract the taste signal, then hand off to playlist-builder)
- Called internally after playlist-builder or show-finder to log reactions

## Taste Signal Types

### Explicit Signals
Direct statements of preference:
- "I love [artist]" → strong positive, log to Favorite Artists
- "Not a fan of [genre/artist]" → negative, log to Disliked
- "This track is amazing" → strong positive, log to Liked Tracks
- "Skip" or "meh" → mild negative, log to Disliked

### Implicit Signals
Inferred from conversation context:
- Asking for more from a specific artist/genre → positive affinity
- Describing a mood and associating it with music → mood-genre mapping
- Mentioning a show they went to → artist interest confirmed
- Talking about a DJ set they enjoyed → subgenre/style signal

### Contextual Signals
When and how Hugo listens:
- "I listen to X when working" → Focus mood map
- "This is my gym playlist" → Gym mood map
- "Perfect for going out" → Going out mood map

## Processing a Taste Signal

1. **Identify the signal**: what did Hugo say, and what does it tell us about taste?
2. **Classify strength**: loved > liked > neutral > disliked > hated
3. **Extract dimensions**: genre, subgenre, energy level, mood, production style, era
4. **Log to memory**: update the appropriate section in `memory/TASTE_PROFILE.md`
5. **Acknowledge naturally**: don't make it feel like data collection. "Nice, noted" or weave it into conversation.

## Updating TASTE_PROFILE.md

### Favorite Artists
When Hugo expresses strong positive sentiment about an artist:
```markdown
- [Artist Name] — [genre tags] — discovered [date] — "[brief context]"
```

### Liked Tracks
When Hugo explicitly likes a specific track:
```markdown
- [Artist] — [Track] — [date] — [context: recommended by curator / found on their own / heard live]
```

### Disliked / Skipped
When Hugo expresses negative sentiment:
```markdown
- [Artist/Track/Genre detail] — [date] — [why if stated, e.g., "too commercial", "boring drop"]
```

### Taste Patterns
After accumulating 10+ signals, synthesize patterns:
- Look for common threads across liked items (tempo range, production style, era, mood)
- Note anti-patterns from dislikes (what to avoid)
- Update the Taste Patterns section with specific, actionable insights

Example:
```markdown
- Prefers deep, groovy house over vocal/commercial house
- Likes raw, analog-sounding production over polished/overproduced
- Blues appreciation focuses on guitar-driven, emotionally expressive playing
- Rock taste leans toward garage, psych, and blues-rock over pop-rock or metal
```

### Mood-Genre Map
Map listening contexts to preferred styles:
```markdown
- Focus: deep house, ambient electronic, minimal techno
- Going out: tech house, techno, high-energy electronic
- Gym: rock, high-BPM electronic, aggressive house
- Unwinding: blues, downtempo, jazz-adjacent electronic
```

## Recommendation Feedback Loop

When Hugo reacts to a previous recommendation:
1. Log the reaction in `memory/discoveries/YYYY-MM-DD.md` (update existing entry)
2. Adjust taste profile if the reaction reveals something new
3. Use feedback to calibrate future recommendations:
   - Loved → more in this direction
   - Liked → on the right track
   - Meh → adjust parameters (maybe right genre, wrong energy/mood)
   - Disliked → note the miss, understand why

## Output
- Don't announce "I'm updating your taste profile" — just do it naturally.
- If Hugo shares a strong opinion, engage with it: "Yeah, [artist] is incredible. Have you heard their earlier stuff?"
- When synthesizing patterns, share insights conversationally: "I'm noticing you gravitate toward [pattern] — that tracks."
