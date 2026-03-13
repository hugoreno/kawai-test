# Tools & Environment Notes

## Skills
- `~/.openclaw/skills/taste-learning/SKILL.md` — Learn and maintain Hugo's music taste profile
- `~/.openclaw/skills/playlist-builder/SKILL.md` — Build curated playlists on Spotify
- `~/.openclaw/skills/show-finder/SKILL.md` — Surface upcoming NYC shows and events
- `~/.openclaw/skills/spotify-integration/SKILL.md` — Spotify API interface (tool skill used by others)

## Spotify API (ACTIVE)
Script: `~/.openclaw/skills/spotify-integration/scripts/spotify.sh`
Auth: OAuth 2.0 refresh token flow — auto-refreshes access tokens.
Env vars loaded from `~/.openclaw/.env`:
- `SPOTIFY_CLIENT_ID`
- `SPOTIFY_CLIENT_SECRET`
- `SPOTIFY_REFRESH_TOKEN`

### Quick Reference
```bash
SPOTIFY="~/.openclaw/skills/spotify-integration/scripts/spotify.sh"

# Reading Hugo's data
$SPOTIFY top-artists [limit] [short_term|medium_term|long_term]
$SPOTIFY top-tracks [limit] [time_range]
$SPOTIFY recently-played [limit]
$SPOTIFY now-playing
$SPOTIFY saved-tracks [limit]

# Search & Discovery
$SPOTIFY search "query" [track|artist|album|playlist]
$SPOTIFY artist <id>
$SPOTIFY artist-top-tracks <id>
$SPOTIFY related-artists <id>
$SPOTIFY recommendations "seed_artists=X&seed_genres=Y&target_energy=0.7"
$SPOTIFY audio-features <track_id>

# Playlist Management
$SPOTIFY create-playlist "Name" "Description"
$SPOTIFY add-to-playlist <playlist_id> "spotify:track:id1,spotify:track:id2"
$SPOTIFY get-playlist <playlist_id>
$SPOTIFY my-playlists [limit]
```

## Memory
- Taste profile: `memory/TASTE_PROFILE.md` — evolving music taste map
- Discoveries log: `memory/discoveries/YYYY-MM-DD.md` — recommendations made and user reactions
- Playlists: `memory/playlists/[playlist-name].md` — curated playlists with tracklists + Spotify IDs
- Show recommendations: `memory/shows/YYYY-MM-DD.md` — shows surfaced and user interest

## File Conventions
- Workspace root: `~/.openclaw/workspace-music`
- Memory root: `~/.openclaw/workspace-music/memory/`
- All dates in ISO format (YYYY-MM-DD)
- Discovery logs include: artist, track/album, genre tags, why recommended, user reaction
- Playlist memory includes Spotify playlist ID and track URIs for future updates

## Future Integrations (not yet active)
- Bandsintown: upcoming shows by followed artists, local events
- Dice: NYC event listings, ticket availability
- Resident Advisor: club nights, DJ events, electronic music calendar
