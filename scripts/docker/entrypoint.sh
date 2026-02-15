#!/usr/bin/env bash
set -euo pipefail

# Ensure Playwright/Patchright uses preinstalled browsers
export PLAYWRIGHT_BROWSERS_PATH=0

# 1. Timezone: default to UTC if not provided
: "${TZ:=UTC}"
ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
echo "$TZ" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# 2. Run script (with optional initial run logic)
cd /usr/src/microsoft-rewards-script || {
  echo "[entrypoint] ERROR: Unable to cd to /usr/src/microsoft-rewards-script" >&2
  exit 1
}

if [ "${RUN_ON_START:-false}" = "true" ]; then
  echo "[entrypoint] Starting initial run at $(date)"
  SKIP_RANDOM_SLEEP=true scripts/docker/run_daily.sh
  echo "[entrypoint] Initial run completed at $(date)"
else
  echo "[entrypoint] Starting run at $(date)"
  exec scripts/docker/run_daily.sh
fi
