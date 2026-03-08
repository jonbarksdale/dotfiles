#!/bin/bash
# ABOUTME: ccstatusline custom widget script for session and daily cost estimates
# ABOUTME: Combines CC native session cost with ccusage JSONL-computed daily total

# Session cost comes from CC's native statusline JSON (cost.total_cost_usd).
# Daily cost comes from ccusage reading local JSONL logs against known API pricing,
# so it produces estimates regardless of billing method (subscription, Vertex, etc.).
#
# Assumption: jq is available in PATH.
# Assumption: bunx is available in PATH for ccusage invocation.
# Assumption: ccusage daily --json emits { daily: [...{date, totalCost}], totals: {...} }
# Assumption: daily array is sorted ascending by date; last entry is today.

TODAY=$(date +%Y-%m-%d)

# Read CC's native session cost from stdin JSON
CC_JSON=$(cat)
SESSION_COST=$(echo "$CC_JSON" | jq -r '
  (.cost.total_cost_usd // 0) as $c |
  if $c > 0 then ($c * 100 | round / 100 | tostring | "$" + .) else "" end
' 2>/dev/null)

# Read today's total cost from ccusage JSONL analysis
TODAY_COST=$(bunx ccusage@latest daily --json 2>/dev/null | jq -r --arg today "$TODAY" '
  (.daily // []) |
  map(select(.date == $today)) |
  if length > 0 then
    (.[0].totalCost * 100 | round / 100 | tostring | "$" + .)
  else "" end
' 2>/dev/null)

# Build output
if [ -n "$SESSION_COST" ] && [ -n "$TODAY_COST" ]; then
  echo "💰 ${SESSION_COST} / ${TODAY_COST}"
elif [ -n "$TODAY_COST" ]; then
  echo "💰 ${TODAY_COST} today"
elif [ -n "$SESSION_COST" ]; then
  echo "💰 ${SESSION_COST}"
fi
