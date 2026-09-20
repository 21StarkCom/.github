#!/usr/bin/env bash
# fleet-check.sh — prove the org landing page still describes the real org.
#
# The fleet tables are hand-written on purpose: the "What it is" column is
# curated prose and no API knows it. Everything else on the page is a machine
# fact — which repos exist, what they are written in, how visible they are, how
# many there are — and every one of those facts is checked here against the
# live org.
#
#   bash scripts/fleet-check.sh                 # check; exit 1 on drift
#   bash scripts/fleet-check.sh --list-excluded # what the exclusion rules match today
#
# Needs `gh` authenticated with org-wide metadata:read — most of this org is
# private, and a repo-scoped token silently sees only the public handful.
#
# Bash 3.2 clean on purpose: the documented invocation is `bash scripts/…`, and
# on macOS that is /bin/bash 3.2, which has no associative arrays.

set -euo pipefail

# `sort`, `join`, `comm` and `uniq` below all have to agree on one ordering, and
# a locale-aware collation folds punctuation where join's comparison does not.
export LC_ALL=C

ORG=21StarkCom
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
PROFILE=$ROOT/profile/README.md
EXCLUSIONS=$ROOT/fleet/exclusions.md

# Fleet tables, in the order the profile's section table lists them.
SECTIONS=(ecosystem infrastructure second-brain retired)

# Refuse a mistyped flag: silently running the full check under it would report
# OK for an operation nobody asked for.
if [[ $# -gt 1 || ( $# -eq 1 && $1 != --list-excluded ) ]]; then
  echo "usage: bash scripts/fleet-check.sh [--list-excluded]" >&2
  exit 2
fi

fail_count=0
fail() { printf '  x %s\n' "$1"; fail_count=$((fail_count + 1)); }
ok() { printf '  . %s\n' "$1"; }

# --- the live org -------------------------------------------------------------
# One enumeration, three columns; everything below slices this rather than
# paging the org again. Archived repos come back like any other — they are
# retired, not gone. (`type=all` is the default; it is spelled out so nobody
# narrows it to `sources` or `public`. No value of `type` hides archived repos.)
org_all=$(gh api "orgs/$ORG/repos?type=all&per_page=100" --paginate \
  --jq '.[] | [.name, (.language // "—"), .visibility] | @tsv' | sort)
org_tsv=$(cut -f1,2 <<<"$org_all")
org_vis=$(cut -f1,3 <<<"$org_all")
org_names=$(cut -f1 <<<"$org_all")
org_total=$(grep -c . <<<"$org_names")

# --- the exclusion rules ------------------------------------------------------
# One glob per table row in fleet/exclusions.md; a bare name is a glob that
# matches only itself.
rules=()
# shellcheck disable=SC2016  # the backticks are Markdown in the sed pattern
while IFS= read -r rule; do rules+=("$rule"); done \
  < <(sed -nE 's/^\| `([^`]+)` \|.*/\1/p' "$EXCLUSIONS")
[[ ${#rules[@]} -gt 0 ]] || { echo "no exclusion rules parsed from $EXCLUSIONS" >&2; exit 2; }

excluded() {
  local name=$1 rule
  for rule in "${rules[@]}"; do
    # shellcheck disable=SC2254  # the rule is a glob on purpose
    case $name in $rule) return 0 ;; esac
  done
  return 1
}

if [[ ${1:-} == --list-excluded ]]; then
  while read -r name; do
    excluded "$name" && echo "$name"
  done <<<"$org_names"
  exit 0
fi

# --- the page's own rows ------------------------------------------------------
# | **[name](url)** ⭐ 🤝 | `Lang` | prose |  ->  name \t url \t badges \t lang
row_tsv() {
  # shellcheck disable=SC2016  # the backticks are Markdown in the sed pattern
  sed -nE 's/^\| \*\*\[([a-zA-Z0-9._-]+)\]\(([^)]*)\)\*\*([^|]*)\| `([^`]*)`.*/\1\t\2\t\3\t\4/p' "$1"
}

page_rows=""
section_rows=()
for s in "${SECTIONS[@]}"; do
  rows=$(row_tsv "$ROOT/fleet/$s.md")
  section_rows+=("$(grep -c . <<<"$rows" || true)")
  page_rows+=$rows$'\n'
done
page_rows=$(grep . <<<"$page_rows" | sort)
page_tsv=$(cut -f1,4 <<<"$page_rows")
page_names=$(cut -f1 <<<"$page_rows")
# Deduplicated for the set comparisons below, so a repo that holds two rows
# (check 1's job) does not also read as "listed but not in the org".
page_uniq=$(uniq <<<"$page_names")
page_total=$(grep -c . <<<"$page_names")

echo "org: $org_total repos . page: $page_total rows"

# --- 1. no repo listed twice --------------------------------------------------
echo
echo "rows are unique"
dupes=$(uniq -d <<<"$page_names")
if [[ -z $dupes ]]; then ok "no repo holds two rows"
else fail "listed in more than one fleet table: $(tr '\n' ' ' <<<"$dupes")"; fi

# --- 2. every org repo is a row or an exclusion -------------------------------
echo
echo "every org repo is accounted for"
unlisted=""
while read -r name; do
  [[ -n $name ]] || continue
  excluded "$name" && continue
  unlisted+="$name "
done < <(comm -13 <(printf '%s\n' "$page_uniq") <(printf '%s\n' "$org_names"))
if [[ -z $unlisted ]]; then ok "all $org_total org repos are in a table or excluded"
else fail "in the org but neither in a fleet table nor excluded: ${unlisted% } -- add a row, or a rule in fleet/exclusions.md with a reason"; fi

# --- 3. nothing is both a row and an exclusion --------------------------------
both=""
while read -r name; do
  excluded "$name" && both+="$name "
done <<<"$page_uniq"
if [[ -z $both ]]; then ok "no row is also covered by an exclusion rule"
else fail "both a fleet row and excluded: ${both% } -- an exclusion rule that matches a listed repo makes the rule false"; fi

# --- 4. no row points at a repo that is gone ----------------------------------
gone=$(comm -23 <(printf '%s\n' "$page_uniq") <(printf '%s\n' "$org_names") | tr '\n' ' ')
if [[ -z $gone ]]; then ok "every row names a repo that still exists"
else fail "listed but not in the org: ${gone% }"; fi

# --- 5. Lang cells match the org ----------------------------------------------
# Both sides are already name-sorted, which is the order join needs.
echo
echo "language cells match the org"
bad_lang=$(join -t$'\t' <(printf '%s\n' "$page_tsv") <(printf '%s\n' "$org_tsv") \
  | awk -F'\t' '$2 != $3 { print "    " $1 ": page says " $2 ", the org says " $3 }')
if [[ -z $bad_lang ]]; then ok "all $page_total Lang cells agree with the org"
else fail "Lang cells disagree with the org:"; printf '%s\n' "$bad_lang"; fi

# --- 6. every row link points at the repo the row names -----------------------
# The name is read from the LINK TEXT, so without this a copy-pasted row can
# name one repo and send the reader to another and every other check still
# passes — the page would be self-consistent and still send you to the wrong
# repo, which is the exact failure this script exists to make impossible.
echo
echo "row links point at the repo they name"
bad_url=$(awk -F'\t' -v base="https://github.com/$ORG/" \
  '$2 != base $1 { print "    " $1 ": links to " $2 }' <<<"$page_rows")
if [[ -z $bad_url ]]; then ok "all $page_total row links point at their own repo"
else fail "row links point somewhere other than the repo they name:"; printf '%s\n' "$bad_url"; fi

# --- 7. visibility badges match the org ---------------------------------------
# ⭐ public, 🔒 internal, no badge private — a machine fact like the Lang cell,
# and one that has already drifted once.
echo
echo "visibility badges match the org"
# `if`, not `case`: bash 3.2 mis-parses a `case` pattern's `)` as the end of the
# enclosing $( ), and this has to stay runnable under /bin/bash on macOS.
page_vis=$(while IFS=$'\t' read -r name _url badges _lang; do
  if [[ $badges == *⭐* ]]; then vis=public
  elif [[ $badges == *🔒* ]]; then vis=internal
  else vis=private
  fi
  printf '%s\t%s\n' "$name" "$vis"
done <<<"$page_rows")
bad_vis=$(join -t$'\t' <(printf '%s\n' "$page_vis") <(printf '%s\n' "$org_vis") \
  | awk -F'\t' '$2 != $3 { print "    " $1 ": page badges it " $2 ", the org says " $3 }')
if [[ -z $bad_vis ]]; then ok "all $page_total visibility badges agree with the org"
else fail "visibility badges disagree with the org:"; printf '%s\n' "$bad_vis"; fi

# --- 8. each fleet file's header count matches its rows -----------------------
echo
echo "counts match the rows they describe"
for i in "${!SECTIONS[@]}"; do
  s=${SECTIONS[$i]}
  stated=$(sed -nE 's/^\*\*([0-9]+) repos?\*\*.*/\1/p' "$ROOT/fleet/$s.md" | head -1)
  actual=${section_rows[$i]}
  if [[ $stated == "$actual" ]]; then ok "fleet/$s.md says $stated, has $actual"
  else fail "fleet/$s.md says $stated repos, has $actual rows"; fi
done

# --- 9. the profile's section table matches each file -------------------------
for i in "${!SECTIONS[@]}"; do
  s=${SECTIONS[$i]}
  stated=$(sed -nE "s#^\|[^|]*/fleet/$s\.md\)[^|]*\| ([0-9]+) \|.*#\1#p" "$PROFILE" | head -1)
  actual=${section_rows[$i]}
  if [[ -z $stated ]]; then fail "profile/README.md has no section row for fleet/$s.md"
  elif [[ $stated == "$actual" ]]; then ok "profile section row for $s says $stated"
  else fail "profile/README.md's $s row says $stated, fleet/$s.md has $actual rows"; fi
done

# --- 10. the profile's two headline totals ------------------------------------
headlines=()
while IFS= read -r n; do headlines+=("$n"); done \
  < <(grep -oE '[0-9]+ repositories' "$PROFILE" | grep -oE '[0-9]+')
if [[ ${#headlines[@]} -ne 2 ]]; then
  fail "expected 2 '<n> repositories' figures in profile/README.md, found ${#headlines[@]}"
fi
# Guarded, because bash 3.2 (macOS /bin/bash, this script's stated floor) treats
# "${arr[@]}" on an EMPTY array as an unbound variable under `set -u` and aborts
# the whole script there — losing checks 11 and 12 and the FAIL summary, in the
# one case that matters: the headline figures having been deleted outright.
if [[ ${#headlines[@]} -gt 0 ]]; then
  for n in "${headlines[@]}"; do
    if [[ $n == "$page_total" ]]; then ok "headline says $n repositories"
    else fail "profile/README.md says $n repositories, the tables hold $page_total rows"; fi
  done
fi

# --- 11. the by-language footer reconciles ------------------------------------
echo
echo "the by-language footer reconciles"
# `|| true`, because a bare `footer=$(grep ...)` under `set -e` makes a DELETED
# footer kill the script on this line — no message, no FAIL summary, checks 12
# and the exit line never reached, and in CI an empty code fence. Deleting the
# footer is drift; report it as drift.
footer=$(grep -F 'By language:' "$PROFILE" || true)
# The footer prints a display label; HCL renders as "Terraform (HCL)".
label_to_lang() { if [[ $1 == "Terraform (HCL)" ]]; then echo HCL; else echo "$1"; fi; }

if [[ -z $footer ]]; then
  fail "profile/README.md has no 'By language:' footer"
else
  named_total=0
  # The label class carries digits, `+`, `#`, `.` and `-` as well as letters:
  # the languages GitHub reports are not all alphabetic (C++, C#, Objective-C,
  # F#), and a class that stopped at the first such character would silently
  # truncate the label, look up a language nothing is written in, and report the
  # footer as wrong against a table that is right. The separator is ` · `, whose
  # middle dot is outside the class either way, so widening it cannot run two
  # entries together.
  while IFS=$'\t' read -r count label; do
    lang=$(label_to_lang "$label")
    actual=$(awk -F'\t' -v l="$lang" '$2 == l' <<<"$page_tsv" | grep -c . || true)
    named_total=$((named_total + count))
    if [[ $count == "$actual" ]]; then ok "$label: $count"
    else fail "footer says $count $label, the tables hold $actual"; fi
  done < <(grep -oE '\*\*[0-9]+\*\* [A-Za-z0-9()+#. -]+' <<<"$footer" \
    | sed -E 's/^\*\*([0-9]+)\*\* /\1\t/' | sed -E 's/[[:space:]]+$//')

  others=$(grep -oE '\*\*\+[0-9]+\*\* others' <<<"$footer" | grep -oE '[0-9]+' || true)
  if [[ -z $others ]]; then
    fail "profile/README.md's by-language footer has no '+<n> others'"
  else
    expected_others=$((page_total - named_total))
    if [[ $others == "$expected_others" ]]; then ok "+$others others"
    else fail "footer says +$others others; $page_total rows minus the $named_total named leaves $expected_others"; fi
  fi
fi

# --- 12. the link allowlist tracks the rows -----------------------------------
# Most of this org is private, so most row links 404 to an anonymous checker and
# live in .lycheeignore (STARK-8037). That allowlist has to move with the rows or
# the link check goes red on links that are fine: a new private row needs an
# entry, and a removed row's entry has to go. Both directions are checked here so
# neither can be forgotten. Entries are anchored literal URLs — never globs.
#
# The file does not exist yet (STARK-8037 adds it); until it does this block is
# skipped, and the rest of the report still stands on its own.
ALLOWLIST=$ROOT/.lycheeignore
if [[ -f $ALLOWLIST ]]; then
  echo
  echo "the link allowlist tracks the rows"
  public=$(awk -F'\t' '$2 == "public" { print $1 }' <<<"$org_vis")
  # Entries are anchored escaped regexes — `^https://github\.com/<org>/<name>$`.
  # Reconstruct the plain URL the way STARK-8037's own staleness guard does,
  # rather than matching the escaped text: which dots an entry escapes is that
  # file's business, and a check that guessed would silently miss every row.
  allow_urls=$(sed -e 's/^\^//' -e 's/\$$//' -e 's/\\//g' "$ALLOWLIST" \
    | grep -v '^[[:space:]]*#' | grep . || true)
  missing="" stale=""
  while read -r name; do
    grep -qxF "$name" <<<"$public" && continue
    grep -qxF "https://github.com/$ORG/$name" <<<"$allow_urls" || missing+="$name "
  done <<<"$page_uniq"
  while read -r url; do
    # Only entries naming a repo in THIS org are rows to reconcile. A
    # .lycheeignore also holds unrelated rules; reporting those as stale fleet
    # rows would fail the job over links this check knows nothing about.
    [[ $url == "https://github.com/$ORG/"* ]] || continue
    name=${url#"https://github.com/$ORG/"}
    [[ $name == */* ]] && continue   # a deep link, not a repo row
    grep -qxF "$name" <<<"$page_uniq" || stale+="$name "
  done <<<"$allow_urls"
  if [[ -z $missing ]]; then ok "every private row has an allowlist entry"
  else fail "private rows with no .lycheeignore entry: ${missing% } -- their links 404 anonymously and will redden the link check"; fi
  if [[ -z $stale ]]; then ok "every allowlist entry still has a row"
  else fail "allowlist entries with no remaining row: ${stale% } -- prune them from .lycheeignore"; fi
fi

echo
if [[ $fail_count -gt 0 ]]; then
  echo "FAIL - $fail_count check(s) drifted."
  exit 1
fi
echo "OK - the page matches the org."
