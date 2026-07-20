#!/bin/zsh
# Cyra WiFi Device Setup Script
# Run this after enabling Wireless Debugging on your Android phone

set -e

export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
DEVICE_IP="${1:-192.168.100.8}"
PAIRING_PORT="${2:-}"
PAIRING_CODE="${3:-}"

echo "========================================"
echo "  Cyra Physical Device WiFi Setup"
echo "========================================"
echo ""
echo "Your machine LAN IP: $(ipconfig getifaddr en0)"
echo ""

# Check adb
if ! command -v adb &> /dev/null; then
    echo "Error: adb not found in PATH. Ensure Android SDK platform-tools is installed."
    exit 1
fi

echo "ADB version: $(adb version | head -1)"
echo ""

if [ -n "$PAIRING_PORT" ] && [ -n "$PAIRING_CODE" ]; then
    echo "Pairing with device at $DEVICE_IP:$PAIRING_PORT..."
    adb pair "$DEVICE_IP:$PAIRING_PORT" "$PAIRING_CODE"
fi

# Auto-detect wireless port
echo "Attempting to connect to $DEVICE_IP..."
CONNECT_OUTPUT=$(adb connect "$DEVICE_IP" 2>&1 || true)
echo "$CONNECT_OUTPUT"

if echo "$CONNECT_OUTPUT" | grep -q "connected"; then
    echo ""
    echo "Device connected successfully!"
    adb devices
    echo ""

    # Install APK
    echo "Installing Cyra APK..."
    adb install -r build/app/outputs/flutter-apk/app-debug.apk
    echo ""
    echo "Launching Cyra..."
    adb shell am start -n com.cyra.cyra/.MainActivity
    echo ""
    echo "Done! The app should now open on your phone."
    echo ""
    echo "To disconnect later: adb disconnect $DEVICE_IP"
else
    echo ""
    echo "Could not connect automatically."
    echo "Please enable Wireless Debugging on your phone:"
    echo "  Settings > System > Developer Options > Wireless Debugging > Turn ON"
    echo ""
    echo "Then run one of these:"
    echo "  1. Tap 'Pair using pairing code' and run:"
    echo "     ./wifi-device.sh <ip> <pairing_port> <pairing_code>"
    echo "  2. OR tap 'Pair using QR code' and scan with:"
    echo "     adb pair <ip>:<port>"
fi
