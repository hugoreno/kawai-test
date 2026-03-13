---
name: resy-integration
description: Interface with Resy API to search restaurants, check real-time availability, make reservations, manage bookings, and cancel. This is a tool skill — other skills (restaurant-discovery, reservation-management) call into it.
version: 1.1.0
metadata:
  openclaw:
    requires:
      env:
        - RESY_API_KEY
        - RESY_AUTH_TOKEN
        - RESY_REFRESH_TOKEN
        - RESY_PFLT
      bins:
        - curl
        - jq
        - python3
---

# Resy Integration Skill

Interface with Resy to search restaurants, check availability, make/cancel reservations for Hugo.

## Script Location
```
~/.openclaw/skills/resy-integration/scripts/resy.sh
```

All commands output JSON to stdout. Parse with jq or read directly.

## Available Commands

### Search & Discovery

**Search Restaurants** — Find restaurants by name, cuisine, or keyword:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh search "<query>"
```
Returns: name, venue_id, cuisine, price_range, neighborhood, rating, region, url_slug. Up to 15 results.

**Venue Details** — Full info on a specific restaurant:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh venue <venue_id> [day]
```
Returns: name, address, neighborhood, city, cross_street, tagline, resy_url.

### Availability

**Calendar** — Check which dates have availability for a venue over a date range:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh calendar <venue_id> [party_size] [days]
# party_size default: 2
# days default: 30 (looks ahead this many days from today)
```
Returns: available_dates, sold_out_dates, and counts. Use this to find which days have openings before attempting to book.

**Find Nearby** — Discover venues with available time slots near a location:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh find <day> [party_size] [lat] [lon]
# day format: YYYY-MM-DD
# party_size default: 2
# lat/lon default to Downtown Manhattan (40.7258, -73.9981)
```
Returns: list of nearby venues with their available time slots (time, type, config_id).

**Slot Details** — Get booking details for a specific time slot:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh slot-details <config_id> <day> <party_size>
```
Returns: book token availability, cancellation policy, payment methods on file, deposit requirements.

### Booking

**Book a Reservation** — Book a specific time slot:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh book <config_id> <day> <party_size>
```
This is a 3-step process (handled automatically):
1. Gets booking token from slot details
2. Retrieves payment method on file
3. Confirms the booking

Returns: resy_token (needed for cancellation), reservation_id, confirmation status.

⚠️ **IMPORTANT**: Always confirm with the user before calling `book`. Show them the restaurant, time, date, and party size first.

### Reservation Management

**My Reservations** — List upcoming reservations:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh my-reservations
```
Returns: restaurant name, date, time, party_size, resy_token, confirmation_number, cancellation_policy.

**Cancel Reservation** — Cancel an existing reservation:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh cancel <resy_token>
```
⚠️ **IMPORTANT**: Always confirm with the user before cancelling. Check the cancellation policy first.

### Account & Maintenance

**User Profile** — Get Hugo's Resy account info:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh user
```

**Refresh Auth Token** — Refresh the auth token when it expires:
```bash
~/.openclaw/skills/resy-integration/scripts/resy.sh token-refresh
```
Automatically updates `~/.env` with the new token. Use when API calls return 419 Unauthorized.

## Token Expiry Reference
- **Auth token**: expires ~45 days from refresh (check with `user` command — 419 means expired)
- **Refresh token**: expires 2026-06-11
- **PFLT**: expires 2026-05-23
- If auth token expires, run `token-refresh` to get a new one
- If refresh token or PFLT expire, Hugo needs to log into resy.com and extract new cookies from browser DevTools

## Typical Workflows

### "Find me a restaurant tonight"
1. `search "italian downtown"` → get venue_ids
2. Pick a venue → `calendar <venue_id> 2 1` → confirm today has availability
3. `find 2026-03-13 2 40.7258 -73.9981` → find time slots near Downtown Manhattan
4. Show user the available slots
5. User picks a time → `book <config_id> 2026-03-13 2`

### "Is [restaurant] available this weekend?"
1. `search "restaurant name"` → get venue_id
2. `calendar <venue_id> 2 7` → see which of the next 7 days have openings
3. Report available vs sold-out dates

### "What reservations do I have?"
1. `my-reservations`
2. Present the list with dates, times, restaurant names

### "Cancel my reservation at [restaurant]"
1. `my-reservations` → find the resy_token for that restaurant
2. Confirm with user (show cancellation policy)
3. `cancel <resy_token>`

## API Endpoints Reference

| Command | Endpoint | Method |
|---------|----------|--------|
| search | `/3/venuesearch/search` | POST (JSON) |
| venue | `/3/venue` | GET |
| calendar | `/3/venue/calendar` | GET |
| find | `/3/find` | GET |
| slot-details | `/3/details` | POST (form) |
| book | `/3/details` + `/3/book` | POST (form) |
| my-reservations | `/3/user/reservations` | GET |
| cancel | `/3/cancel` | POST (form) |
| user | `/2/user` | GET |
| token-refresh | `/3/auth/refresh` | POST |

## Error Handling
- **419 Unauthorized**: Auth token expired → run `token-refresh`
- **400 Bad Request**: Usually invalid venue_id or date format
- **404 Not Found**: Venue doesn't exist on Resy
- **No available dates in calendar**: No availability for that party_size — suggest alternate dates or smaller party
- **Empty slots in find**: No time slots for that date/location — try a different date
- **Booking failure**: Slot was taken between check and book — re-check availability

## Known Limitations
- **No time-slot-level availability per venue**: Resy's `/4/find` endpoint (which returns per-venue time slots) is currently returning HTTP 500. Use `calendar` to check date availability, and `find` to discover venues with slots in an area.
- **Search has no geo/date filtering**: The search endpoint only accepts a text query. Use `find` for location-aware discovery.

## Rules
- NEVER book without explicit user confirmation
- NEVER cancel without explicit user confirmation
- Always show cancellation policy before cancelling
- Default location is Downtown Manhattan (Hugo's area)
- Default party size is 2
- After successful booking, offer to log it with the dining-log skill
- If a search returns no results, suggest broadening the search (different cuisine, neighborhood, or date)
