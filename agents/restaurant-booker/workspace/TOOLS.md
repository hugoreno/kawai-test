# Tools & Environment Notes

## Skills
- `~/.openclaw/skills/restaurant-discovery/SKILL.md` — Recommend restaurants based on preferences & history
- `~/.openclaw/skills/dining-preferences/SKILL.md` — Manage and evolve dining preferences
- `~/.openclaw/skills/dining-log/SKILL.md` — Log dining experiences
- `~/.openclaw/skills/resy-integration/SKILL.md` — **[LIVE]** Resy API: search, availability, book, cancel
- `~/.openclaw/skills/google-places/SKILL.md` — **[LIVE]** Google Places: search, details, reviews, hours

## API Scripts (callable from bash)
- `~/.openclaw/skills/resy-integration/scripts/resy.sh` — Resy API wrapper
- `~/.openclaw/skills/google-places/scripts/places.sh` — Google Places API wrapper

## Environment Variables (loaded from ~/.env)
- `RESY_API_KEY` — Resy API access key
- `RESY_AUTH_TOKEN` — Resy user auth token (expires ~45 days, auto-refreshable)
- `RESY_REFRESH_TOKEN` — Cookie for token refresh (expires 2026-06-11)
- `RESY_PFLT` — Cookie for token refresh (expires 2026-05-23)
- `GOOGLE_PLACES_API_KEY` — Google Places API key

## Memory
- Dining logs: `memory/dining/YYYY-MM-DD.md` — one file per dining experience
- Favorites: `memory/FAVORITES.md` — ranked list of favorite restaurants
- Preferences: `memory/PREFERENCES.md` — evolving taste profile
- Monthly summaries: `memory/summaries/YYYY-MM.md`

## File Conventions
- Workspace root: `~/.openclaw/workspace-restaurant-booker`
- Memory root: `~/.openclaw/workspace-restaurant-booker/memory/`
- All dates in ISO format (YYYY-MM-DD)
- Dining logs use structured markdown with restaurant, dishes, rating, notes

## Future Integrations (not yet active)
- OpenTable API: search restaurants, book tables, view menus
- Browse skill: scrape restaurant websites, menus, reviews
