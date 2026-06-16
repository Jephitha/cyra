#!/bin/bash
set -e

echo "Running Cyra tests..."
cd "$(dirname "$0")/../apps/mobile"

flutter test --coverage --coverage-path=coverage/lcov.info

echo ""
echo "Coverage report generated at apps/mobile/coverage/lcov.info"
echo ""
echo "✓ All tests completed!"
