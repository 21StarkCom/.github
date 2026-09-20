# 🧭 Ecosystem

> The Norse-named fleet — services, agents, tools, media and UI. Almost everything cross-cuts via **stark-skills**.

**47 repos** · [← the fleet](https://github.com/21StarkCom/.github/blob/main/profile/README.md#the-fleet) · ⭐ public · 🔒 internal · everything else private · 🤝 shared building block · ✏️ WIP · 🪦 retired

| Repo | Lang | What it is |
| :-- | :-- | :-- |
| **[stark-skills](https://github.com/21StarkCom/stark-skills)** ⭐ 🤝 | `TypeScript` | The source-of-truth hub for the stark agent workflows — every skill, slash command and agent for Claude Code and Codex. |
| **[bifrost](https://github.com/21StarkCom/bifrost)** ⭐ 🤝 | `Go` | The canonical multi-runtime marketplace and Go engine for stark bundles. |
| **[tyr](https://github.com/21StarkCom/tyr)** 🤝 | `Go` | The stateless vendor-action CLI — one typed, gated surface over every third-party system in the fleet. |
| **[stark-tui](https://github.com/21StarkCom/stark-tui)** 🔒 🤝 | `Go` | The fleet's own terminal-UI code — a zero-dependency toolkit, implemented twice (Go + Bun/TS). |
| **[stark-workspace](https://github.com/21StarkCom/stark-workspace)** 🤝 | `Shell` | The private repo behind the workspace constitution, the fleet map and the Mac setup. |
| **[fenrir](https://github.com/21StarkCom/fenrir)** | `TypeScript` | The multi-vendor agent client for ClickUp and GitHub — a typed library + CLI driven by Claude Code, not by humans in a vendor UI. |
| **[meridian](https://github.com/21StarkCom/meridian)** | `Go` | The fleet's automation plane and command-center — a long-lived Go service on GKE across the fleet. |
| **[alfred](https://github.com/21StarkCom/alfred)** | `Go` | The ticket tool — owns work-item creation and tracking for the fleet; sessions become ClickUp tickets. |
| **[idun](https://github.com/21StarkCom/idun)** | `TypeScript` | Aryeh's personal-ops maintenance CLI — one zero-dependency Bun binary holding the fleet's keep-it-fresh chores. |
| **[hermod](https://github.com/21StarkCom/hermod)** | `TypeScript` | The client, porcelain and fleet-coordination toolkit for cmux — one typed surface over its terminal control API. |
| **[sleipnir](https://github.com/21StarkCom/sleipnir)** | `TypeScript` | A CLI driving dedicated, persistent Chrome profiles for ad-hoc agent browser tasks. |
| **[user-management-agent](https://github.com/21StarkCom/user-management-agent)** | `Go` | uma — records how you onboard and offboard users across SaaS admin UIs and replays them. |
| **[frigg](https://github.com/21StarkCom/frigg)** | `Go` | The IT-ops housekeeping CLI + TUI, and owner of the local identity/infra cache. |
| **[apple-developer](https://github.com/21StarkCom/apple-developer)** | `Go` | The versioned text registry and audit trail of the Apple Developer / App Store Connect account. |
| **[workplan-tools](https://github.com/21StarkCom/workplan-tools)** | `Go` | The plan-intent layer for the Infra group — a Go CLI that snapshots the WorkPlan into typed artifacts. |
| **[workspace-admin-toolkit](https://github.com/21StarkCom/workspace-admin-toolkit)** | `Python` | A CLI for workspace admin across Google Workspace, Jira, GitHub, Slack, ClickUp, Anthropic and M365. |
| **[stark-agents](https://github.com/21StarkCom/stark-agents)** | `Python` | Domain-specialized code-review agents on Cloud Run behind MCP, with 3-LLM ensemble consensus. |
| **[stark-admin-agent](https://github.com/21StarkCom/stark-admin-agent)** | `TypeScript` | An LLM agent exposed as one MCP tool over stark-admin's capabilities. |
| **[stark-mcp](https://github.com/21StarkCom/stark-mcp)** | `Go` | A Go monorepo of MCP servers over the stark data platform — OAuth-gated, night-watch-scoped. |
| **[stark-automations](https://github.com/21StarkCom/stark-automations)** | `Python` | The GCP execution layer for the automation fleet — Cloud Scheduler → Pub/Sub → Functions calling Anthropic. |
| **[stark-data-core](https://github.com/21StarkCom/stark-data-core)** | `Python` | The data-platform service — a Strawberry GraphQL API with RBAC over PostgreSQL. |
| **[stark-slack-indexer](https://github.com/21StarkCom/stark-slack-indexer)** | `Go` | The Slack corpus search backend — a Go service on GCP with BigQuery hybrid search and an agentic ask layer. |
| **[stark-team](https://github.com/21StarkCom/stark-team)** | `TypeScript` | The Engineering Command Center — team dashboards, skill docs and operational analytics (Next.js + GraphQL). |
| **[infra-pulse](https://github.com/21StarkCom/infra-pulse)** | `Python` | The director's cockpit — Jira, Slack, GitHub, Calendar, Gmail and Drive into operational dashboards. |
| **[mimir](https://github.com/21StarkCom/mimir)** | `Swift` | The personal macOS encrypted secrets manager — a native SwiftUI app plus a mimir CLI, local-first. |
| **[mimir-automations](https://github.com/21StarkCom/mimir-automations)** | `JavaScript` | The JavaScript automations that Mímir runs to validate, rotate and discover — no secrets, ever. |
| **[transcript-optimizer](https://github.com/21StarkCom/transcript-optimizer)** | `Python` | A transcription and intelligence service — recordings → Chirp 3 → multi-stage LLM enhancement. |
| **[kotodama](https://github.com/21StarkCom/kotodama)** | `Go` | The multi-user voice → faithful-record product; the Go successor to transcript-optimizer. |
| **[lumiere](https://github.com/21StarkCom/lumiere)** | `Go` | The Go workspace for making and manipulating visual media — image generation and short video, behind MCP. |
| **[plume](https://github.com/21StarkCom/plume)** | `Go` | The pure-Go Office/PDF document toolkit — data in, an Excel/Word/PowerPoint/PDF file out. |
| **[stark-docs](https://github.com/21StarkCom/stark-docs)** | `Go` | Go tools for documents — stark-pdf (PDF → Markdown), extracted from stark-visual. |
| **[draupnir](https://github.com/21StarkCom/draupnir)** | `TypeScript` | The fleet's shared design system — components, tokens, themes and the statement-fx effects engine. |
| **[design-system-core](https://github.com/21StarkCom/design-system-core)** | `TypeScript` | A code-first design system POC — repo-sourced tokens and components with a browser playground. |
| **[stark-personal](https://github.com/21StarkCom/stark-personal)** | `TypeScript` | Aryeh's personal brand site — the code behind 21stark.com (Next.js, static-exported to GCS + CDN). |
| **[stark-showcase](https://github.com/21StarkCom/stark-showcase)** | `Go` | The HTML page hosting and gallery service — upload, validate, index, serve. |
| **[stark-stream-deck-sdk](https://github.com/21StarkCom/stark-stream-deck-sdk)** | `TypeScript` | The workspace for building Elgato Stream Deck plugins on the official Node.js/TypeScript SDK. |
| **[heimdall](https://github.com/21StarkCom/heimdall)** | `Go` | A personal cross-device notification relay for the Apple ecosystem, powered by your own APNs. |
| **[stark-invoices-collector](https://github.com/21StarkCom/stark-invoices-collector)** | `TypeScript` | A Chrome extension that harvests, renames and files vendor invoice PDFs on your logged-in sessions. |
| **[manual-auditor-project](https://github.com/21StarkCom/manual-auditor-project)** | `Python` | Data collection and harvesting orchestration for the Manual Auditor project. |
| **[gjallarhorn](https://github.com/21StarkCom/gjallarhorn)** ✏️ | `Swift` | The iOS app that harvests Plaud voice-recorder recordings over Bluetooth and syncs them to Google Drive. |
| **[homebrew-tap](https://github.com/21StarkCom/homebrew-tap)** | `Ruby` | The private Homebrew tap distributing the stark fleet's installable CLIs. |
| **[nastrond](https://github.com/21StarkCom/nastrond)** | `TypeScript` | The living code graveyard — retired repos and dead subsystems, sealed and kept to be remembered, never run. |
| **[stark-night-watch](https://github.com/21StarkCom/stark-night-watch)** | `Go` | The Go automation backend that meridian was forked from. |
| **[stark-writing](https://github.com/21StarkCom/stark-writing)** | `MDX` | Long-form writing sources for 21stark.com (MDX). |
| **[control-chrome](https://github.com/21StarkCom/control-chrome)** | `HTML` | A browser-control surface (HTML). |
| **[snyk-wiring-slice3-smoke](https://github.com/21StarkCom/snyk-wiring-slice3-smoke)** | `—` | A throwaway smoke-test repo for Snyk wiring. |
| **[.github](https://github.com/21StarkCom/.github)** ⭐ | `—` | The org profile, README and community-health defaults for the fleet. |
