---
name: taste-learning
description: Learn and refine the user's music taste from conversations, Spotify listening data, and reactions to recommendations. Maintain an evolving taste profile.
version: 2.0.0
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
- On profile refresh: pull fresh data from Spotify to keep taste profile current

## Spotify Integration

Use the Spotify API script to ground taste learning in real listening data:

```bash
SPOTIFY="~/.openclaw/skills/spotify-integration/scripts/spotify.sh"
```

### Initial Profile Seeding
When the taste profile is mostly empty or contains "[to be learned]" entries, seed it from Spotify:
```bash
$SPOTIFY top-artists 50 long_term      # all-time favorite artists
$SPOTIFY top-artists 20 medium_term    # 6-month favorites
$SPOTIFY top-artists 20 short_term     # current rotation (last 4 weeks)
$SPOTIFY top-tracks 50 long_term       # all-time top tracks
$SPOTIFY top-tracks 20 short_term      # current heavy rotation
$SPOTIFY saved-tracks 50              # recently liked tracks
```

Cross-reference all three time ranges to identify:
- **Core artists**: appear in long_term AND medium_term (deep loyalty)
- **Current obsessions**: appear in short_term but not long_term (new discovery)
- **Fading interests**: appear in long_term but not short_term (less active)

### Ongoing Taste Updates
Periodically (weekly or when asked), refresh with:
```bash
$SPOTIFY recently-played 50            # what Hugo's actually been listening to
$SPOTIFY top-artists 10 short_term     # current top rotation
$SPOTIFY now-playing                   # real-time context
```

### Getting Artist Detail
When you identify an artist from Spotify data and want genre info:
```bash
$SPOTIFY artist <artist_id>            # returns genres, popularity, followers
$SPOTIFY related-artists <artist_id>   # find the taste cluster
```

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

### Spotify-Derived Signals
From actual listening behavior:
- High play count on an artist → strong implicit positive (even if never mentioned)
- Recently played at specific times → mood-time mapping
- Saved/liked tracks → confirmed positive signal
- Audio features patterns → energy/mood preferences (use `$SPOTIFY audio-features <id>`)

### Contextual Signals
When and how Hugo listens:
- "I listen to X when working" → Focus mood map
- "This is my gym playlist" → Gym mood map
- "Perfect for going out" → Going out mood map

## Processing a Taste Signal

1. **Identify the signal**: what did Hugo say or what does Spotify data show?
2. **Classify strength**: loved > liked > neutral > disliked > hated
3. **Extract dimensions**: genre, subgenre, energy level, mood, production style, era
4. **Enrich with Spotify**: if signal mentions an artist/track, look up audio features and related artists
5. **Log to memory**: update the appropriate section in `memory/TASTE_PROFILE.md`
6. **Acknowledge naturally**: don't make it feel like data collection.

## Updating TASTE_PROFILE.md

### Favorite Artists
When Hugo expresses strong positive sentiment or Spotify shows high listening:
```markdown
- [Artist Name] — [genre tags] — Spotify ID: [id] — discovered [date] — "[brief context]"
```

### Liked Tracks
When Hugo explicitly likes a track or it appears in top tracks:
```markdown
- [Artist] — [Track] — Spotify ID: [id] — [date] — [context]
```

### Disliked / Skipped
When Hugo expresses negative sentiment:
```markdown
- [Artist/Track/Genre detail] — [date] — [why if stated]
```

### Taste Patterns
After accumulating 10+ signals, synthesize patterns. Use audio features to be specific:
```markdown
- Prefers deep, groovy house over vocal/commercial house
- Likes raw, analog-sounding production over polished/overproduced
- Average preferred BPM: 118-128 for electronic, 90-110 for rock
- High instrumentalness preference (0.6+) — prefers less vocals in electronic
- Energy sweet spot: 0.5-0.8 — groovy but not aggressive
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
   - Loved → more in this direction, seed future recs with this artist/track
   - Liked → on the right track
   - Meh → adjust parameters (maybe right genre, wrong energy/mood)
   - Disliked → note the miss, understand why

## Output
- Don't announce "I'm updating your taste profile" — just do it naturally.
- If Hugo shares a strong opinion, engage with it conversationally.
- When synthesizing patterns, share insights: "I'm noticing you gravitate toward [pattern] — that tracks."
- When seeding from Spotify, summarize what you learned: "Based on your Spotify, you're deep into [X] lately, but your all-time rotation is more [Y]."
