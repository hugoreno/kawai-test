---
name: playlist-builder
description: Build curated playlists based on mood, activity, occasion, or taste exploration. Track playlists and suggest refreshes over time.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Playlist Builder Skill

Create thoughtful, well-sequenced playlists.

## When to Use
- Hugo asks for a playlist ("make me a playlist for...")
- Hugo asks for track recommendations for a specific mood, activity, or occasion
- Hugo says "what should I listen to right now?"
- Hugo wants to refresh or update an existing playlist
- Triggered by heartbeat for weekly discovery drops

## Playlist Philosophy

A playlist is not a random dump of tracks. It tells a story:
- **Opening**: set the tone, ease in
- **Build**: develop energy and theme
- **Peak**: the centerpiece tracks, highest energy or emotional impact
- **Cool-down**: bring it back, leave a lasting impression

Think like a DJ building a set, not an algorithm shuffling songs.

## Building a Playlist

### 1. Understand the Request
Clarify if not obvious:
- **Mood/vibe**: chill, energetic, dark, euphoric, introspective
- **Activity**: working, running, cooking, going out, road trip, dinner party
- **Duration**: how long? (default: 45-60 min, ~12-18 tracks)
- **Genre constraints**: stick to one genre or cross-pollinate?

### 2. Source Tracks
Pull from multiple inputs:
- Hugo's taste profile (`memory/TASTE_PROFILE.md`) — favorite artists, liked tracks, genre affinities
- Previous discoveries that landed well (`memory/discoveries/`)
- Genre knowledge and cross-genre connections
- Balance familiar (artists Hugo knows) with discovery (new finds)

### 3. Sequence with Intent
- Consider key compatibility and BPM flow between tracks
- Group by energy — don't whiplash between a blues ballad and a 130 BPM techno track
- Use transitions: ending one track should feel natural flowing into the next
- Mix eras if appropriate — a classic track next to a modern one with similar DNA

### 4. Present the Playlist

Format for output:
```markdown
# [Playlist Name]
> [One-line description / mood]

| # | Artist | Track | Genre | BPM~ | Notes |
|---|--------|-------|-------|------|-------|
| 1 | [artist] | [track] | [genre] | [bpm] | [opener — sets the tone] |
| 2 | [artist] | [track] | [genre] | [bpm] | [builds from opener] |
...

**Duration**: ~[XX] min
**Vibe arc**: [e.g., "Slow burn → peak energy → mellow close"]
```

### 5. Save to Memory
Write to `memory/playlists/[playlist-name-slug].md`:
```markdown
# [Playlist Name]
- Created: YYYY-MM-DD
- Mood/Purpose: [description]
- Duration: ~[XX] min
- Track count: [n]
- Status: active

## Tracklist
[same table as above]

## Feedback
<!-- Updated when Hugo reacts:
- [date]: [feedback — e.g., "loved tracks 3 and 7, track 5 didn't fit"]
-->
```

## Playlist Types

### Mood Playlists
Built around a feeling: "something dark and groovy", "uplifting energy", "Sunday morning calm"
- Lean heavily on taste profile mood-genre mapping
- Keep genre cohesive or intentionally cross-genre

### Activity Playlists
Built for a context: "gym session", "deep work", "cooking dinner", "pre-going-out"
- Match energy to activity demands
- For focus: avoid vocals, keep it steady, no jarring transitions
- For gym: high energy, driving rhythms, build intensity
- For going out: build anticipation, club-ready energy

### Discovery Playlists
Designed to expand Hugo's taste:
- 60% familiar territory (known genres/artists)
- 30% adjacent exploration (related genres, collaborators, influences)
- 10% wildcard (something from left field that might land)
- Flag the wildcards: "this one's a stretch but hear me out"

### Occasion Playlists
For specific events: "dinner party", "road trip", "house party"
- Consider the audience (not just Hugo's taste but the vibe for the group)
- Lean accessible while keeping taste integrity

## Refreshing a Playlist

When updating an existing playlist:
1. Read the current playlist from `memory/playlists/`
2. Check feedback section for what worked and what didn't
3. Keep the bangers (tracks Hugo loved)
4. Swap out tracks that got stale or didn't land
5. Add recent discoveries that fit the playlist's vibe
6. Maintain the energy arc — don't just swap randomly
7. Update the file with new tracks and date of refresh

## Output Style
- Lead with the playlist name and vibe, not a wall of text
- If it's a long playlist (15+ tracks), highlight 3-4 standout picks
- Offer to adjust: "Want me to make it more [X] or less [Y]?"
- After Hugo listens, ask for feedback to improve future playlists
