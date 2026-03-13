#!/usr/bin/env bash
# places.sh — Google Places API (New) wrapper for OpenClaw Restaurant Booker agent
# Usage: places.sh <command> [args...]
#
# Commands:
#   search-nearby <query> [lat] [lon] [radius_m]   — Search nearby restaurants
#   search-text <query> [lat] [lon]                  — Text-based search (broader)
#   details <place_id>                                — Get full place details
#   reviews <place_id>                                — Get reviews for a place

set -euo pipefail

# Load env
ENV_FILE="${OPENCLAW_ENV:-$HOME/.env}"
if [[ -f "$ENV_FILE" ]]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

API_KEY="${GOOGLE_PLACES_API_KEY:?Missing GOOGLE_PLACES_API_KEY}"
API="https://places.googleapis.com/v1"

# --- Helpers ---
places_post() {
  local path="$1"
  local body="$2"
  local fields="${3:-places.displayName,places.formattedAddress,places.id,places.rating,places.userRatingCount,places.priceLevel,places.types,places.websiteUri,places.currentOpeningHours,places.nationalPhoneNumber,places.editorialSummary,places.googleMapsUri}"
  
  curl -sS -X POST "${API}${path}" \
    -H "Content-Type: application/json" \
    -H "X-Goog-Api-Key: ${API_KEY}" \
    -H "X-Goog-FieldMask: ${fields}" \
    -d "$body"
}

places_get() {
  local path="$1"
  local fields="${2:-displayName,formattedAddress,id,rating,userRatingCount,priceLevel,types,websiteUri,currentOpeningHours,nationalPhoneNumber,editorialSummary,googleMapsUri,reviews}"
  
  curl -sS -X GET "${API}${path}" \
    -H "Content-Type: application/json" \
    -H "X-Goog-Api-Key: ${API_KEY}" \
    -H "X-Goog-FieldMask: ${fields}"
}

# --- Commands ---

cmd_search_nearby() {
  local query="${1:?Usage: places.sh search-nearby <query> [lat] [lon] [radius_m]}"
  local lat="${2:-40.7258}"
  local lon="${3:--73.9981}"
  local radius="${4:-2000}"

  local body
  body=$(python3 -c "
import json
body = {
  'includedTypes': ['restaurant'],
  'maxResultCount': 10,
  'locationRestriction': {
    'circle': {
      'center': {'latitude': $lat, 'longitude': $lon},
      'radius': $radius
    }
  },
  'textQuery': '$query'
}
print(json.dumps(body))
")

  places_post "/places:searchText" "$body" | python3 -c "
import sys, json
data = json.load(sys.stdin)
places = data.get('places', [])
out = []
for p in places:
  out.append({
    'name': p.get('displayName', {}).get('text', ''),
    'place_id': p.get('id', '').replace('places/', ''),
    'address': p.get('formattedAddress', ''),
    'rating': p.get('rating', ''),
    'review_count': p.get('userRatingCount', 0),
    'price_level': p.get('priceLevel', ''),
    'phone': p.get('nationalPhoneNumber', ''),
    'website': p.get('websiteUri', ''),
    'summary': p.get('editorialSummary', {}).get('text', '') if p.get('editorialSummary') else '',
    'maps_url': p.get('googleMapsUri', ''),
  })
json.dump({'count': len(out), 'results': out}, sys.stdout, indent=2)
"
}

cmd_search_text() {
  local query="${1:?Usage: places.sh search-text <query> [lat] [lon]}"
  local lat="${2:-40.7258}"
  local lon="${3:--73.9981}"

  local body
  body=$(python3 -c "
import json
body = {
  'textQuery': '$query restaurant',
  'maxResultCount': 10,
  'locationBias': {
    'circle': {
      'center': {'latitude': $lat, 'longitude': $lon},
      'radius': 5000.0
    }
  }
}
print(json.dumps(body))
")

  places_post "/places:searchText" "$body" | python3 -c "
import sys, json
data = json.load(sys.stdin)
places = data.get('places', [])
out = []
for p in places:
  hours_text = ''
  hours = p.get('currentOpeningHours', {})
  if hours:
    today_texts = hours.get('weekdayDescriptions', [])
    hours_text = '; '.join(today_texts[:2]) if today_texts else ''
  out.append({
    'name': p.get('displayName', {}).get('text', ''),
    'place_id': p.get('id', '').replace('places/', ''),
    'address': p.get('formattedAddress', ''),
    'rating': p.get('rating', ''),
    'review_count': p.get('userRatingCount', 0),
    'price_level': p.get('priceLevel', ''),
    'phone': p.get('nationalPhoneNumber', ''),
    'website': p.get('websiteUri', ''),
    'summary': p.get('editorialSummary', {}).get('text', '') if p.get('editorialSummary') else '',
    'maps_url': p.get('googleMapsUri', ''),
    'hours_preview': hours_text,
  })
json.dump({'count': len(out), 'results': out}, sys.stdout, indent=2)
"
}

cmd_details() {
  local place_id="${1:?Usage: places.sh details <place_id>}"

  places_get "/places/${place_id}" | python3 -c "
import sys, json
p = json.load(sys.stdin)
hours = p.get('currentOpeningHours', {})
hours_list = hours.get('weekdayDescriptions', []) if hours else []
out = {
  'name': p.get('displayName', {}).get('text', ''),
  'place_id': p.get('id', '').replace('places/', ''),
  'address': p.get('formattedAddress', ''),
  'rating': p.get('rating', ''),
  'review_count': p.get('userRatingCount', 0),
  'price_level': p.get('priceLevel', ''),
  'phone': p.get('nationalPhoneNumber', ''),
  'website': p.get('websiteUri', ''),
  'summary': p.get('editorialSummary', {}).get('text', '') if p.get('editorialSummary') else '',
  'maps_url': p.get('googleMapsUri', ''),
  'hours': hours_list,
}
json.dump(out, sys.stdout, indent=2)
"
}

cmd_reviews() {
  local place_id="${1:?Usage: places.sh reviews <place_id>}"

  places_get "/places/${place_id}" "displayName,reviews" | python3 -c "
import sys, json
data = json.load(sys.stdin)
name = data.get('displayName', {}).get('text', '')
reviews = data.get('reviews', [])
out = []
for r in reviews[:5]:
  out.append({
    'author': r.get('authorAttribution', {}).get('displayName', ''),
    'rating': r.get('rating', ''),
    'text': r.get('text', {}).get('text', '')[:200] if r.get('text') else '',
    'time': r.get('relativePublishTimeDescription', ''),
  })
json.dump({'restaurant': name, 'review_count': len(out), 'reviews': out}, sys.stdout, indent=2)
"
}

# --- Dispatch ---
cmd="${1:-help}"
shift || true

case "$cmd" in
  search-nearby)  cmd_search_nearby "$@" ;;
  search-text)    cmd_search_text "$@" ;;
  details)        cmd_details "$@" ;;
  reviews)        cmd_reviews "$@" ;;
  help|*)
    echo "Usage: places.sh <command> [args...]"
    echo ""
    echo "Commands:"
    echo "  search-nearby <query> [lat] [lon] [radius_m]"
    echo "  search-text <query> [lat] [lon]"
    echo "  details <place_id>"
    echo "  reviews <place_id>"
    ;;
esac
