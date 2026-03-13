---
name: spotify-integration
description: Interface with Spotify API to read listening data, search music, create playlists, and get recommendations. This is a tool skill — other skills (taste-learning, playlist-builder, show-finder) call into it.
version: 1.0.0
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
        - python3
---

# Spotify Integration Skill

Interface with Spotify to read Hugo's listening data, search for music, create playlists, and get personalized recommendations.

## Script Location
```
~/.openclaw/skills/spotify-integration/scripts/spotify.sh
```

All commands output JSON to stdout. Parse with jq or read directly.

## Available Commands

### User Data (Reading Hugo's Listening)

**Top Artists** — Hugo's most-listened artists over time:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh top-artists [limit] [time_range]
# limit: 1-50 (default 20)
# time_range: short_term (last 4 weeks) | medium_term (last 6 months) | long_term (several years)
```

**Top Tracks** — Hugo's most-played tracks:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh top-tracks [limit] [time_range]
```

**Recently Played** — What Hugo listened to recently (last 50 max):
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh recently-played [limit]
```

**Now Playing** — What's playing right now:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh now-playing
# Returns { playing: false } if nothing is playing
```

**Saved/Liked Tracks** — Hugo's liked tracks library:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh saved-tracks [limit]
```

### Search & Discovery

**Search** — Find tracks, artists, albums, or playlists:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh search "query" [type]
# type: track | artist | album | playlist (default: track)
```

**Artist Details** — Full info on an artist (genres, popularity, followers):
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh artist <spotify_artist_id>
```

**Artist's Top Tracks** — Most popular tracks by an artist:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh artist-top-tracks <spotify_artist_id>
```

**Related Artists** — Artists similar to a given one:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh related-artists <spotify_artist_id>
```

**Recommendations** — Spotify algorithmic recommendations from seeds:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh recommendations "seed_artists=ID1,ID2&seed_genres=house,rock&target_energy=0.8"
# Up to 5 seeds total across artists, tracks, and genres
# Tuning params: target_energy, target_danceability, target_valence, min_tempo, max_tempo, etc.
```

**Audio Features** — Detailed audio analysis of a track (BPM, energy, danceability, etc.):
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh audio-features <track_id>
# Returns: danceability, energy, tempo, valence, acousticness, instrumentalness, etc.
```

### Playlist Management

**Create Playlist**:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh create-playlist "Playlist Name" "Optional description"
# Returns: { id, name, external_urls }
```

**Add Tracks to Playlist**:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh add-to-playlist <playlist_id> "spotify:track:ID1,spotify:track:ID2,spotify:track:ID3"
# URIs must be full Spotify URIs (spotify:track:<id>)
```

**Get Playlist Details**:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh get-playlist <playlist_id>
```

**My Playlists** — List Hugo's playlists:
```bash
~/.openclaw/skills/spotify-integration/scripts/spotify.sh my-playlists [limit]
```

## Usage Patterns

### For Taste Learning
When updating Hugo's taste profile, pull real data:
```bash
# Get Hugo's current top artists across time ranges for a full picture
spotify.sh top-artists 50 long_term    # all-time favorites
spotify.sh top-artists 20 short_term   # current rotation
spotify.sh recently-played 50          # what's he been into lately
```

### For Playlist Building
When creating a real playlist Hugo can play:
```bash
# 1. Get recommendations seeded from his taste
spotify.sh recommendations "seed_artists=5INjqkS1o8h1imAzPqGZBb,4tZwfgrHOc3mvqYlEYSvVi&target_energy=0.7"

# 2. Create the playlist on Spotify
spotify.sh create-playlist "Late Night Grooves" "Deep house and electronic for after midnight"

# 3. Add tracks using their Spotify URIs
spotify.sh add-to-playlist <playlist_id> "spotify:track:abc,spotify:track:def,spotify:track:ghi"
```

### For Discovery
When recommending new music:
```bash
# Find artists similar to ones Hugo likes
spotify.sh related-artists 5INjqkS1o8h1imAzPqGZBb  # related to Tame Impala

# Search for a specific track or artist
spotify.sh search "Floating Points" artist

# Get detailed track analysis to match vibes
spotify.sh audio-features <track_id>
```

## Known Artist IDs (Hugo's Top)
These are confirmed from Hugo's Spotify data — use for seeding recommendations:
- Tame Impala: `5INjqkS1o8h1imAzPqGZBb`
- Oasis: `2DaxqgrOhkeH0fpeiQq2f4`
- Daft Punk: `4tZwfgrHOc3mvqYlEYSvVi`
- Pink Floyd: `0k17h0D3J5VfsdmQ1iZtE9`
- Grateful Dead: `4TMHGUX5WI7OOm53PqSDAT`

## Error Handling
- If the script returns an error about token refresh, the refresh token may have expired. Alert Hugo to re-authenticate.
- Rate limits: Spotify allows ~100 requests/minute. Don't spam calls in tight loops.
- Empty results: some endpoints return empty arrays — this is normal, not an error.
- If `now-playing` returns `{ playing: false }`, Hugo isn't listening right now.

## Rules
- Never expose tokens or credentials in responses to Hugo.
- Always use Spotify URIs (spotify:track:ID) when adding to playlists, not just IDs.
- When creating playlists, always set public=false (done by default in the script).
- When seeding recommendations, use max 5 seeds total (across artists, genres, tracks).
