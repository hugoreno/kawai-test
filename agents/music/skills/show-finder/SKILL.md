---
name: show-finder
description: Surface upcoming concerts, DJ sets, club nights, and live events in NYC. Cross-references Spotify listening data to personalize recommendations.
version: 2.0.0
metadata:
  openclaw:
    requires:
      env: []
      bins: []
---

# Show Finder Skill

Find and recommend live music events in NYC.

## When to Use
- Hugo asks "anything good happening this weekend?"
- Hugo asks about a specific artist's tour dates or NYC shows
- Hugo asks "what shows should I go to?"
- Triggered by heartbeat for weekly show radar (Thursday evenings)
- When a new artist is added to taste profile — check if they're playing NYC soon

## Spotify Integration

Use Spotify data to personalize show recommendations:

```bash
SPOTIFY="~/.openclaw/skills/spotify-integration/scripts/spotify.sh"
```

When building show recommendations:
- Pull Hugo's current top artists: `$SPOTIFY top-artists 30 short_term`
- Check recently played for trending interests: `$SPOTIFY recently-played 50`
- When Hugo asks about a specific artist, get related artists for opener/support matches: `$SPOTIFY related-artists <id>`

This ensures show recommendations are grounded in what Hugo is *actually* listening to, not just what's in the static taste profile.

## NYC Venue Context

Key venues by genre/vibe:

### Electronic / House / Techno
- Nowadays (Ridgewood) — outdoor + indoor, great sound
- Basement (Bushwick) — intimate, underground
- Good Room (Greenpoint) — solid bookings, good vibe
- Elsewhere (Bushwick) — multi-room, roof, diverse programming
- Avant Gardner / Great Hall (East Williamsburg) — bigger acts
- Public Records (Gowanus) — audiophile sound system, listening-focused
- Bossa Nova Civic Club (Bushwick) — small, sweaty, great DJ nights

### Rock / Blues / Live Bands
- Brooklyn Steel — mid-size, good sound
- Music Hall of Williamsburg — classic indie venue
- Bowery Ballroom — iconic, great for mid-tier acts
- Mercury Lounge — intimate, up-and-coming acts
- Brooklyn Bowl — live music + bowling
- Terra Blues (West Village) — dedicated blues club
- The Blue Note — jazz/blues, legendary

### Larger Venues
- Brooklyn Mirage (summer) — massive outdoor electronic
- Terminal 5 — larger acts
- Hammerstein Ballroom — big shows
- Madison Square Garden / Barclays Center — arena level

## Finding Shows

### Sources
- **Resident Advisor**: electronic/club events, DJ lineups, club nights — search via web
- **Dice**: curated events, electronic and indie — search via web
- **Bandsintown**: touring artists, concert alerts — search via web
- **Venue websites**: direct listings for specific venues
- **Ohmyrockness**: NYC-focused indie/rock show listings

### Search Strategy
1. Pull Hugo's current top artists from Spotify: `$SPOTIFY top-artists 30 short_term`
2. Also pull related artists for breadth: `$SPOTIFY related-artists <top_artist_id>`
3. Search event platforms for these artists + NYC
4. Cross-reference with venue knowledge for quality filtering
5. Prioritize: known favorites > strong taste matches > interesting discoveries

### Recommendation Criteria
Rate each show opportunity:
- **Must-see**: favorite artist (in Spotify top-artists) + great venue + good date
- **Strong rec**: taste-match artist (related to favorites) + good venue
- **Worth knowing**: interesting artist or notable event, even if not perfect match
- **Skip**: Hugo wouldn't vibe with this based on taste profile

## Presenting Show Recommendations

Format:
```markdown
## [Show/Event Name]
- **Artist(s)**: [headliner] (+ [support/lineup])
- **Venue**: [venue name], [neighborhood]
- **Date**: [day, month date] @ [time]
- **Price**: [price range or "free" or "TBD"]
- **Why you'd like it**: [1-2 lines connecting to Hugo's taste — reference Spotify data if relevant]
- **Vibe**: [what to expect]
- **Links**: [Dice / RA / Bandsintown / venue link]
```

For weekend roundups:
```markdown
## This Weekend in NYC 🎧

### Friday
1. **[Artist] @ [Venue]** — [one-line pitch] — [price]

### Saturday
1. **[Artist] @ [Venue]** — [one-line pitch] — [price]

### Sunday
1. **[Artist] @ [Venue]** — [one-line pitch] — [price]

Pick of the weekend: [top recommendation and why]
```

## Logging to Memory

Write show recommendations to `memory/shows/YYYY-MM-DD.md`:
```markdown
# Show Recommendations — YYYY-MM-DD

## Recommended
| Artist | Venue | Date | Rating | Hugo's Interest | Outcome |
|--------|-------|------|--------|-----------------|---------|
| [name] | [venue] | [date] | must-see | [interested/maybe/pass] | [went/skipped/TBD] |

## Notes
- [Any context about the recommendations]
```

## Post-Show Follow-Up

If Hugo expressed interest in a show:
1. Day after: "Did you make it to [artist] at [venue]?"
2. If they went: log attendance, extract taste signals, note opener discoveries
3. If they skipped: no guilt, move on

## Output Style
- Lead with the best recommendation, not a comprehensive dump
- For weekend roundups: max 3-5 shows
- Always include *why* Hugo would like it — connect to Spotify data and taste profile
- If an artist is in Hugo's Spotify top-artists, say so: "One of your heavy rotation artists right now"
