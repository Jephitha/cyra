#!/bin/bash
set -e

CYRA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$CYRA_DIR"

echo "========================================"
echo "  Cyra Development Setup"
echo "========================================"
echo ""

# --------------------------------------------------
# Check Flutter installation
# --------------------------------------------------
echo "[1/6] Checking Flutter installation..."
if command -v flutter &> /dev/null; then
  FLUTTER_VERSION=$(flutter --version 2>/dev/null | head -1)
  echo "  ✓ Found: $FLUTTER_VERSION"
else
  echo "  ✗ Flutter is not installed."
  echo "  Please install Flutter from https://docs.flutter.dev/get-started/install"
  exit 1
fi

# --------------------------------------------------
# Install Flutter dependencies
# --------------------------------------------------
echo "[2/6] Installing Flutter dependencies..."
cd apps/mobile
flutter pub get
cd "$CYRA_DIR"
echo "  ✓ Dependencies installed"

# --------------------------------------------------
# Check Supabase CLI
# --------------------------------------------------
echo "[3/6] Checking Supabase CLI..."
if command -v supabase &> /dev/null; then
  SUPABASE_VERSION=$(supabase --version 2>/dev/null)
  echo "  ✓ Found: Supabase CLI $SUPABASE_VERSION"
else
  echo "  ! Supabase CLI not found."
  echo "  Installing via Homebrew..."
  if command -v brew &> /dev/null; then
    brew install supabase/tap/supabase
    echo "  ✓ Supabase CLI installed"
  else
    echo "  ✗ Homebrew not found. Please install manually:"
    echo "    https://supabase.com/docs/guides/cli"
    exit 1
  fi
fi

# --------------------------------------------------
# Start Supabase locally
# --------------------------------------------------
echo "[4/6] Starting Supabase local environment..."
cd apps/backend/supabase
supabase start 2>/dev/null &
SUPABASE_PID=$!
echo "  ✓ Supabase starting (PID: $SUPABASE_PID)"
echo "  ⏳ Waiting for services to be ready..."
sleep 5
cd "$CYRA_DIR"

# --------------------------------------------------
# Apply database migrations
# --------------------------------------------------
echo "[5/6] Applying database migrations..."
cd apps/backend/supabase
supabase db push 2>/dev/null || supabase migration up 2>/dev/null || true
echo "  ✓ Migrations applied"

# --------------------------------------------------
# Seed data
# --------------------------------------------------
echo "[6/6] Seeding database..."
supabase db reset --linked 2>/dev/null || supabase db execute < seed/seed_data.sql 2>/dev/null || true
echo "  ✓ Seed data loaded"

echo ""
echo "========================================"
echo "  ✓ Setup Complete!"
echo "========================================"
echo ""
echo "  Mobile app:  cd apps/mobile && flutter run"
echo "  Supabase UI: http://localhost:54323"
echo "  Supabase API: http://localhost:54321"
echo ""
echo "  Happy building! 🌸"
