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
    SUPABASE_URL_PROD=*) supabase_url_prod="${decoded#SUPABASE_URL_PROD=}" ;;
    SUPABASE_ANON_KEY_PROD=*) supabase_key_prod="${decoded#SUPABASE_ANON_KEY_PROD=}" ;;
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

if [ "$app_env" = "production" ]; then
  supabase_url="$supabase_url_prod"
  supabase_key="$supabase_key_prod"
fi

case "$supabase_url" in
  https://localhost*|https://127.*|https://10.*|https://192.168.*)
    echo "error: Release SUPABASE_URL cannot target a local or private host."
    exit 1
    ;;
  https://*) ;;
  *)
    echo "error: Release builds require a public HTTPS Supabase URL. Production uses SUPABASE_URL_PROD."
    exit 1
    ;;
esac

if [ "${#supabase_key}" -lt 20 ]; then
  echo "error: Release builds require a non-placeholder Supabase anon key. Production uses SUPABASE_ANON_KEY_PROD."
  exit 1
fi
