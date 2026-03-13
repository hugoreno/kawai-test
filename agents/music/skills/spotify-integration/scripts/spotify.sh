#!/usr/bin/env bash
# spotify.sh — Spotify API wrapper for OpenClaw Music Curator agent
# Usage: spotify.sh <command> [args...]
#
# Commands:
#   token                    — Refresh and print a fresh access token
#   me                       — Get current user profile
#   top-artists [limit]      — Get user's top artists (default: 20, max: 50)
#   top-tracks [limit]       — Get user's top tracks (default: 20, max: 50)
#   recently-played [limit]  — Get recently played tracks (default: 20, max: 50)
#   now-playing              — Get currently playing track
#   search <query> [type]    — Search (type: track,artist,album,playlist; default: track)
#   artist <id>              — Get artist details
#   artist-top-tracks <id>   — Get an artist's top tracks
#   related-artists <id>     — Get related artists
#   recommendations          — Get recommendations (pass seed params as extra args)
#   create-playlist <name> [desc] — Create a playlist
#   add-to-playlist <playlist_id> <uri1,uri2,...> — Add tracks to playlist
#   get-playlist <playlist_id>    — Get playlist details
#   my-playlists [limit]     — List user's playlists
#   saved-tracks [limit]     — Get user's saved/liked tracks
#   audio-features <track_id> — Get audio features for a track

set -euo pipefail

# Load env
ENV_FILE="${OPENCLAW_ENV:-$HOME/.openclaw/.env}"
if [[ -f "$ENV_FILE" ]]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

CLIENT_ID="${SPOTIFY_CLIENT_ID:?Missing SPOTIFY_CLIENT_ID}"
CLIENT_SECRET="${SPOTIFY_CLIENT_SECRET:?Missing SPOTIFY_CLIENT_SECRET}"
REFRESH_TOKEN="${SPOTIFY_REFRESH_TOKEN:?Missing SPOTIFY_REFRESH_TOKEN}"

TOKEN_CACHE="/tmp/.spotify_token_cache"
API="https://api.spotify.com/v1"

# --- Token Management ---
get_access_token() {
  # Check cache (tokens last 3600s, we refresh at 3000s to be safe)
  if [[ -f "$TOKEN_CACHE" ]]; then
    cached_at=$(head -1 "$TOKEN_CACHE")
    now=$(date +%s)
    if (( now - cached_at < 3000 )); then
      tail -1 "$TOKEN_CACHE"
      return
    fi
  fi

  # Refresh the token
  local b64
  b64=$(printf '%s:%s' "$CLIENT_ID" "$CLIENT_SECRET" | base64 -w0 2>/dev/null || printf '%s:%s' "$CLIENT_ID" "$CLIENT_SECRET" | base64)
  
  local resp
  resp=$(curl -s -X POST "https://accounts.spotify.com/api/token" \
    -H "Authorization: Basic $b64" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=refresh_token&refresh_token=$REFRESH_TOKEN")

  local token
  token=$(echo "$resp" | jq -r '.access_token // empty')
  
  if [[ -z "$token" ]]; then
    echo "ERROR: Failed to refresh token: $resp" >&2
    exit 1
  fi

  # Check if we got a new refresh token (Spotify sometimes rotates them)
  local new_refresh
  new_refresh=$(echo "$resp" | jq -r '.refresh_token // empty')
  if [[ -n "$new_refresh" && "$new_refresh" != "$REFRESH_TOKEN" ]]; then
    # Update the env file with new refresh token
    sed -i "s|^SPOTIFY_REFRESH_TOKEN=.*|SPOTIFY_REFRESH_TOKEN=$new_refresh|" "$ENV_FILE"
    echo "INFO: Refresh token rotated and saved" >&2
  fi

  # Cache it
  echo "$(date +%s)" > "$TOKEN_CACHE"
  echo "$token" >> "$TOKEN_CACHE"
  echo "$token"
}

# --- API Helpers ---
spotify_get() {
  local path="$1"
  shift
  local token
  token=$(get_access_token)
  curl -s -H "Authorization: Bearer $token" "$API/$path" "$@"
}

spotify_post() {
  local path="$1"
  local data="${2:-}"
  local token
  token=$(get_access_token)
  if [[ -n "$data" ]]; then
    curl -s -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" \
      -d "$data" "$API/$path"
  else
    curl -s -X POST -H "Authorization: Bearer $token" "$API/$path"
  fi
}

# --- Commands ---
CMD="${1:-help}"
shift || true

case "$CMD" in
  token)
    get_access_token
    ;;

  me)
    spotify_get "me" | jq '{ id, display_name, email, followers: .followers.total, product, country }'
    ;;

  top-artists)
    limit="${1:-20}"
    time_range="${2:-medium_term}" # short_term (4wk), medium_term (6mo), long_term (years)
    spotify_get "me/top/artists?limit=$limit&time_range=$time_range" | \
      jq '[.items[] | { name, id, genres, popularity, followers: .followers.total }]'
    ;;

  top-tracks)
    limit="${1:-20}"
    time_range="${2:-medium_term}"
    spotify_get "me/top/tracks?limit=$limit&time_range=$time_range" | \
      jq '[.items[] | { name, id, artist: .artists[0].name, artist_id: .artists[0].id, album: .album.name, popularity, duration_ms }]'
    ;;

  recently-played)
    limit="${1:-20}"
    spotify_get "me/player/recently-played?limit=$limit" | \
      jq '[.items[] | { track: .track.name, artist: .track.artists[0].name, album: .track.album.name, played_at, track_id: .track.id }]'
    ;;

  now-playing)
    resp=$(spotify_get "me/player/currently-playing")
    if [[ -z "$resp" || "$resp" == "null" ]]; then
      echo '{"playing": false}'
    else
      echo "$resp" | jq '{ playing: .is_playing, track: .item.name, artist: .item.artists[0].name, album: .item.album.name, progress_ms, duration_ms: .item.duration_ms, track_id: .item.id }'
    fi
    ;;

  search)
    query="${1:?Usage: spotify.sh search <query> [type]}"
    type="${2:-track}"
    encoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")
    spotify_get "search?q=$encoded&type=$type&limit=10" | \
      jq "if .tracks then [.tracks.items[] | { name, id, artist: .artists[0].name, album: .album.name, popularity }]
          elif .artists then [.artists.items[] | { name, id, genres, popularity }]
          elif .albums then [.albums.items[] | { name, id, artist: .artists[0].name, release_date }]
          else . end"
    ;;

  artist)
    id="${1:?Usage: spotify.sh artist <artist_id>}"
    spotify_get "artists/$id" | jq '{ name, id, genres, popularity, followers: .followers.total }'
    ;;

  artist-top-tracks)
    id="${1:?Usage: spotify.sh artist-top-tracks <artist_id>}"
    spotify_get "artists/$id/top-tracks" | \
      jq '[.tracks[] | { name, id, album: .album.name, popularity, duration_ms }]'
    ;;

  related-artists)
    id="${1:?Usage: spotify.sh related-artists <artist_id>}"
    spotify_get "artists/$id/related" | \
      jq '[.artists[] | { name, id, genres, popularity }]'
    ;;

  recommendations)
    # Pass seed params as query string args: seed_artists=id1,id2 seed_genres=house,rock seed_tracks=id1
    params="$*"
    spotify_get "recommendations?limit=20&$params" | \
      jq '[.tracks[] | { name, id, artist: .artists[0].name, album: .album.name, popularity, uri }]'
    ;;

  create-playlist)
    name="${1:?Usage: spotify.sh create-playlist <name> [description]}"
    desc="${2:-Created by Music Curator}"
    user_id=$(spotify_get "me" | jq -r '.id')
    spotify_post "users/$user_id/playlists" \
      "{\"name\": \"$name\", \"description\": \"$desc\", \"public\": false}" | \
      jq '{ id, name, external_urls: .external_urls.spotify }'
    ;;

  add-to-playlist)
    playlist_id="${1:?Usage: spotify.sh add-to-playlist <playlist_id> <uri1,uri2,...>}"
    uris="${2:?Provide comma-separated Spotify URIs}"
    # Convert comma-separated to JSON array
    uris_json=$(echo "$uris" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip().split(',')))")
    spotify_post "playlists/$playlist_id/tracks" "{\"uris\": $uris_json}" | jq '.'
    ;;

  get-playlist)
    playlist_id="${1:?Usage: spotify.sh get-playlist <playlist_id>}"
    spotify_get "playlists/$playlist_id" | \
      jq '{ name, id, description, total_tracks: .tracks.total, url: .external_urls.spotify, tracks: [.tracks.items[:50][] | { name: .track.name, artist: .track.artists[0].name, id: .track.id, uri: .track.uri }] }'
    ;;

  my-playlists)
    limit="${1:-20}"
    spotify_get "me/playlists?limit=$limit" | \
      jq '[.items[] | { name, id, total_tracks: .tracks.total, url: .external_urls.spotify }]'
    ;;

  saved-tracks)
    limit="${1:-20}"
    spotify_get "me/tracks?limit=$limit" | \
      jq '[.items[] | { track: .track.name, artist: .track.artists[0].name, album: .track.album.name, added_at, id: .track.id, uri: .track.uri }]'
    ;;

  audio-features)
    track_id="${1:?Usage: spotify.sh audio-features <track_id>}"
    spotify_get "audio-features/$track_id" | \
      jq '{ danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo, duration_ms, time_signature }'
    ;;

  help|*)
    echo "Usage: spotify.sh <command> [args...]"
    echo ""
    echo "Commands:"
    echo "  token                         Get fresh access token"
    echo "  me                            Current user profile"
    echo "  top-artists [limit] [range]   Top artists (range: short_term|medium_term|long_term)"
    echo "  top-tracks [limit] [range]    Top tracks"
    echo "  recently-played [limit]       Recently played"
    echo "  now-playing                   Currently playing track"
    echo "  search <query> [type]         Search (type: track|artist|album|playlist)"
    echo "  artist <id>                   Artist details"
    echo "  artist-top-tracks <id>        Artist's top tracks"
    echo "  related-artists <id>          Similar artists"
    echo "  recommendations <seed_params> Get recommendations"
    echo "  create-playlist <name> [desc] Create a playlist"
    echo "  add-to-playlist <id> <uris>   Add tracks to playlist"
    echo "  get-playlist <id>             Get playlist details"
    echo "  my-playlists [limit]          List user's playlists"
    echo "  saved-tracks [limit]          Liked/saved tracks"
    echo "  audio-features <track_id>     Track audio analysis"
    ;;
esac
