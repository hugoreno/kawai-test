---
name: google-places
description: Search restaurants via Google Places API, get details, hours, ratings, and reviews. Supplements Resy with broader discovery and research data.
version: 1.0.0
metadata:
  openclaw:
    requires:
      env:
        - GOOGLE_PLACES_API_KEY
      bins:
        - curl
        - python3
---

# Google Places Skill

Search and research restaurants using Google Places API. Provides ratings, reviews, hours, contact info, and location data.

## Script Location
```
~/.openclaw/skills/google-places/scripts/places.sh
```

All commands output JSON to stdout.

## Available Commands

### Search

**Search Nearby** — Find restaurants near a location:
```bash
~/.openclaw/skills/google-places/scripts/places.sh search-nearby "sushi" [lat] [lon] [radius_m]
# Defaults: Downtown Manhattan (40.7258, -73.9981), 2000m radius
```

**Search Text** — Broader text-based search (better for specific restaurant names):
```bash
~/.openclaw/skills/google-places/scripts/places.sh search-text "Don Angie" [lat] [lon]
# Biased toward Downtown Manhattan, 5km radius
```

### Details & Reviews

**Place Details** — Full info including hours, phone, website:
```bash
~/.openclaw/skills/google-places/scripts/places.sh details <place_id>
```

**Reviews** — Recent reviews (up to 5):
```bash
~/.openclaw/skills/google-places/scripts/places.sh reviews <place_id>
```

## When to Use

- **Restaurant research**: Get hours, phone, website, Google rating before recommending
- **Review check**: Pull recent reviews to assess quality or recent changes
- **Location lookup**: Find address and Google Maps link for directions
- **Broader discovery**: When Resy doesn't have a restaurant, Google Places usually does
- **Comparison data**: Cross-reference Resy data with Google ratings/reviews

## Integration with Other Skills

- **restaurant-discovery**: Use Google Places to enrich recommendations with ratings, reviews, hours
- **resy-integration**: Search Google Places first for research, then check Resy for availability
- **dining-log**: After dining, pull Google Place data to enrich the log entry

## Rules
- Default search location is Downtown Manhattan (40.7258, -73.9981)
- Use `search-text` for specific restaurant names, `search-nearby` for discovery by cuisine/type
- Review text is truncated to 200 chars — sufficient for quick assessment
- Google Places data is supplementary — for booking, always use Resy
