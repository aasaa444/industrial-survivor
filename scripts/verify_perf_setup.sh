#!/bin/bash
# PERF SETUP VERIFICATION SCRIPT v0.1
# Status: PROPOSAL / DRAFT / NOT APPROVED / NOT AUTHORIZED

set -euo pipefail

PROJECT_DIR="${GODOT_PROJECT_DIR:-.}"
PASS=0
FAIL=0
WARN=0

check() {
    local desc="$1"
    local cmd="$2"
    
    if eval "$cmd" &>/dev/null; then
        echo "  [PASS] $desc"
        ((PASS++))
    else
        echo "  [FAIL] $desc"
        ((FAIL++))
    fi
}

warn() {
    local desc="$1"
    echo "  [WARN] $desc"
    ((WARN++))
}

echo "=== PERF SETUP VERIFICATION v0.1 ==="
echo "Project: $PROJECT_DIR"
echo ""

echo "--- Configuration Files ---"
check "perf_config.json exists" "test -f ${PROJECT_DIR}/scripts/perf_config.json"
check "collect_perf_metrics.sh exists" "test -f ${PROJECT_DIR}/scripts/collect_perf_metrics.sh"
check "collect_hardware_info.sh exists" "test -f ${PROJECT_DIR}/scripts/collect_hardware_info.sh"
check "verify_perf_setup.sh exists" "test -f ${PROJECT_DIR}/scripts/verify_perf_setup.sh"

echo ""
echo "--- Script Permissions ---"
check "collect_perf_metrics.sh is executable" "test -x ${PROJECT_DIR}/scripts/collect_perf_metrics.sh"
check "collect_hardware_info.sh is executable" "test -x ${PROJECT_DIR}/scripts/collect_hardware_info.sh"

echo ""
echo "--- Evidence Directory ---"
if [ -d "${PROJECT_DIR}/evidence/perf" ]; then
    check "evidence/perf/ directory exists" "true"
    check "evidence/perf/ is writable" "test -w ${PROJECT_DIR}/evidence/perf"
else
    warn "evidence/perf/ directory does not exist (will be created on first run)"
fi

echo ""
echo "--- Godot Binary ---"
if [ -n "${GODOT_BIN:-}" ]; then
    check "GODOT_BIN is set" "true"
    check "Godot binary accessible" "command -v ${GODOT_BIN}"
else
    warn "GODOT_BIN not set (will use system 'godot')"
fi

echo ""
echo "--- Git Status ---"
if command -v git &>/dev/null && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
    local rev=$(git -C "$PROJECT_DIR" rev-parse --short=12 HEAD 2>/dev/null || echo "unknown")
    check "Git repository accessible" "true"
    echo "       Current revision: $rev"
else
    warn "Git not available or not in a repository"
fi

echo ""
echo "=== SUMMARY ==="
echo "PASS: $PASS"
echo "FAIL: $FAIL"
echo "WARN: $WARN"
echo ""

if [ $FAIL -gt 0 ]; then
    echo "RESULT: FAILED - Fix $FAIL issue(s) before proceeding"
    exit 1
elif [ $WARN -gt 0 ]; then
    echo "RESULT: PASSED with $WARN warning(s)"
    exit 0
else
    echo "RESULT: PASSED"
    exit 0
fi