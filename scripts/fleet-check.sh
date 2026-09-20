#!/usr/bin/env bash
# fleet-check.sh — prove the org landing page still describes the real org.
#
# The fleet tables are hand-written on purpose: the "What it is" column is
# curated prose and no API knows it. Everything else on the page is a machine
# fact — which repos exist, what they are written in, how many there are — and
# every one of those facts is checked here against the live org.
#
#   bash scripts/fleet-check.sh                 # check; exit 1 on drift
#   bash scripts/fleet-check.sh --list-excluded # what the exclusion rules match today
#
# Needs `gh` authenticated with org-wide metadata:read — most of this org is
# private, and a repo-scoped token silently sees only the public handful.

set -euo pipefail

ORG=21StarkCom
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
PROFILE=$ROOT/profile/README.md
EXCLUSIONS=$ROOT/fleet/exclusions.md

# Fleet tables, in the order the profile's section table lists them.
SECTIONS=(ecosystem infrastructure second-brain retired)

fail_count=0
fail() { printf '  x %s\n' "$1"; fail_count=$((fail_count + 1)); }
ok() { printf '  . %s\n' "$1"; }

# --- the live org -------------------------------------------------------------
# type=all so archived repos are included; they are retired, not gone.
org_tsv=$(gh api "orgs/$ORG/repos?type=all&per_page=100" --paginate \
  --jq '.[] | [.name, (.language // "—")] | @tsv' | sort)
org_names=$(cut -f1 <<<"$org_tsv")
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
# | **[name](url)** 🔒 | `Lang` | prose |
row_tsv() {
  # shellcheck disable=SC2016  # the backticks are Markdown in the sed pattern
  sed -nE 's/^\| \*\*\[([a-zA-Z0-9._-]+)\]\([^)]*\)\*\*[^|]*\| `([^`]*)`.*/\1\t\2/p' "$1"
}

page_tsv=""
declare -A section_rows=()
for s in "${SECTIONS[@]}"; do
  tsv=$(row_tsv "$ROOT/fleet/$s.md")
  section_rows[$s]=$(grep -c . <<<"$tsv" || true)
  page_tsv+=$tsv$'\n'
done
page_tsv=$(grep . <<<"$page_tsv" | sort)
page_names=$(cut -f1 <<<"$page_tsv")
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
  grep -qxF "$name" <<<"$page_names" && continue
  excluded "$name" && continue
  unlisted+="$name "
done <<<"$org_names"
if [[ -z $unlisted ]]; then ok "all $org_total org repos are in a table or excluded"
else fail "in the org but neither in a fleet table nor excluded: ${unlisted% } -- add a row, or a rule in fleet/exclusions.md with a reason"; fi

# --- 3. nothing is both a row and an exclusion --------------------------------
both=""
while read -r name; do
  excluded "$name" && both+="$name "
done <<<"$page_names"
if [[ -z $both ]]; then ok "no row is also covered by an exclusion rule"
else fail "both a fleet row and excluded: ${both% } -- an exclusion rule that matches a listed repo makes the rule false"; fi

# --- 4. no row points at a repo that is gone ----------------------------------
gone=""
while read -r name; do
  grep -qxF "$name" <<<"$org_names" || gone+="$name "
done <<<"$page_names"
if [[ -z $gone ]]; then ok "every row names a repo that still exists"
else fail "listed but not in the org: ${gone% }"; fi

# --- 5. Lang cells match the org ----------------------------------------------
echo
echo "language cells match the org"
bad_lang=$(join -t$'\t' <(sort <<<"$page_tsv") <(sort <<<"$org_tsv") \
  | awk -F'\t' '$2 != $3 { print "    " $1 ": page says " $2 ", the org says " $3 }')
if [[ -z $bad_lang ]]; then ok "all $page_total Lang cells agree with the org"
else fail "Lang cells disagree with the org:"; printf '%s\n' "$bad_lang"; fi

# --- 6. each fleet file's header count matches its rows -----------------------
echo
echo "counts match the rows they describe"
for s in "${SECTIONS[@]}"; do
  stated=$(sed -nE 's/^\*\*([0-9]+) repos?\*\*.*/\1/p' "$ROOT/fleet/$s.md" | head -1)
  actual=${section_rows[$s]}
  if [[ $stated == "$actual" ]]; then ok "fleet/$s.md says $stated, has $actual"
  else fail "fleet/$s.md says $stated repos, has $actual rows"; fi
done

# --- 7. the profile's section table matches each file -------------------------
for s in "${SECTIONS[@]}"; do
  stated=$(sed -nE "s#^\|[^|]*/fleet/$s\.md\)[^|]*\| ([0-9]+) \|.*#\1#p" "$PROFILE" | head -1)
  actual=${section_rows[$s]}
  if [[ -z $stated ]]; then fail "profile/README.md has no section row for fleet/$s.md"
  elif [[ $stated == "$actual" ]]; then ok "profile section row for $s says $stated"
  else fail "profile/README.md's $s row says $stated, fleet/$s.md has $actual rows"; fi
done

# --- 8. the profile's two headline totals -------------------------------------
headlines=()
while IFS= read -r n; do headlines+=("$n"); done \
  < <(grep -oE '[0-9]+ repositories' "$PROFILE" | grep -oE '[0-9]+')
if [[ ${#headlines[@]} -ne 2 ]]; then
  fail "expected 2 '<n> repositories' figures in profile/README.md, found ${#headlines[@]}"
fi
for n in "${headlines[@]}"; do
  if [[ $n == "$page_total" ]]; then ok "headline says $n repositories"
  else fail "profile/README.md says $n repositories, the tables hold $page_total rows"; fi
done

# --- 9. the by-language footer reconciles -------------------------------------
echo
echo "the by-language footer reconciles"
footer=$(grep -F 'By language:' "$PROFILE")
# The footer prints a display label; HCL renders as "Terraform (HCL)".
label_to_lang() { if [[ $1 == "Terraform (HCL)" ]]; then echo HCL; else echo "$1"; fi; }

named_total=0
while IFS=$'\t' read -r count label; do
  lang=$(label_to_lang "$label")
  actual=$(awk -F'\t' -v l="$lang" '$2 == l' <<<"$page_tsv" | grep -c . || true)
  named_total=$((named_total + count))
  if [[ $count == "$actual" ]]; then ok "$label: $count"
  else fail "footer says $count $label, the tables hold $actual"; fi
done < <(grep -oE '\*\*[0-9]+\*\* [A-Za-z()  ]+' <<<"$footer" \
  | sed -E 's/^\*\*([0-9]+)\*\* /\1\t/' | sed -E 's/[[:space:]]+$//')

others=$(grep -oE '\*\*\+[0-9]+\*\* others' <<<"$footer" | grep -oE '[0-9]+' || true)
if [[ -z $others ]]; then
  fail "profile/README.md's by-language footer has no '+<n> others'"
else
  expected_others=$((page_total - named_total))
  if [[ $others == "$expected_others" ]]; then ok "+$others others"
  else fail "footer says +$others others; $page_total rows minus the $named_total named leaves $expected_others"; fi
fi

# --- 10. the link allowlist tracks the rows ------------------------------------
# Most of this org is private, so most row links 404 to an anonymous checker and
# live in .lycheeignore (STARK-8037). That allowlist has to move with the rows or
# the link check goes red on links that are fine: a new private row needs an
# entry, and a removed row's entry has to go. Both directions are checked here so
# neither can be forgotten. Entries are anchored literal URLs — never globs.
ALLOWLIST=$ROOT/.lycheeignore
if [[ -f $ALLOWLIST ]]; then
  echo
  echo "the link allowlist tracks the rows"
  public=$(gh api "orgs/$ORG/repos?type=all&per_page=100" --paginate \
    --jq '.[] | select(.private | not) | .name' | sort)
  missing="" stale=""
  while read -r name; do
    grep -qxF "$name" <<<"$public" && continue
    grep -qF "https://github.com/$ORG/$name\$" "$ALLOWLIST" || missing+="$name "
  done <<<"$page_names"
  while read -r entry; do
    [[ -z $entry || $entry == \#* ]] && continue
    name=${entry#*"/$ORG/"}; name=${name%\$}
    grep -qxF "$name" <<<"$page_names" || stale+="$name "
  done <"$ALLOWLIST"
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
