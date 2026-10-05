# 🪦 Retired

> Terminated, decommissioned or superseded. Kept for history — not for use.

**22 repos** · [← the fleet](https://github.com/21StarkCom/.github/blob/main/profile/README.md#the-fleet) · ⭐ public · 🔒 internal · everything else private · 🤝 shared building block · ✏️ WIP · 🪦 retired · [not in the fleet](exclusions.md)

| Repo | Lang | What it is |
| :-- | :-- | :-- |
| **[infra-sentinel](https://github.com/21StarkCom/infra-sentinel)** | `Go` | Retired self-hosted observability stack (Grafana/Loki/Prometheus) — both deployments torn down, the last on 2026-09-16; kept for history, nothing runs. |
| **[stark-insights](https://github.com/21StarkCom/stark-insights)** | `Go` | An archived, decommissioned activity-insights pipeline (Claude Code hooks → BigQuery); kept for history. |
| **[slack-investigator](https://github.com/21StarkCom/slack-investigator)** | `Python` | A retired Slack-export analysis CLI — superseded by stark-slack-indexer. |
| **[agent-native-gcp](https://github.com/21StarkCom/agent-native-gcp)** | `HCL` | An archived early agent-native GCP Terraform experiment. |
| **[stark-skills](https://github.com/21StarkCom/stark-skills)** ⭐ | `TypeScript` | The archived former hub for the stark agent workflows — absorbed by bifrost, buried in nastrond. |
| **[control-chrome](https://github.com/21StarkCom/control-chrome)** | `HTML` | A one-shot roadmap-snapshot analysis — it ran once, had no consumers and was retired. |
| **[design-system-core](https://github.com/21StarkCom/design-system-core)** | `TypeScript` | A code-first design-system POC with a browser playground — the POC finished, the playground was decommissioned and nothing consumed it. |
| **[devops-sandbox](https://github.com/21StarkCom/devops-sandbox)** | `HCL` | Terraform for per-team GCP sandbox projects — a devops experiment that never went into production. |
| **[infra-pulse](https://github.com/21StarkCom/infra-pulse)** | `Python` | An ops-dashboard tool — its cloud stack was torn down and it was retired in the fleet consolidation, not migrated. |
| **[stark-2nd-brain-cli](https://github.com/21StarkCom/stark-2nd-brain-cli)** | `Go` | The standalone Go second-brain CLI — folded into atlas, whose TypeScript engine replaced it. |
| **[stark-2nd-brain-hub](https://github.com/21StarkCom/stark-2nd-brain-hub)** | `Go` | The Go second-brain gateway — consolidated into atlas, whose hub is its successor. |
| **[stark-admin-agent](https://github.com/21StarkCom/stark-admin-agent)** | `TypeScript` | An LLM agent meant to expose admin work as one MCP tool — it was never registered as a live MCP, and admin work goes through tyr instead. |
| **[stark-agents](https://github.com/21StarkCom/stark-agents)** | `Python` | Domain-specialized code-review agents on Cloud Run behind MCP — dormant, and superseded by `/code-review`. |
| **[stark-automations](https://github.com/21StarkCom/stark-automations)** | `Python` | The GCP execution layer for an earlier automation fleet (Cloud Scheduler → Pub/Sub → Functions) — dormant for months, then retired in the fleet consolidation. |
| **[stark-data-core](https://github.com/21StarkCom/stark-data-core)** | `Python` | The data-platform service (GraphQL with RBAC over PostgreSQL) — torn down, its role taken over by the tyr/frigg local cache and meridian's ingest. |
| **[stark-docs](https://github.com/21StarkCom/stark-docs)** | `Go` | Go tools for documents, extracted from stark-visual — a doc toolbox with no consumers, retired in the fleet consolidation. |
| **[stark-mcp](https://github.com/21StarkCom/stark-mcp)** | `Go` | A Go monorepo of MCP servers over the stark data platform — superseded when the fleet traded its remote MCP servers for CLIs. |
| **[stark-night-watch](https://github.com/21StarkCom/stark-night-watch)** | `Go` | The Go automation backend meridian was forked from — superseded by meridian. |
| **[stark-team](https://github.com/21StarkCom/stark-team)** | `TypeScript` | A team-dashboard and operational-analytics console (Next.js + GraphQL) — idle for months, then retired in the fleet consolidation. |
| **[stark-writing](https://github.com/21StarkCom/stark-writing)** | `MDX` | Long-form writing sources for 21stark.com (MDX) — retired once a fleet scan found no live consumer. |
| **[transcript-optimizer](https://github.com/21StarkCom/transcript-optimizer)** | `Python` | A transcription and intelligence service (recordings → Chirp 3 → multi-stage LLM enhancement) — dormant, with no users, and never worth a Go rewrite. |
| **[workspace-admin-toolkit](https://github.com/21StarkCom/workspace-admin-toolkit)** | `Python` | A Python CLI for workspace admin across SaaS vendors — superseded by tyr's connectors. |
