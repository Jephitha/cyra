#!/bin/bash
set -e

echo "Running Flutter analyze..."
cd "$(dirname "$0")/../apps/mobile"

flutter analyze

echo ""
echo "Running dart format check..."
dart format --set-exit-if-changed lib/ test/

echo ""
echo "✓ All checks passed!"
