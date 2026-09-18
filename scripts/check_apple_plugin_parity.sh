#!/usr/bin/env bash
# The macOS plugin is a hand-maintained copy of the iOS one (no symlinks — pub.dev flattens them), so it drifts:
# a method-channel case added on iOS and forgotten on macOS surfaces as MissingPluginException at runtime.
# This gate fails when the iOS plugin handles a method the macOS plugin does not, unless the method is
# listed below as iOS-only (and therefore guarded by Platform.isIOS on the Dart side).
set -euo pipefail

ios=ios/qonversion_flutter/Sources/qonversion_flutter/QonversionPlugin.swift
macos=macos/qonversion_flutter/Sources/qonversion_flutter/QonversionPlugin.swift

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

cases() { grep -oE 'case "[A-Za-z]+"' "$1" | sed -E 's/case "([A-Za-z]+)"/\1/' | sort -u; }

missing=$(comm -23 <(cases "$ios") <(cases "$macos") | comm -23 - <(echo "$ios_only" | sort -u) || true)
extra=$(comm -13 <(cases "$ios") <(cases "$macos") || true)

if [ -n "$missing" ]; then
  echo "::error::method-channel methods handled by the iOS plugin but not by the macOS one (add them to $macos or, if iOS-only and guarded in Dart, to the ios_only list in $0):"
  echo "$missing"
  exit 1
fi
if [ -n "$extra" ]; then
  echo "::error::method-channel methods handled by the macOS plugin but not by the iOS one:"
  echo "$extra"
  exit 1
fi
echo "iOS/macOS plugin method-channel parity OK ($(cases "$macos" | wc -l | tr -d ' ') shared methods, $(echo "$ios_only" | wc -l | tr -d ' ') iOS-only)"
