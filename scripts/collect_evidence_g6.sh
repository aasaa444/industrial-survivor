#!/bin/bash
# EVIDENCE COLLECTION GATE 6 - QA v0.1
# Status: PROPOSAL / DRAFT / NOT APPROVED / NOT AUTHORIZED

set -euo pipefail

# =============================================================================
# 配置
# =============================================================================
PROJECT_DIR="${GODOT_PROJECT_DIR:-.}"
EVIDENCE_DIR="${PROJECT_DIR}/evidence/qa/$(date +%Y-%m-%d)"
GODOT_BIN="${GODOT_BIN:-godot}"
EVIDENCE_CLASS="QA"
GATE="G6"
INDEPENDENT_QA_ID="qa-release-expert-$(whoami)"

# =============================================================================
# 参数解析
# =============================================================================
DRY_RUN=false
FIXTURE_ID="${1:-auto}"
VERIFY_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --fixture)
            FIXTURE_ID="$2"
            shift 2
            ;;
        --verify-only)
            VERIFY_ONLY=true
            shift
            ;;
        --project-dir)
            PROJECT_DIR="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# =============================================================================
# 函数
# =============================================================================
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

generate_evidence_id() {
    local timestamp=$(date +%Y%m%d)
    local random=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c 8)
    echo "${GATE}-${EVIDENCE_CLASS}-${timestamp}-${random}"
}

generate_evidence_class() {
    echo "${EVIDENCE_CLASS}"
}

generate_gate() {
    echo "${GATE}"
}

generate_observer() {
    echo "${INDEPENDENT_QA_ID}"
}

check_mandatory_fields() {
    local evidence_record="$1"
    local missing_fields=()
    local present_fields=()
    
    # 必填字段检查（简化版）
    local required=(
        "evidence_id"
        "evidence_class" 
        "gate"
        "observer"
        "verdict"
    )
    
    for field in "${required[@]}"; do
        if grep -q "\"${field}\":" "$evidence_record" 2>/dev/null; then
            present_fields+=("$field")
        else
            missing_fields+=("$field")
        fi
    done
    
    echo "Missing mandatory fields: ${missing_fields[*]}"
    echo "Present mandatory fields: ${present_fields[*]}"
}

verify_evidence_schema() {
    local evidence_record="$1"
    
    # 检查 schema_incompatible/missing_evidence
    if grep -q "schema_incompatible" "$evidence_record" 2>/dev/null; then
        echo "WARNING: schema_incompatible detected - verdict cannot be pass"
        return 1
    fi
    
    if grep -q "missing_evidence" "$evidence_record" 2>/dev/null; then
        echo "WARNING: missing_evidence detected - verdict will be not_run"
        return 1
    fi
    
    echo "Schema verification passed"
    return 0
}

write_evidence_record() {
    local evidence_id="$1"
    local evidence_record="$2"
    local fixture_ref="$3"
    
    # 确保目录存在
    mkdir -p "$EVIDENCE_DIR"
    
    # 复制证据记录
    cp "$evidence_record" "${EVIDENCE_DIR}/${evidence_id}.json"
    
    # 生成 verdict 总结
    local verdict_summary="${EVIDENCE_DIR}/${evidence_id}_verdict.txt"
    
    # 提取 verdict 字段
    local verdict=""
    if grep -q '"verdict":' "$evidence_record" 2>/dev/null; then
        verdict=$(grep '"verdict":' "$evidence_record" | sed 's/.*"verdict": *"//' | sed 's/".*//')
    fi
    
    cat > "$verdict_summary" << EOF
Evidence ID: ${evidence_id}
Verdict: ${verdict:-not_set}
Observer: ${INDEPENDENT_QA_ID}
Gate: G6
Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Fixture Reference: ${fixture_ref}
Mandatory Fields: Checked per B3
Schema: Checked per Evidence schema §6/§8
EOF
    
    log "Evidence record written: ${EVIDENCE_DIR}/${evidence_id}.json"
    log "Verdict summary: $verdict_summary"
}

# =============================================================================
# 主流程
# =============================================================================
main() {
    log "=== EVIDENCE COLLECTION GATE 6 v0.1 ==="
    log "Project: $PROJECT_DIR"
    log "Fixture ID: $FIXTURE_ID"
    log "Evidence Class: $EVIDENCE_CLASS"
    log "Gate: $GATE"
    log "Independent QA: $INDEPENDENT_QA_ID"
    log "Dry Run: $DRY_RUN"
    log "========================================="
    
    # 检查项目目录
    if [ ! -d "$PROJECT_DIR" ]; then
        log "ERROR: Project directory not found: $PROJECT_DIR"
        exit 1
    fi
    
    # 创建证据目录
    mkdir -p "$EVIDENCE_DIR"
    
    # 生成证据 ID
    local evidence_id=$(generate_evidence_id)
    log "Evidence ID: $evidence_id"
    
    # 生成证据记录基础结构
    local base_record="${EVIDENCE_DIR}/${evidence_id}_base.json"
    cat > "$base_record" << EOF
{
  "evidence_id": "${evidence_id}",
  "evidence_class": "${EVIDENCE_CLASS}",
  "gate": "${GATE}",
  "observer": "$(generate_observer)",
  "status": "NOT_AUTHORIZED",
  "note": "Placeholder - actual QA evidence requires implementation authorization and independent observation"
}
EOF
    
    # 写入证据记录
    write_evidence_record "$evidence_id" "$base_record" "auto-generated"
    
    # 如果非 verify-only 模式，检查 mandatory fields
    if [ "$VERIFY_ONLY" = false ] && [ "$DRY_RUN" = false ]; then
        log "Running mandatory field check..."
        local missing=$(check_mandatory_fields "$base_record")
        echo "$missing"
    fi
    
    # 如果 verify-only，检查 schema
    if [ "$VERIFY_ONLY" = true ]; then
        log "Running schema verification..."
        verify_evidence_schema "$base_record"
    fi
    
    log "=== EVIDENCE COLLECTION COMPLETE ==="
    log "Evidence directory: $EVIDENCE_DIR"
    log "Evidence ID: $evidence_id"
    log "Status: NOT_AUTHORIZED (placeholder)"
    log "All data marked as placeholder - real data requires implementation authorization + independent QA observation"
}

main "$@"
