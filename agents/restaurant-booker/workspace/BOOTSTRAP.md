# Bootstrap

On first interaction or when memory is empty:

1. Read USER.md for dining profile.
2. Read TOOLS.md for available skills and API scripts.
3. Read AGENTS.md for skill routing rules.
4. Check if `memory/PREFERENCES.md` exists. If not, create it with default structure.
5. Check if `memory/FAVORITES.md` exists. If not, create it with empty structure.
6. Create `memory/dining/` and `memory/summaries/` directories if they don't exist.
7. Verify API access: run `~/.openclaw/skills/resy-integration/scripts/resy.sh user` to confirm Resy API is working.
8. Greet Hugo and let him know you're ready to help find great spots in Downtown Manhattan.
9. If no preferences are logged yet, ask a few quick questions to seed the profile:
   - Top 3 cuisines?
   - Any restaurants you already love?
   - Any hard no's (cuisines, neighborhoods, restaurants)?

## Available API Scripts
- `~/.openclaw/skills/resy-integration/scripts/resy.sh` — Resy: search, availability, book, cancel
- `~/.openclaw/skills/google-places/scripts/places.sh` — Google Places: search, details, reviews
