#!/usr/bin/env bash
# The macOS plugin is a hand-maintained copy of the iOS one (no symlinks — pub.dev flattens them), so it drifts:
# a method-channel case added on iOS and forgotten on macOS fails at runtime on macOS (methods without arguments
# fall through to the "Could not find necessary arguments" error, the rest to FlutterMethodNotImplemented).
# This gate fails when the iOS plugin handles a method the macOS plugin does not, unless the method is
# listed below as iOS-only (and therefore guarded on the Dart side: Platform.isIOS for promoted purchases and
# offer-code redemption, the Platform.isMacOS early returns in nocodes_internal.dart for No-Codes).
set -euo pipefail
cd "$(dirname "$0")/.."

ios=ios/qonversion_flutter/Sources/qonversion_flutter/QonversionPlugin.swift
macos=macos/qonversion_flutter/Sources/qonversion_flutter/QonversionPlugin.swift
for f in "$ios" "$macos"; do
  [ -f "$f" ] || { echo "::error::$f not found — the plugin sources moved, update $0"; exit 1; }
done

# iOS-only method-channel methods: No-Codes (UIKit), promoted purchases, offer-code redemption.
ios_only='closeNoCodes
delegatedPurchaseCompleted
delegatedPurchaseFailed
delegatedRestoreCompleted
delegatedRestoreFailed
initializeNoCodes
loadNoCodesScreen
setNoCodesLocale
setNoCodesPurchaseDelegate
setNoCodesTheme
setScreenPresentationConfig
showNoCodesScreen
presentCodeRedemptionSheet
promoPurchase'

cases() { grep -oE 'case "[A-Za-z0-9_]+"' "$1" | sed -E 's/case "([A-Za-z0-9_]+)"/\1/' | sort -u; }

ios_cases=$(cases "$ios" || true)
macos_cases=$(cases "$macos" || true)
allow=$(echo "$ios_only" | sort -u)

missing=$(comm -23 <(echo "$ios_cases") <(echo "$macos_cases") | comm -23 - <(echo "$allow") || true)
extra=$(comm -13 <(echo "$ios_cases") <(echo "$macos_cases") || true)
stale=$(comm -13 <(echo "$ios_cases") <(echo "$allow") || true)

status=0
if [ -n "$missing" ]; then
  echo "::error::method-channel methods handled by the iOS plugin but not by the macOS one (add them to $macos or, if iOS-only and guarded in Dart, to the ios_only list in $0):"
  echo "$missing"; status=1
fi
if [ -n "$extra" ]; then
  echo "::error::method-channel methods handled by the macOS plugin but not by the iOS one:"
  echo "$extra"; status=1
fi
if [ -n "$stale" ]; then
  echo "::error::ios_only in $0 lists methods the iOS plugin no longer handles:"
  echo "$stale"; status=1
fi
shared=$(echo "$macos_cases" | grep -c . || true)
if [ -z "$macos_cases" ] || [ -z "$ios_cases" ]; then
  echo "::error::no method-channel cases found in $macos — is the file layout unchanged?"; status=1
fi
[ "$status" -eq 0 ] || exit "$status"
echo "iOS/macOS plugin method-channel parity OK ($shared shared methods, $(echo "$allow" | wc -l | tr -d ' ') iOS-only)"
