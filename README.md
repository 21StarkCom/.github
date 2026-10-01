# .github

The public front door of the **21StarkCom** org. This repo holds four things:

- **The org landing page.** GitHub renders [`profile/README.md`](profile/README.md) at
  github.com/21StarkCom.
- **The fleet pages.** Four tables under [`fleet/`](fleet/) list every repo in the fleet,
  each with its language, its visibility and one line on what it is. A fifth page says
  which org repos hold no row, and why.
- **The saga.** [`fleet/saga.md`](fleet/saga.md), *The Saga of House Stark*, tells the
  fleet as one quest, a chapter for each repo whose name comes from an old story.
- **The fleet's reusable secret scan.** [`secret-scan.yml`](.github/workflows/secret-scan.yml)
  is a gitleaks workflow the fleet's repos pin by commit SHA. It is the CI half of the
  org's replacement for GitHub Secret Protection, which is off org-wide on purpose.

It also runs the checks that keep the pages true: the tables against the live org, and
every public link as a logged-out visitor sees it.

**Status:** active. One operator maintains it, and every change lands by PR.

## Layout

| Path | What it is |
| :-- | :-- |
| `README.md` | This file. |
| `profile/README.md` | The org landing page: the open-source repo, the fleet section table, the two "N repositories" headlines, the by-language footer and a link to the saga. |
| `fleet/ecosystem.md` | Fleet table: the working fleet (services, agents, tools, media and UI). |
| `fleet/infrastructure.md` | Fleet table: Terraform and GCP foundations. |
| `fleet/second-brain.md` | Fleet table: the second-brain code. |
| `fleet/retired.md` | Fleet table: repos that were retired, decommissioned or superseded, kept for history. |
| `fleet/exclusions.md` | The org repos that hold no row on purpose, one shell-glob rule each, with a reason. |
| `fleet/saga.md` | The Saga of House Stark, the fleet told as one story. It is not a fleet table, and nothing counts it. |
| `scripts/fleet-check.sh` | Checks the profile and the four fleet tables against the live org. |
| `.github/workflows/secret-scan.yml` | The reusable gitleaks scan the fleet pins. |
| `.github/workflows/secret-scan-self.yml` | This repo's own caller of that scan, kept by hand. |
| `.github/workflows/fleet-drift.yml` | Runs `scripts/fleet-check.sh` in CI. |
| `.github/workflows/link-check.yml` | Checks every link on `profile/` and `fleet/` anonymously with lychee. |
| `.gitleaks.toml` | This repo's gitleaks rules, and how to handle a false positive. |
| `.lycheeignore` | The allowlist of non-public repo links, which answer 404 to an anonymous visitor on purpose. |
| `lychee.toml` | Link-check settings: accepted codes, pacing and retries. It is shared by CI and a local run. |

## The reusable secret scan

### Calling it

In the fleet you rarely write a caller yourself: 21stark's Terraform renders one into
each repo it manages and pins it. By hand, a caller looks like this:

```yaml
name: secret-scan

on:
  pull_request:
  push:
    branches: [main]
  merge_group:

permissions:
  contents: read

# Callers own concurrency. Cancel PR runs only, never a push run.
concurrency:
  group: secret-scan-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}

jobs:
  secret-scan:
    uses: 21StarkCom/.github/.github/workflows/secret-scan.yml@<sha>
```

- **The job id is part of the contract.** Call the job `secret-scan` and give it no
  `name:`. The check context is then exactly `secret-scan / secret-scan`, the caller's
  half and the called half. A ruleset that requires the scan has to name that literal
  string, so renaming either half breaks it.
- **Pin a full commit SHA**, never a tag or a branch.
- **Callers own concurrency.** The reusable workflow declares no `concurrency` group,
  because a group declared there would apply to every caller at once. Never cancel a push
  run: each push scans its own commit range, and a cancelled one leaves those commits
  unscanned.
- **It scans the incoming commits only**: the PR's range, the pushed range on the default
  branch, or the merge-queue group's range. It cannot see a secret committed before it
  landed, so a green check means "these commits added none", not "this repo has none".
  Any other event (`workflow_dispatch`, `schedule`, `pull_request_target`) is refused.
- **It proves itself before it scans.** A self-test feeds the scanner a synthetic GitHub
  token and, unless `selftest_rule_id` is empty, a bare token for the caller's custom rule.
  It fails when either goes unseen, and it refuses to run if the caller's config file is
  missing.

Inputs, all optional:

| Input | Default | Notes |
| :-- | :-- | :-- |
| `config_path` | `.gitleaks.toml` | The scan refuses to run if the file is missing. |
| `runs_on` | `ubuntu-latest` | Must be a Linux x86_64 runner; the job checks this and fails fast otherwise. |
| `gitleaks_version` / `gitleaks_sha256` | A pinned gitleaks release (`8.30.1` today) and its checksum | Bump them together. The workflow's defaults are the source of truth. |
| `selftest_rule_id` | `google-oauth-client-secret` | The custom rule the self-test asserts fires. `""` checks the stock rules only. |
| `selftest_probe_prefix` / `selftest_probe_hex_bytes` | `GOCSPX-` / `14` | Must build a token that `selftest_rule_id` matches. The three inputs are one unit. |

### Releasing a change to it

A change reaches the fleet in three steps, and no other repo sees it before the third:

1. **Merge it here.** This repo's own caller, `secret-scan-self.yml`, calls the workflow
   as `./.github/workflows/secret-scan.yml`, so a PR that edits the scan is checked by the
   version it proposes, and a change that breaks the scan fails here first. The flip side:
   on such a PR, a green check means "the proposed scanner ran", not "the scanner still
   works". Read the diff.
2. **Tag the merged commit** `secret-scan-v<n>`. The tags so far are `secret-scan-v1` and
   `secret-scan-v1.1`; `git tag -l 'secret-scan-v*'` lists the current set.
3. **Bump the pin in [21stark](https://github.com/21StarkCom/21stark)** to that tag's full
   commit SHA. Its next apply re-renders every caller. Until then, the fleet keeps running
   the old pin.

## Editing the fleet pages

Every repo in the org is exactly one row in one of the four tables, or it matches one
rule in `fleet/exclusions.md`. `scripts/fleet-check.sh` enforces this.

A row looks like this:

```markdown
| **[<name>](https://github.com/21StarkCom/<name>)** ⭐ 🤝 | `Go` | One line on what it is. |
```

- **Lang** is the primary language GitHub reports for the repo, written exactly as GitHub
  writes it (`HCL`, not Terraform). When GitHub reports none, it is `—`.
- **Badges.** ⭐ means public, 🔒 means internal, and no badge means private. They must
  match GitHub. 🤝 (shared building block) and ✏️ (WIP) are editorial.
- **The prose** is one line. A private repo gets nothing in these tables beyond its name
  and that line.

**Adding a row** means changing every figure that counts it:

1. the table's `**N repos**` line (`**1 repo**` when there is one);
2. that table's count in the section table in `profile/README.md`;
3. both "N repositories" headlines in `profile/README.md`;
4. the by-language footer in `profile/README.md`: the language's own count, or `+N others`;
5. for a repo that is not public, one anchored entry in `.lycheeignore`
   (`^https://github\.com/21StarkCom/<name>$`), and one more in the count of the
   `# ── PRIVATE (n)` or `# ── INTERNAL (n)` header it sits under;
6. for a repo whose name comes from an old story, a chapter in `fleet/saga.md`, one more in
   its prologue's count of such names, and its legend in its own README. Nothing checks
   this one. No other repo's README changes with it; see **Saga links** below.

**Moving a row** between tables changes only the two tables' `**N repos**` lines and their
two section counts. The headlines and the footer stay as they are.

**Retiring a repo** is a move to `fleet/retired.md`, not an exclusion. Rewrite its line in
the past tense, with the reason or the successor. Say "archived" only of a repo GitHub
reports as archived; otherwise say "retired".

**Deleting a repo** from the org removes its row and every figure above, including its
`.lycheeignore` entry, and its saga chapter, the hand-off into it and every link to it in
`fleet/saga.md`. A saga link left behind 404s once the entry is gone, and link-check goes
red. Links to it in other repos' READMEs stay; see **Saga links** below.

**Saga chapters.** A private repo's chapter in `fleet/saga.md` shows its fleet-table line
there word for word; bifrost's full chapter carries its legend instead. Change the row and
the chapter in the same PR. When a repo's facts change, its legend changes with them.
bifrost's chapter repeats the legend that opens bifrost's README word for word, except for
the parts the saga owns. The hand-off that ends the legend, the supporting cast (a bullet
here), the nav line (which links the saga by anchor) and any link to a since-deleted repo
change with the saga, while bifrost's README keeps the ones it has. When the rest of its
legend changes, change the chapter to match, never the other way round. Nothing checks the
saga against the tables or against bifrost's README, so compare them by eye.

**Saga links** live in `fleet/saga.md` alone. Only the saga ties one repo to another in the
story: the order of the chapters, the acts, the hand-offs, the nav lines and the supporting
cast. A repo's README carries no more of the saga than its own legend and one link to the
saga. That legend names no other repo and hands off to no next chapter, though the myth
behind its name may mention a god another repo is named for. The README gets no
`← prev · The saga · next →` nav line and no supporting cast or "In the saga" line that
points at another repo or its chapter. Adding, changing or removing a chapter edits
`fleet/saga.md`, never another repo's README. What READMEs already carry, this one's
included, stays as it is: their nav lines, supporting casts and "In the saga" lines, and
the repos their legends name and hand off to. Add no new ones, and neither update nor
remove the old ones.

## Checks

### Run them locally

```sh
bash scripts/fleet-check.sh                  # the tables against the live org; exit 1 on drift
bash scripts/fleet-check.sh --list-excluded  # what the exclusion rules match today
lychee profile fleet                         # the link check CI runs, from the repo root
```

- **`fleet-check.sh`** needs `gh` authenticated with org-wide metadata read. Most of the
  org is private, and a repo-scoped token sees only the public repos, so the check would
  pass for the wrong reason. It checks that no repo holds two rows, that every org repo is
  a row or an exclusion and never both, that no row names a repo that is gone, and that the
  Lang cells, the row links, the visibility badges, each table's `**N repos**`, the
  profile's section counts, its two headlines and its by-language footer all match. It
  also checks that `.lycheeignore` tracks the non-public rows in both directions. It runs
  under macOS `/bin/bash` 3.2.
- **`lychee profile fleet`** needs the lychee version CI pins (`LYCHEE_VERSION` in
  `link-check.yml`, 0.24.2 today). It reads `lychee.toml` and `.lycheeignore` from the
  repo root. Run it with `GITHUB_TOKEN` and `GH_TOKEN` unset: lychee picks up a token from
  the environment without saying so, and an authenticated probe passes on links a visitor
  cannot open.

### In CI

| Workflow | Check | Runs on | What it does |
| :-- | :-- | :-- | :-- |
| `fleet-drift.yml` | `fleet-drift` | PRs touching `fleet/**`, `profile/README.md`, `scripts/fleet-check.sh`, `.lycheeignore` or itself; push to `main`; weekly; on demand | Runs `bash scripts/fleet-check.sh` with the `CATALOG_READ_TOKEN` secret, an org-read token. Without the secret, it skips with a warning rather than check blind. |
| `link-check.yml` | `link-check` | every PR; push to `main`; merge queue; daily | Runs lychee anonymously over `profile/` and `fleet/`. It refuses to run with a token set, fails on a stale or malformed `.lycheeignore` entry, proves it still catches a 404, and refuses a clean run that checked zero links. |
| `secret-scan-self.yml` | `secret-scan / secret-scan` | PRs; push to `main`; merge queue | Scans this repo's incoming commits with the reusable workflow from the same tree. |

**No check is required.** The repo has no ruleset on `main`, so read every check here as
advisory. A red check never blocks a merge, and it still means something is wrong.

## The public rule

Everything in this repo is public, and the pages speak for a mostly private fleet. No
line may carry a secret, an internal hostname or IP (21stark.com is the one public host),
a cloud project ID or number, a bucket or cluster name, an email address, a port, a
bundle ID, an Apple team ID, a credential-store item ID, a ticket number, a ClickUp or
Slack ID, or the name of an employer, a customer or an employer's vendor. In the fleet
tables a private repo gets its name and one line, and nothing more. In the saga it also
gets the meaning of its name and a one-sentence hand-off to the next chapter; its full
legend stays in its own README. Older comments in the workflows, `scripts/fleet-check.sh`
and `.lycheeignore` still cite ticket numbers. Drop them when you next touch those lines,
and add no new ones.

## Where it sits in the fleet

This repo is the org's front door. Its settings and its description are Terraform in
[21stark](https://github.com/21StarkCom/21stark), which also renders and pins
the secret-scan caller in every repo it manages. This repo is the one exception: here, that
caller's path already holds the reusable workflow itself, so the caller lives beside it
under a different name, written by hand. The flagship open-source repo,
[bifrost](https://github.com/21StarkCom/bifrost), is linked from the landing page. In the
saga, this repo is the sentry every crossing passes, in bifrost's supporting cast.

Read the fleet as one story in [The Saga of House Stark](fleet/saga.md).
