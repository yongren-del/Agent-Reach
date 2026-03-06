#!/usr/bin/env bash
set -u -o pipefail

log() {
  echo "[fork-local-gate] $*"
}

fail_and_exit() {
  local rc="$1"
  local next="$2"
  log "RESULT: FAIL"
  log "EXIT_CODE=$rc"
  if [[ -n "$next" ]]; then
    log "NEXT: $next"
  fi
  exit "$rc"
}

if ! command -v pg_isready >/dev/null 2>&1; then
  fail_and_exit 2 "install postgresql-client before running local gate"
fi
if ! command -v curl >/dev/null 2>&1; then
  fail_and_exit 2 "install curl before running local gate"
fi
if ! command -v jq >/dev/null 2>&1; then
  fail_and_exit 2 "install jq before running local gate"
fi

if ! pg_isready -h 127.0.0.1 -p 5432 -U postgres -d agent_wechat >/dev/null 2>&1; then
  fail_and_exit 1 "ensure postgres service is healthy on 127.0.0.1:5432"
fi

log "RESULT: PASS"
log "EXIT_CODE=0"
exit 0
