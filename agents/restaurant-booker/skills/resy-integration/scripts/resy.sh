#!/usr/bin/env bash
# resy.sh — Resy API wrapper for OpenClaw Restaurant Booker agent
# Usage: resy.sh <command> [args...]
#
# Commands:
#   search <query>                                     — Search restaurants by name/cuisine
#   venue <venue_id> [day]                             — Get venue details
#   calendar <venue_id> [party_size] [days]            — Check which days have availability
#   find <day> [party_size] [lat] [lon]                — Find nearby venues with slots
#   slot-details <config_id> <day> <party_size>        — Get details for a specific slot
#   book <config_id> <day> <party_size>                — Book a reservation
#   my-reservations                                    — List upcoming reservations
#   cancel <resy_token>                                — Cancel a reservation
#   user                                               — Get user profile
#   token-refresh                                      — Refresh the auth token (updates ~/.env)

set -euo pipefail

# Load env
ENV_FILE="${OPENCLAW_ENV:-$HOME/.env}"
if [[ -f "$ENV_FILE" ]]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

API_KEY="${RESY_API_KEY:?Missing RESY_API_KEY}"
AUTH_TOKEN="${RESY_AUTH_TOKEN:?Missing RESY_AUTH_TOKEN}"
API="https://api.resy.com"

# --- Helpers ---
resy_get() {
  local path="$1"; shift
  curl -sS -X GET "${API}${path}" \
    -H "Authorization: ResyAPI api_key=\"${API_KEY}\"" \
    -H "X-Resy-Auth-Token: ${AUTH_TOKEN}" \
    -H "X-Resy-Universal-Auth: ${AUTH_TOKEN}" \
    -H "Accept: application/json" \
    "$@"
}

resy_post() {
  local path="$1"; shift
  curl -sS -X POST "${API}${path}" \
    -H "Authorization: ResyAPI api_key=\"${API_KEY}\"" \
    -H "X-Resy-Auth-Token: ${AUTH_TOKEN}" \
    -H "X-Resy-Universal-Auth: ${AUTH_TOKEN}" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -H "Accept: application/json" \
    "$@"
}

resy_post_json() {
  local path="$1"; shift
  local body="$1"; shift
  curl -sS -X POST "${API}${path}" \
    -H "Authorization: ResyAPI api_key=\"${API_KEY}\"" \
    -H "X-Resy-Auth-Token: ${AUTH_TOKEN}" \
    -H "X-Resy-Universal-Auth: ${AUTH_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d "$body" \
    "$@"
}

# --- Commands ---

cmd_search() {
  local query="${1:?Usage: resy.sh search <query>}"

  resy_post_json "/3/venuesearch/search" \
    "{\"query\": \"${query}\", \"types\": [\"venue\"]}" \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
results = data.get('search', {}).get('hits', [])
out = []
for r in results[:15]:
  out.append({
    'name': r.get('name', ''),
    'venue_id': r.get('id', {}).get('resy', ''),
    'cuisine': r.get('cuisine', []),
    'price_range': r.get('price_range', 0),
    'neighborhood': r.get('location', {}).get('name', ''),
    'rating': r.get('rating', ''),
    'region': r.get('region', ''),
    'url_slug': r.get('url_slug', ''),
  })
json.dump({'count': len(out), 'results': out}, sys.stdout, indent=2)
"
}

cmd_venue() {
  local venue_id="${1:?Usage: resy.sh venue <venue_id> [day]}"
  local day="${2:-$(date +%Y-%m-%d)}"

  resy_get "/3/venue" -G \
    -d "id=${venue_id}" \
    -d "day=${day}" \
    -d "party_size=2" \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
venue = data
name = data.get('name', '')
location = data.get('location', {})
contact = data.get('contact', {})
out = {
  'name': name,
  'venue_id': data.get('id', {}).get('resy', '') if isinstance(data.get('id'), dict) else data.get('id', ''),
  'type': data.get('type', ''),
  'price_range_id': data.get('price_range_id', 0),
  'neighborhood': location.get('neighborhood', ''),
  'address': location.get('address_1', ''),
  'city': location.get('locality', ''),
  'cross_street': location.get('cross_street_1', ''),
  'tagline': data.get('rater', {}).get('tagline', '') if isinstance(data.get('rater'), dict) else '',
  'url_slug': data.get('url_slug', ''),
  'resy_url': 'https://resy.com/cities/{}/{}'.format(
    location.get('code', 'ny'),
    data.get('url_slug', '')
  ),
}
json.dump(out, sys.stdout, indent=2)
"
}

cmd_calendar() {
  local venue_id="${1:?Usage: resy.sh calendar <venue_id> [party_size] [days]}"
  local party_size="${2:-2}"
  local days="${3:-30}"

  local start_date
  start_date=$(date +%Y-%m-%d)
  local end_date
  end_date=$(date -d "+${days} days" +%Y-%m-%d 2>/dev/null || date -v+${days}d +%Y-%m-%d 2>/dev/null || python3 -c "from datetime import datetime, timedelta; print((datetime.now()+timedelta(days=${days})).strftime('%Y-%m-%d'))")

  resy_get "/3/venue/calendar" -G \
    -d "venue_id=${venue_id}" \
    -d "num_seats=${party_size}" \
    -d "start_date=${start_date}" \
    -d "end_date=${end_date}" \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
scheduled = data.get('scheduled', [])
available = [e for e in scheduled if e.get('inventory') == 'available']
sold_out = [e for e in scheduled if e.get('inventory') == 'sold-out']
closed = [e for e in scheduled if e.get('inventory') == 'closed']
out = {
  'venue_id': '${venue_id}',
  'party_size': ${party_size},
  'total_days': len(scheduled),
  'available_days': len(available),
  'sold_out_days': len(sold_out),
  'closed_days': len(closed),
  'available_dates': [e['date'] for e in available],
  'sold_out_dates': [e['date'] for e in sold_out],
}
json.dump(out, sys.stdout, indent=2)
"
}

cmd_find() {
  local day="${1:?Usage: resy.sh find <day> [party_size] [lat] [lon]}"
  local party_size="${2:-2}"
  local lat="${3:-40.7258}"
  local lon="${4:--73.9981}"

  resy_get "/3/find" -G \
    -d "lat=${lat}" \
    -d "long=${lon}" \
    -d "day=${day}" \
    -d "party_size=${party_size}" \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
results = data.get('results', [])
out = []
for r in results[:15]:
  venue = r.get('venue', {})
  configs = r.get('configs', [])
  slots = []
  for c in configs:
    dt = c.get('date', {})
    slots.append({
      'time': dt.get('start', ''),
      'end': dt.get('end', ''),
      'type': c.get('type', ''),
      'token': c.get('token', ''),
      'config_id': c.get('id', ''),
    })
  out.append({
    'name': venue.get('name', ''),
    'venue_id': venue.get('id', {}).get('resy', '') if isinstance(venue.get('id'), dict) else venue.get('id', ''),
    'neighborhood': venue.get('neighborhood', ''),
    'slot_count': len(slots),
    'slots': slots[:10],
  })
json.dump({
  'day': '${day}',
  'party_size': ${party_size},
  'venue_count': len(out),
  'results': out
}, sys.stdout, indent=2)
"
}

cmd_slot_details() {
  local config_id="${1:?Usage: resy.sh slot-details <config_id> <day> <party_size>}"
  local day="${2:?}"
  local party_size="${3:?}"

  resy_post "/3/details" \
    -d "config_id=${config_id}" \
    -d "day=${day}" \
    -d "party_size=${party_size}" \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
cancellation = data.get('cancellation', {})
bt = data.get('book_token', {})
payment = data.get('user', {}).get('payment_methods', [])
out = {
  'config_id': '${config_id}',
  'has_book_token': bool(bt.get('value', '')),
  'cancellation_policy': cancellation.get('display', {}).get('policy', [''])[0] if isinstance(cancellation.get('display', {}).get('policy'), list) else '',
  'payment_methods_on_file': len(payment),
  'deposit_required': data.get('config', {}).get('double_confirmation', ''),
}
json.dump(out, sys.stdout, indent=2)
"
}

cmd_book() {
  local config_id="${1:?Usage: resy.sh book <config_id> <day> <party_size>}"
  local day="${2:?}"
  local party_size="${3:?}"

  # Step 1: get booking token from details
  local details
  details=$(resy_post "/3/details" \
    -d "config_id=${config_id}" \
    -d "day=${day}" \
    -d "party_size=${party_size}")

  local book_token
  book_token=$(echo "$details" | python3 -c "import sys,json; print(json.load(sys.stdin).get('book_token',{}).get('value',''))")

  if [[ -z "$book_token" ]]; then
    echo '{"error": "Could not get booking token. Slot may no longer be available."}' >&2
    exit 1
  fi

  # Step 2: get payment method id
  local payment_method_id
  payment_method_id=$(echo "$details" | python3 -c "
import sys, json
d = json.load(sys.stdin)
pm = d.get('user', {}).get('payment_methods', [])
if pm:
    print(pm[0].get('id', ''))
else:
    print('')
")

  if [[ -z "$payment_method_id" ]]; then
    echo '{"error": "No payment method on file. Add one at resy.com/account."}' >&2
    exit 1
  fi

  # Step 3: book
  local result
  result=$(resy_post "/3/book" \
    -d "book_token=${book_token}" \
    -d "struct_payment_method={\"id\":${payment_method_id}}" \
    -d "source_id=resy.com-venue-details")

  echo "$result" | python3 -c "
import sys, json
data = json.load(sys.stdin)
out = {
  'resy_token': data.get('resy_token', ''),
  'reservation_id': data.get('reservation_id', ''),
  'confirmation': 'Booking confirmed!' if data.get('resy_token') else 'Booking may have failed',
}
json.dump(out, sys.stdout, indent=2)
"
}

cmd_my_reservations() {
  resy_get "/3/user/reservations" -G \
    -d "limit=10" \
    -d "offset=0" \
    -d "type=upcoming" \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
reservations = data.get('reservations', [])
out = []
for r in reservations:
  venue = r.get('venue', {})
  res = r.get('reservation', {})
  out.append({
    'restaurant': venue.get('name', ''),
    'neighborhood': venue.get('neighborhood', ''),
    'date': res.get('day', ''),
    'time': res.get('time_slot', ''),
    'party_size': res.get('party_size', ''),
    'resy_token': res.get('resy_token', ''),
    'confirmation_number': res.get('confirmation_number', ''),
    'cancellation_policy': res.get('cancellation', {}).get('policy', ''),
  })
json.dump({'count': len(out), 'reservations': out}, sys.stdout, indent=2)
"
}

cmd_cancel() {
  local resy_token="${1:?Usage: resy.sh cancel <resy_token>}"

  resy_post "/3/cancel" \
    -d "resy_token=${resy_token}" \
    | python3 -c "
import sys, json
try:
  data = json.load(sys.stdin)
  json.dump({'status': 'cancelled', 'detail': data}, sys.stdout, indent=2)
except:
  print(json.dumps({'status': 'cancelled', 'note': 'Cancellation submitted (empty response is normal)'}))
"
}

cmd_user() {
  resy_get "/2/user" | python3 -c "
import sys, json
data = json.load(sys.stdin)
out = {
  'name': '{} {}'.format(data.get('first_name',''), data.get('last_name','')),
  'email': data.get('email_address', ''),
  'phone': data.get('mobile_number', ''),
  'num_bookings': data.get('num_bookings', 0),
  'payment_methods': len(data.get('payment_methods', [])),
}
json.dump(out, sys.stdout, indent=2)
"
}

cmd_token_refresh() {
  # Refresh auth token using pflt + refresh cookies
  local PFLT="${RESY_PFLT:?Missing RESY_PFLT}"
  local REFRESH="${RESY_REFRESH_TOKEN:?Missing RESY_REFRESH_TOKEN}"

  local result
  result=$(curl -sS -X POST "${API}/3/auth/refresh" \
    -H "Authorization: ResyAPI api_key=\"${API_KEY}\"" \
    -H "Accept: application/json" \
    -b "pflt=${PFLT}; production_refresh_token=${REFRESH}")

  local new_token
  new_token=$(echo "$result" | python3 -c "import sys,json; print(json.load(sys.stdin).get('token',''))")

  if [[ -z "$new_token" ]]; then
    echo '{"error": "Token refresh failed", "response": '"$result"'}' >&2
    exit 1
  fi

  # Update ~/.env with new token
  if [[ -f "$ENV_FILE" ]]; then
    sed -i'' "s|^RESY_AUTH_TOKEN=.*|RESY_AUTH_TOKEN=${new_token}|" "$ENV_FILE"
  fi

  # Also update running env
  export RESY_AUTH_TOKEN="$new_token"
  AUTH_TOKEN="$new_token"

  echo "{\"status\": \"refreshed\", \"new_token_preview\": \"${new_token:0:20}...\"}"
}

# --- Dispatch ---
cmd="${1:-help}"
shift || true

case "$cmd" in
  search)           cmd_search "$@" ;;
  venue)            cmd_venue "$@" ;;
  calendar)         cmd_calendar "$@" ;;
  find)             cmd_find "$@" ;;
  slot-details)     cmd_slot_details "$@" ;;
  book)             cmd_book "$@" ;;
  my-reservations)  cmd_my_reservations ;;
  cancel)           cmd_cancel "$@" ;;
  user)             cmd_user ;;
  token-refresh)    cmd_token_refresh ;;
  help|*)
    echo "Usage: resy.sh <command> [args...]"
    echo ""
    echo "Commands:"
    echo "  search <query>                              Search restaurants by name/cuisine"
    echo "  venue <venue_id> [day]                      Get venue details"
    echo "  calendar <venue_id> [party_size] [days]     Check date-level availability"
    echo "  find <day> [party_size] [lat] [lon]         Find nearby venues with time slots"
    echo "  slot-details <config_id> <day> <party_size> Get booking details for a slot"
    echo "  book <config_id> <day> <party_size>         Book a reservation"
    echo "  my-reservations                             List upcoming reservations"
    echo "  cancel <resy_token>                         Cancel a reservation"
    echo "  user                                        Get user profile"
    echo "  token-refresh                               Refresh auth token"
    ;;
esac
