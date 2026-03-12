---
name: show-finder
description: Surface upcoming concerts, DJ sets, club nights, and live events in NYC from artists the user likes or would like. Track show recommendations and attendance.
version: 1.0.0
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

## NYC Venue Context

Key venues by genre/vibe (update as Hugo shares preferences):

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

### Sources (future integrations — currently use web search)
- **Resident Advisor**: electronic/club events, DJ lineups, club nights
- **Dice**: curated events, often electronic and indie
- **Bandsintown**: touring artists, concert alerts based on followed artists
- **Venue websites**: direct listings for specific venues
- **Ohmyrockness**: NYC-focused indie/rock show listings

### Search Strategy
1. Check taste profile for favorite artists and genre affinities
2. Search for upcoming events matching those artists/genres in NYC
3. Cross-reference with venue knowledge for quality filtering
4. Prioritize: known favorites > strong taste matches > interesting discoveries

### Recommendation Criteria
Rate each show opportunity:
- **Must-see**: favorite artist + great venue + good date
- **Strong rec**: taste-match artist + good venue
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
- **Why you'd like it**: [1-2 lines connecting to Hugo's taste]
- **Vibe**: [what to expect — intimate set? big production? late-night dance?]
- **Links**: [Dice / RA / Bandsintown / venue link when available]
```

For weekend roundups, keep it tight:
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
|--------|-------|------|--------|-------------------|---------|
| [name] | [venue] | [date] | must-see | [interested/maybe/pass] | [went/skipped/TBD] |

## Notes
- [Any context about the recommendations]
```

## Post-Show Follow-Up

If Hugo expressed interest in a show:
1. Day after the show: "Did you make it to [artist] at [venue]?"
2. If they went:
   - Log attendance in shows memory
   - Ask how it was — extract taste signals for taste-learning skill
   - Note any new artist discoveries from openers/support acts
3. If they skipped: no guilt, move on

## Output Style
- Lead with the best recommendation, not a comprehensive dump
- For weekend roundups: max 3-5 shows, not a full event calendar
- If Hugo asks about a specific genre: filter hard, quality over quantity
- Always include *why* Hugo would like it — connect to taste profile
