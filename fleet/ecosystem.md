# 🧭 Ecosystem

> The working fleet — services, agents, tools, media and UI, many under Norse names. Almost everything cross-cuts via **bifrost**.

**42 repos** · [← the fleet](https://github.com/21StarkCom/.github/blob/main/profile/README.md#the-fleet) · ⭐ public · 🔒 internal · everything else private · 🤝 shared building block · ✏️ WIP · 🪦 retired · [not in the fleet](exclusions.md)

| Repo | Lang | What it is |
| :-- | :-- | :-- |
| **[bifrost](https://github.com/21StarkCom/bifrost)** ⭐ 🤝 | `TypeScript` | The source-of-truth hub for the stark agent workflows — every skill and tool for Claude Code, served straight from source as its own plugin marketplace. |
| **[tyr](https://github.com/21StarkCom/tyr)** 🤝 | `Go` | The vendor-integration capability library — one typed, gated surface over every third-party system in the fleet; library-only since its CLI moved to frigg. |
| **[stark-tui](https://github.com/21StarkCom/stark-tui)** 🔒 🤝 | `Go` | The fleet's own terminal-UI code — a zero-dependency toolkit, implemented twice (Go + Bun/TS). |
| **[idavoll](https://github.com/21StarkCom/idavoll)** 🤝 | `Shell` | The private repo behind the workspace constitution, the fleet map and the Mac setup. |
| **[fenrir](https://github.com/21StarkCom/fenrir)** | `TypeScript` | The multi-vendor agent client for ClickUp and GitHub — a typed library + CLI driven by Claude Code, not by humans in a vendor UI. |
| **[meridian](https://github.com/21StarkCom/meridian)** | `Go` | The fleet's automation plane and command-center — a long-lived Go service on GKE across the fleet. |
| **[alfred](https://github.com/21StarkCom/alfred)** | `Go` | The ticket tool — owns work-item creation and tracking for the fleet; sessions become ClickUp tickets. |
| **[idun](https://github.com/21StarkCom/idun)** | `TypeScript` | Aryeh's personal-ops maintenance CLI — one zero-dependency Bun binary holding the fleet's keep-it-fresh chores. |
| **[claude-seats](https://github.com/21StarkCom/claude-seats)** | `TypeScript` | A standalone Claude Code seat manager — seats, live usage and the rotation daemon — sharing idun's seat store on purpose, while its daemon keeps its own files and lock. |
| **[hermod](https://github.com/21StarkCom/hermod)** | `TypeScript` | The client, porcelain and fleet-coordination toolkit for cmux — one typed surface over its terminal control API. |
| **[houston](https://github.com/21StarkCom/houston)** | `TypeScript` | Epic progress overwatch — a local-first, push-only server built for agents to report gate transitions to, with one page of parallel tracks per epic; no agent reports to it yet. |
| **[ratatoskr](https://github.com/21StarkCom/ratatoskr)** ✏️ | `TypeScript` | The squirrel carrying messages between agents — a Claude Code channel bridging Codex → Claude, and a relay for permission prompts. |
| **[sleipnir](https://github.com/21StarkCom/sleipnir)** | `TypeScript` | Two sibling products — Sleipnir, a CLI driving dedicated, persistent Chrome profiles for ad-hoc agent browser tasks, and Huginn, the extension and native host that drive the operator's own Chrome. |
| **[goldfinger](https://github.com/21StarkCom/goldfinger)** ✏️ | `Swift` | Background computer use for AI agents — a helper-app daemon that holds the OS permissions, driven by a CLI, operating native apps without taking focus; macOS first. |
| **[lucius](https://github.com/21StarkCom/lucius)** ✏️ | `TypeScript` | The interactive brainstorming partner — a terminal worker on the Claude Agent SDK that recalls, argues and digs, and ships nothing. |
| **[hygiea](https://github.com/21StarkCom/hygiea)** | `Go` | The repo-hygiene agent — proves dead code, stale docs and unused deps before removing any of them, and never merges. |
| **[user-management-agent](https://github.com/21StarkCom/user-management-agent)** | `Go` | uma — records how you onboard and offboard users across SaaS admin UIs and replays them. |
| **[frigg](https://github.com/21StarkCom/frigg)** | `Go` | The IT-ops housekeeping CLI + TUI, and owner of the local identity/infra cache. |
| **[muninn](https://github.com/21StarkCom/muninn)** ✏️ | `Go` | Odin's raven — the planned operator-triggered harvester that will read the fleet through frigg and accrete what it learns into durable entity notes; only its offline core is built. |
| **[apple-developer](https://github.com/21StarkCom/apple-developer)** | `Go` | The versioned text registry and audit trail of the Apple Developer / App Store Connect account. |
| **[workplan-tools](https://github.com/21StarkCom/workplan-tools)** | `Go` | The plan-intent layer for the Infra group — a Go CLI that snapshots the WorkPlan into typed artifacts. |
| **[yggdrasil](https://github.com/21StarkCom/yggdrasil)** ✏️ | `TypeScript` | The world-tree for goals — the planned issue-tracker app that will show every goal as a tree of all its work (epics, their items, linked items and the children of linked epics) with one honest progress %; only its spec and a throwaway spike are built. |
| **[stark-slack-indexer](https://github.com/21StarkCom/stark-slack-indexer)** | `Go` | The Slack corpus search backend — a Go service on GCP with BigQuery hybrid search and an agentic ask layer. |
| **[assay](https://github.com/21StarkCom/assay)** ✏️ | `Go` | The daily verified-trend newsletter — finds what is new in a field, scores each candidate against a rubric and publishes only what clears the bar. |
| **[mimir](https://github.com/21StarkCom/mimir)** | `Swift` | The personal macOS encrypted secrets manager — a native SwiftUI app plus a mimir CLI, local-first. |
| **[mimir-automations](https://github.com/21StarkCom/mimir-automations)** | `JavaScript` | The JavaScript automations Mímir once ran to validate, rotate and discover — orphaned since Mímir retired its automation engine on 2026-09-21; kept, no secrets, ever. |
| **[kotodama](https://github.com/21StarkCom/kotodama)** | `Go` | The multi-user voice → faithful-record product, in Go with a Next.js web app. |
| **[lumiere](https://github.com/21StarkCom/lumiere)** | `Go` | The Go workspace for making and manipulating visual media — image generation and editing and short video, as standalone CLIs and a library. |
| **[plume](https://github.com/21StarkCom/plume)** | `Go` | The pure-Go Office/PDF document toolkit — data in, an Excel/Word/PowerPoint/PDF file out. |
| **[bragi](https://github.com/21StarkCom/bragi)** ✏️ | `—` | The god of poetry — the planned Go toolkit for streaming voice: speech-to-text and text-to-speech as streams, a library plus thin CLIs so the fleet's agents can listen and speak; not yet built. |
| **[draupnir](https://github.com/21StarkCom/draupnir)** | `TypeScript` | The fleet's shared design system — components, tokens, themes and the statement-fx effects engine. |
| **[stark-personal](https://github.com/21StarkCom/stark-personal)** | `TypeScript` | Aryeh's personal brand site — the code behind 21stark.com (a dynamic Next.js app on Cloud Run, with an admin backoffice). |
| **[stark-showcase](https://github.com/21StarkCom/stark-showcase)** | `Go` | The HTML page hosting and gallery service — upload, validate, index, serve. |
| **[stark-stream-deck-sdk](https://github.com/21StarkCom/stark-stream-deck-sdk)** | `TypeScript` | The workspace for building Elgato Stream Deck plugins on the official Node.js/TypeScript SDK. |
| **[heimdall](https://github.com/21StarkCom/heimdall)** | `Go` | A personal cross-device notification relay for the Apple ecosystem, powered by your own APNs. |
| **[stark-invoices-collector](https://github.com/21StarkCom/stark-invoices-collector)** | `JavaScript` | Playwright connectors that fetch missing vendor receipts from billing pages and mail them to the card that paid. |
| **[manual-auditor-project](https://github.com/21StarkCom/manual-auditor-project)** | `Python` | Data collection and harvesting orchestration for the Manual Auditor project. |
| **[gjallarhorn](https://github.com/21StarkCom/gjallarhorn)** ✏️ | `Swift` | The iOS app being built to harvest Plaud voice-recorder recordings over Bluetooth and sync them to Google Drive; pre-1.0, and its upload has not yet run end to end on a device. |
| **[vor](https://github.com/21StarkCom/vor)** | `Swift` | Senses the Mac's radios — what is near and how strong it is, over a CoreBluetooth core that also builds for iOS. |
| **[homebrew-tap](https://github.com/21StarkCom/homebrew-tap)** | `Shell` | The private Homebrew tap distributing the stark fleet's installable CLIs. |
| **[nastrond](https://github.com/21StarkCom/nastrond)** | `TypeScript` | The living code graveyard — retired repos and dead subsystems, sealed and kept to be remembered, never run. |
| **[.github](https://github.com/21StarkCom/.github)** ⭐ | `Shell` | The org profile, the public fleet pages and their saga, and the fleet's reusable secret-scan workflow. |
