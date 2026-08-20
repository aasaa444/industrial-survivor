#!/bin/bash
# EXPORT VERIFICATION SCRIPT v0.1
# Status: PROPOSAL / DRAFT / NOT APPROVED / NOT AUTHORIZED

set -euo pipefail

ARTIFACT_PATH="${1:-}"
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

echo "=== EXPORT VERIFICATION v0.1 ==="
echo "Artifact: $ARTIFACT_PATH"
echo ""

if [ -z "$ARTIFACT_PATH" ]; then
    echo "ERROR: No artifact path provided"
    echo "Usage: $0 <artifact_path>"
    exit 1
fi

echo "--- Basic Checks ---"
check "Artifact file exists" "test -f ${ARTIFACT_PATH}"
check "Artifact file is not empty" "test -s ${ARTIFACT_PATH}"
check "Artifact file is readable" "test -r ${ARTIFACT_PATH}"

echo ""
echo "--- Size Checks ---"
if [ -f "$ARTIFACT_PATH" ]; then
    local file_size=$(stat -f%z "$ARTIFACT_PATH" 2>/dev/null || stat -c%s "$ARTIFACT_PATH" 2>/dev/null || echo "0")
    echo "  File size: $file_size bytes"
    
    if [ "$file_size" -gt 1048576 ]; then  # > 1MB
        check "Artifact size reasonable (>1MB)" "true"
    else
        warn "Artifact size < 1MB (may be incomplete)"
    fi
else
    warn "Cannot check size: file does not exist"
fi

echo ""
echo "--- Integrity Checks ---"
if [[ "$ARTIFACT_PATH" == *.zip ]]; then
    if command -v unzip &> /dev/null; then
        check "ZIP integrity check" "unzip -t ${ARTIFACT_PATH}"
    else
        warn "unzip not available, skipping integrity check"
    fi
elif [[ "$ARTIFACT_PATH" == *.exe ]]; then
    # Basic PE header check
    if command -v file &> /dev/null; then
        check "EXE format check" "file ${ARTIFACT_PATH} | grep -i 'PE32\|executable'"
    else
        warn "file command not available, skipping format check"
    fi
fi

echo ""
echo "--- Checksum ---"
if [ -f "$ARTIFACT_PATH" ]; then
    if command -v sha256sum &> /dev/null; then
        local digest=$(sha256sum "$ARTIFACT_PATH" | awk '{print $1}')
        echo "  SHA-256: $digest"
    elif command -v shasum &> /dev/null; then
        local digest=$(shasum -a 256 "$ARTIFACT_PATH" | awk '{print $1}')
        echo "  SHA-256: $digest"
    else
        warn "No SHA-256 tool available"
    fi
fi

echo ""
echo "=== SUMMARY ==="
echo "PASS: $PASS"
echo "FAIL: $FAIL"
echo "WARN: $WARN"
echo ""

if [ $FAIL -gt 0 ]; then
    echo "RESULT: FAILED - Fix $FAIL issue(s)"
    exit 1
elif [ $WARN -gt 0 ]; then
    echo "RESULT: PASSED with $WARN warning(s)"
    exit 0
else
    echo "RESULT: PASSED"
    exit 0
fi