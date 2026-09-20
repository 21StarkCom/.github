# 🚫 Not in the fleet

> Repos that live in the `21StarkCom` org but are deliberately absent from the fleet tables.

[← the fleet](https://github.com/21StarkCom/.github/blob/main/profile/README.md#the-fleet)

Every repo in the org is either a row in one of the four fleet tables or matches a
rule below. [`scripts/fleet-check.sh`](../scripts/fleet-check.sh) enforces that, and
fails naming any repo that is neither — so a new repo cannot quietly go unlisted the
way ten of them once did.

Each rule is a shell glob; a bare name is a glob that matches only itself. A repo may
not both match a rule and hold a row — the check treats that as drift too.

| Rule | Why it is not a fleet repo |
| :-- | :-- |
| `devops-cc-environments` | Evinced work, parked in this org. Self-hosted Claude Code runners for the day job, not the playground — the workspace map files it under Evinced, not the fleet. |
| `plaud-sdk-public` | Third-party code. An archive of Plaud's own SDK, kept because upstream pulled it and `gjallarhorn` needs it. Not ours to list or publish. |
| `*-probe` | Ticket-scoped verification probes. Created to prove one behaviour, archived the same day. |
| `*-smoke` | Throwaway smoke-test repos for wiring up a vendor or a pipeline. |
| `*-evaluation-*` | Disposable agent-evaluation repos, usually dated and named after the ticket that spawned them. |

To see what the rules match right now:

```sh
bash scripts/fleet-check.sh --list-excluded
```

**Being archived is not a reason.** `agent-native-gcp` is archived and private and is
a real [retired](retired.md) row; a rule that excluded archived repos would have
dropped it from the page, and the only evidence of the loss would have been the
missing row. Retirement is a table, not an exclusion.
