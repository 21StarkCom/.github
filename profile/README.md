<div align="center">

# 21Stark

**One engineer's platform org, run as a playground.**
Multi-agent tooling, infra-as-code and `MCP` servers. `Claude` + `Codex` + `Gemini`, in parallel.

<br>

![Go](https://img.shields.io/badge/Go-00ADD8?style=flat-square&logo=go&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat-square&logo=typescript&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)
![GCP](https://img.shields.io/badge/Google_Cloud-4285F4?style=flat-square&logo=googlecloud&logoColor=white)
![Claude](https://img.shields.io/badge/Claude-D97757?style=flat-square&logo=anthropic&logoColor=white)

`58 repositories` · `Go` + `TypeScript` first · `one operator` · `ships to main`

[**Aryeh Kiovetsky**](https://21stark.com) · [**Writing**](https://21stark.com/blog)

</div>

---

### ⭐ Open source

The public face of the fleet — the rest is private by default.

- **[stark-skills](https://github.com/21StarkCom/stark-skills)** — the development workflow for `Claude Code` and `Codex`. Human-gated spec and plan, check-gated build, evidence-contract PR review, multi-agent IaC review, session ops. **The flagship.**
- **[bifrost](https://github.com/21StarkCom/bifrost)** — the marketplace. One catalog of skills, prompts, commands, agents and `MCP` servers, rendered per runtime for `Claude Code`, `Codex` and `Gemini`.

---

### The fleet

**58 repositories, run solo.** Grouped the way the workspace itself is — each row opens a full index with every repo and what it is.

| Section | Repos | What lives here |
| :-- | :-- | :-- |
| 🧭 **[Ecosystem](https://github.com/21StarkCom/.github/blob/main/fleet/ecosystem.md)** | 46 | The Norse-named fleet — services, agents, tools, media and UI. Almost everything cross-cuts via `stark-skills`. |
| 🏗️ **[Infrastructure](https://github.com/21StarkCom/.github/blob/main/fleet/infrastructure.md)** | 4 | Terraform + GCP foundations — GitHub-as-code and the shared platform every service builds on. |
| 🧠 **[Second brain](https://github.com/21StarkCom/.github/blob/main/fleet/second-brain.md)** | 3 | Atlas — the LLM-native knowledge engine and the `brain` CLI over the vaults. |
| 🪦 **[Retired](https://github.com/21StarkCom/.github/blob/main/fleet/retired.md)** | 5 | Terminated, decommissioned or superseded. Kept for history. |

<sub>By language: **22** Go · **14** TypeScript · **8** Python · **5** Terraform (HCL) · **2** Swift · **+5** others</sub>

---

### How it works here

| | |
| :-- | :-- |
| **Branch + PR for everything** | No exceptions. Nothing lands on `main` by hand. |
| **Findings land on the PR** | Every review's output is attached. Nothing lost. |
| **Test live** | The real cloud surface, not localhost. |
| **Go and TypeScript** | No new Python. |

<div align="center">
<br>
<sub>Ships to <code>main</code>. No SLAs. That's the point.</sub>
</div>
