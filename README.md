<!-- header image: pending — add when the asset is published (see readme-v2/readme-template.md §2.1) -->

# Qonversion Flutter SDK

**Qonversion is the app growth system for people and agents.** It collects the revenue data of your
subscription app and keeps it lined up with what App Store Connect reports, so campaigns, experiments and
entitlements run on the same numbers. This repository holds the Flutter SDK: the part that runs inside
your app.

[![Version](https://img.shields.io/github/v/release/qonversion/flutter-sdk?label=version)](https://github.com/qonversion/flutter-sdk/releases)
[![pub](https://img.shields.io/pub/v/qonversion_flutter)](https://pub.dev/packages/qonversion_flutter)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20Android%20%7C%20macOS-blue.svg?style=flat)](https://documentation.qonversion.io/docs/flutter-sdk)

## Quickstart

Create a project in the [dashboard](https://dash.qonversion.io) and connect your stores first — nothing validates until then.

**1. Install**

```bash
flutter pub add qonversion_flutter
```

**2. Initialize**

```dart
import 'package:qonversion_flutter/qonversion_flutter.dart';

final config = QonversionConfigBuilder(
  'your_project_key',
  QLaunchMode.subscriptionManagement,
).build();

Qonversion.initialize(config);
```

The project key is in the dashboard under **Settings → Developer → Keys**.

This is Subscription Management Mode — Qonversion owns the purchase flow. To keep your own purchase
code and use Qonversion for analytics only, initialize with [Analytics Mode](https://documentation.qonversion.io/docs/analytics-mode) instead.

**3. Check what the user has access to**

```dart
final entitlements = await Qonversion.getSharedInstance().checkEntitlements();

if (entitlements['premium']?.isActive == true) {
  // unlock premium features
}
```

Full walk-through, both modes and the store setup: [Quick start](https://documentation.qonversion.io/docs/quickstart).

### iOS and macOS native dependencies

The native dependency is resolved through Swift Package Manager when it is enabled in Flutter
(opt-in since Flutter 3.24, on by default since 3.44) and through CocoaPods otherwise — see
[iOS and macOS native dependencies](https://documentation.qonversion.io/docs/flutter-sdk#ios-and-macos-native-dependencies).

> CocoaPods trunk becomes read-only on December 2, 2026 — see the
> [CocoaPods → Swift Package Manager migration guide](https://documentation.qonversion.io/docs/dec-2026-migration-guide-cocoapods-to-spm).

## Documentation

* [Welcome](https://documentation.qonversion.io/docs/qonversion-platform) — what the platform does and the three ways to start.
* [Flutter setup](https://documentation.qonversion.io/docs/flutter-sdk) — full installation for this platform.
* [Quick start](https://documentation.qonversion.io/docs/quickstart) — choose a mode, create a project, connect the stores.
* [API reference](https://documentation.qonversion.io/reference/v4/overview) — REST API v4.
* [For agents](https://documentation.qonversion.io/docs/for-agents) — MCP servers, machine-readable docs, ready-made prompts.

## What this SDK does

* **Collects purchases** and sends them to Qonversion, where they are confirmed with the store instead of being trusted from the device.
* **Resolves entitlements** — one answer to "is this user premium right now", the same on every device the user signs in to.
* **Keeps the history** — trials, conversions, renewals, cancellations, refunds, upgrades and downgrades, as events you can query, export or forward.
* **Feeds Remote Configs and A/B tests** — change which products, paywalls and app behaviour your users see, and run A/B tests without shipping a release.
* **Feeds Apple Ads reporting** — see what each campaign, ad group and keyword returns in real revenue, not only in installs.
* **Renders screens built in the dashboard** — paywalls and onboarding, updated without shipping a release.

What happens when something fails — the standby service, fallback files and the uptime commitment
behind the platform: [reliability](https://qonversion.io/reliability).

## For agents

An agent can integrate this SDK end to end. The companion file [`AGENTS.md`](AGENTS.md) gives it the
current version, the documented method names and the rules it must not break, instead of what its
training data remembers.

**Read these docs as an agent.** The documentation exposes an MCP server at
`https://documentation.qonversion.io/mcp` — no account needed. Any page is available as markdown by
appending `.md` to its URL, and [`llms.txt`](https://documentation.qonversion.io/llms.txt) lists every page.

**Work on your project data as an agent.** The Qonversion MCP server at `https://mcp.qonversion.io/mcp`
exposes the platform's resources as tools. Reading Apple Ads — campaign reports, time series and the
connection status — is on for all accounts. **Changing campaigns — bids, budgets and campaign status
— is a closed beta, switched on per account on request**; outside it those tools are not available,
so ask support to enable it before wiring an agent to them. The agent authenticates as you over
OAuth 2.1, each tool is gated by its own scope, and no Qonversion key is handed to the model.

Destructive tools and Apple Ads changes that increase spend do not fire on the first call: they
return a short-lived token addressed to the human operator, and completing the action requires
echoing the resource id verbatim and giving a reason, which is recorded in the audit log. Pausing an
entity or lowering a value is **not** parked — it applies immediately. The full tool list, the
per-client setup and the scopes are in
[MCP Server](https://documentation.qonversion.io/docs/mcp-server).

**Have an agent integrate this SDK.** Paste this into Claude Code, Cursor, Codex or any coding agent
working in your app's repository:

> Integrate the Qonversion SDK into this app.
>
> Read the official documentation before writing any code. The docs expose an MCP server at `https://documentation.qonversion.io/mcp` — use it if you can. Otherwise fetch pages directly; any page is available as markdown by appending `.md` to its URL, and `https://documentation.qonversion.io/llms.txt` lists every page.
>
> Steps:
> 1. Check with me that a Qonversion project exists and the app stores are connected — project key, App Store shared secret and App Store ID, Google Play service account key. This is step 2 of the quick start, I have to do it in the dashboard, and nothing validates until it is done. Google credentials can take up to 24 hours to start working.
> 2. Read `https://documentation.qonversion.io/docs/quickstart.md` and decide with me between Analytics Mode and Subscription Management Mode. Do not pick one silently.
> 3. Read the install page for this project's platform, linked from `https://documentation.qonversion.io/docs/install-sdk.md`. Use the SDK version the docs name, not one from memory.
> 4. Install and configure the SDK. Ask me for the Qonversion project key; it is in the dashboard under Settings → Developer → Keys. Never commit it to the repository.
> 5. Implement the mode we chose, following the documented method names exactly.
> 6. Show me the diff and tell me what you could not verify against the docs.

Prefer to do it by hand? The steps are in the [quick start](https://documentation.qonversion.io/docs/quickstart).

## Sample app

A Flutter app that initializes the SDK, lists products, makes a purchase, reads entitlements and
remote configs: [`example/`](example).

## Requirements

| | Minimum |
|---|---|
| Flutter | 3.0.0 |
| Dart SDK | 2.15.0 (`>=2.15.0 <4.0.0`) |
| iOS deployment target | 13.0 |
| macOS deployment target | 10.15 |
| Android `minSdkVersion` | 23 |

The plugin's own Android manifest declares `minSdkVersion 21`, but it depends on
`io.qonversion:sandwich`, which declares 23 — an app on 21 fails the manifest merger.

## Help

Contact us via [issues on GitHub](https://github.com/qonversion/flutter-sdk/issues) or the
[contact form](https://qonversion.io/contact-us) on our site.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/SuperFeature`)
3. Commit your Changes. Use small commits with separate logic. (`git commit -m 'Add some super feature'`)
4. Push to the Branch (`git push origin feature/SuperFeature`)
5. Open a Pull Request

## License

Qonversion SDK is available under the MIT license. See [LICENSE](LICENSE).
