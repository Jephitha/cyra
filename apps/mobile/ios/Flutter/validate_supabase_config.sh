#!/bin/sh

if [ "$CONFIGURATION" != "Release" ]; then
  exit 0
fi

app_env=""
supabase_url=""
supabase_key=""

old_ifs="$IFS"
IFS=','
for encoded in $DART_DEFINES; do
  decoded="$(printf '%s' "$encoded" | /usr/bin/base64 -D 2>/dev/null)"
  case "$decoded" in
    APP_ENV=*) app_env="${decoded#APP_ENV=}" ;;
    SUPABASE_URL=*) supabase_url="${decoded#SUPABASE_URL=}" ;;
    SUPABASE_ANON_KEY=*) supabase_key="${decoded#SUPABASE_ANON_KEY=}" ;;
  esac
done
IFS="$old_ifs"

case "$app_env" in
  staging|production) ;;
  *)
    echo "error: Release builds require APP_ENV=staging or production."
    exit 1
    ;;
esac

case "$supabase_url" in
  https://localhost*|https://127.*|https://10.*|https://192.168.*)
    echo "error: Release SUPABASE_URL cannot target a local or private host."
    exit 1
    ;;
  https://*) ;;
  *)
    echo "error: Release builds require a public HTTPS SUPABASE_URL."
    exit 1
    ;;
esac

if [ "${#supabase_key}" -lt 20 ]; then
  echo "error: Release builds require a non-placeholder SUPABASE_ANON_KEY."
  exit 1
fi
