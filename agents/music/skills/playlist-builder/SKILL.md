---
name: playlist-builder
description: Build curated playlists on Spotify based on mood, activity, occasion, or taste exploration. Creates real Spotify playlists and tracks them in memory.
version: 2.0.0
metadata:
  openclaw:
    requires:
      env:
        - SPOTIFY_CLIENT_ID
        - SPOTIFY_CLIENT_SECRET
        - SPOTIFY_REFRESH_TOKEN
      bins:
        - curl
        - jq
---

# Playlist Builder Skill

Create thoughtful, well-sequenced playlists — and push them directly to Hugo's Spotify.

## When to Use
- Hugo asks for a playlist ("make me a playlist for...")
- Hugo asks for track recommendations for a specific mood, activity, or occasion
- Hugo says "what should I listen to right now?"
- Hugo wants to refresh or update an existing playlist
- Triggered by heartbeat for weekly discovery drops

## Spotify Script
```bash
SPOTIFY="~/.openclaw/skills/spotify-integration/scripts/spotify.sh"
```

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

### 2. Source Tracks Using Spotify

**From Hugo's taste (known good):**
```bash
$SPOTIFY top-tracks 50 medium_term          # his current favorites
$SPOTIFY saved-tracks 50                    # recently liked
$SPOTIFY recently-played 50                 # recent listens
```

**From Spotify recommendations (discovery):**
```bash
# Seed with Hugo's known artists + target mood parameters
$SPOTIFY recommendations "seed_artists=5INjqkS1o8h1imAzPqGZBb,4tZwfgrHOc3mvqYlEYSvVi&target_energy=0.7&target_danceability=0.6"

# For genre-specific:
$SPOTIFY recommendations "seed_genres=house,electronic&target_energy=0.8&min_tempo=120&max_tempo=130"
```

**From artist exploration:**
```bash
$SPOTIFY related-artists <artist_id>       # discover adjacent artists
$SPOTIFY artist-top-tracks <artist_id>     # get their best tracks
```

**Quality check tracks with audio features:**
```bash
$SPOTIFY audio-features <track_id>         # verify energy, BPM, danceability match
```

### 3. Sequence with Intent
- Check BPM and energy via audio-features to ensure smooth flow
- Group by energy — don't whiplash between a blues ballad and 130 BPM techno
- Use transitions: ending one track should feel natural flowing into the next
- Mix eras if appropriate — a classic track next to a modern one with similar DNA
- Balance: ~60% known favorites, ~30% taste-adjacent discovery, ~10% wildcards

### 4. Create on Spotify

```bash
# Create the playlist
$SPOTIFY create-playlist "Late Night Grooves" "Deep house and electronic for after midnight — curated by 🎧"
# Returns: { id: "abc123", name: "...", external_urls: "https://open.spotify.com/playlist/abc123" }

# Add tracks (collect all track URIs first)
$SPOTIFY add-to-playlist "abc123" "spotify:track:id1,spotify:track:id2,spotify:track:id3"
```

### 5. Present the Playlist

Format for output (include the Spotify link!):
```markdown
# [Playlist Name]
> [One-line description / mood]
> 🔗 [Spotify Link]

| # | Artist | Track | BPM~ | Notes |
|---|--------|-------|------|-------|
| 1 | [artist] | [track] | [bpm] | [opener — sets the tone] |
| 2 | [artist] | [track] | [bpm] | [builds from opener] |
...

**Duration**: ~[XX] min
**Vibe arc**: [e.g., "Slow burn → peak energy → mellow close"]
```

### 6. Save to Memory
Write to `memory/playlists/[playlist-name-slug].md`:
```markdown
# [Playlist Name]
- Created: YYYY-MM-DD
- Spotify ID: [playlist_id]
- Spotify URL: [url]
- Mood/Purpose: [description]
- Duration: ~[XX] min
- Track count: [n]
- Status: active

## Tracklist
[same table as above, including track IDs and URIs]

## Feedback
<!-- Updated when Hugo reacts -->
```

## Playlist Types

### Mood Playlists
Built around a feeling: "something dark and groovy", "uplifting energy", "Sunday morning calm"
- Lean heavily on taste profile mood-genre mapping
- Use Spotify recommendations with mood-tuning params: target_valence, target_energy, target_danceability

### Activity Playlists
Built for a context: "gym session", "deep work", "cooking dinner", "pre-going-out"
- Match energy to activity via audio features
- For focus: high instrumentalness, steady tempo, target_speechiness < 0.1
- For gym: high energy (0.8+), driving rhythms
- For going out: build anticipation, target_danceability > 0.7

### Discovery Playlists
Designed to expand Hugo's taste:
- Use `$SPOTIFY related-artists` to find adjacent artists
- Use `$SPOTIFY recommendations` with less familiar seeds
- 60% familiar territory, 30% adjacent exploration, 10% wildcard
- Flag the wildcards: "this one's a stretch but hear me out"

### Occasion Playlists
For specific events: "dinner party", "road trip", "house party"
- Consider the audience (not just Hugo's taste)
- Lean accessible while keeping taste integrity

## Refreshing a Playlist

When updating an existing playlist:
1. Read the current playlist from `memory/playlists/`
2. Use the stored Spotify ID to pull current state: `$SPOTIFY get-playlist <id>`
3. Check feedback section for what worked and what didn't
4. Keep the bangers (tracks Hugo loved)
5. Swap out tracks that got stale — use `$SPOTIFY add-to-playlist` and Spotify's API for removals
6. Add recent discoveries that fit the playlist's vibe
7. Maintain the energy arc
8. Update the memory file

## Output Style
- Always include the Spotify link so Hugo can play it immediately
- Lead with the playlist name and vibe, not a wall of text
- If it's a long playlist (15+ tracks), highlight 3-4 standout picks
- Offer to adjust: "Want me to make it more [X] or less [Y]?"
- After Hugo listens, ask for feedback to improve future playlists
