#!/bin/bash
# EVIDENCE COLLECTION GATE 5 - EXPORT v0.1
# Status: PROPOSAL / DRAFT / NOT APPROVED / NOT AUTHORIZED

set -euo pipefail

# =============================================================================
# 配置
# =============================================================================
PROJECT_DIR="${GODOT_PROJECT_DIR:-.}"
EXPORT_PRESET="Windows Desktop"
EVIDENCE_DIR="${PROJECT_DIR}/evidence/builds/$(date +%Y-%m-%d)"
GODOT_BIN="${GODOT_BIN:-godot}"
EVIDENCE_CLASS="EXPORT"
GATE="G5"

# =============================================================================
# 参数解析
# =============================================================================
DRY_RUN=false
BUILD_MODE="release"
VERSION="0.1.0"

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --mode)
            BUILD_MODE="$2"
            shift 2
            ;;
        --version)
            VERSION="$2"
            shift 2
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

collect_build_identity() {
    local output_file="$1"
    
    local source_rev="unknown"
    if command -v git &> /dev/null && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &> /dev/null; then
        source_rev=$(git -C "$PROJECT_DIR" rev-parse --short=12 HEAD 2>/dev/null || echo "unknown")
    fi
    
    cat > "$output_file" << EOF
{
  "source_revision": "${source_rev}",
  "build_mode": "${BUILD_MODE}",
  "config_version": "unknown",
  "target_platform": "Windows_x86_64",
  "engine_version": "unknown",
  "export_preset": "${EXPORT_PRESET}",
  "version": "${VERSION}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "build_script_version": "0.1"
}
EOF
    
    log "Build identity collected: $output_file"
}

collect_export_artifact() {
    local evidence_id="$1"
    local run_id="${2:-RUN-$(date +%Y%m%d%H%M%S)}"
    local output_prefix="${EVIDENCE_DIR}/${evidence_id}"
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Would export artifact for run: $run_id"
        log "[DRY-RUN] Output prefix: $output_prefix"
        return 0
    fi
    
    # 实际 Godot 导出（需实现授权后启用）
    log "WARNING: Actual export requires NOT_AUTHORIZED to be lifted"
    log "Would export with preset: $EXPORT_PRESET, mode: $BUILD_MODE, version: $VERSION"
    
    # 创建占位文件（dry-run 或等待授权）
    mkdir -p "$EVIDENCE_DIR"
    echo "PLACEHOLDER_EXPORT_ZIP" > "${output_prefix}_placeholder.zip"
    
    # 生成 artifact 元数据
    local artifact_size=$(stat -f%z "${output_prefix}_placeholder.zip" 2>/dev/null || stat -c%s "${output_prefix}_placeholder.zip" 2>/dev/null || echo "0")
    local artifact_sha256="UNABLE_TO_CALCULATE"
    if command -v sha256sum &> /dev/null; then
        artifact_sha256=$(sha256sum "${output_prefix}_placeholder.zip" | awk '{print $1}')
    elif command -v shasum &> /dev/null; then
        artifact_sha256=$(shasum -a 256 "${output_prefix}_placeholder.zip" | awk '{print $1}')
    fi
    
    # 生成 artifact 命名
    local artifact_name="${PROJECT_DIR##*/}_${VERSION}_${BUILD_MODE}_windows_x86_64_$(date +%Y%m%d_%H%M%S).zip"
    local artifact_path="${EVIDENCE_DIR}/${artifact_name}"
    cp "${output_prefix}_placeholder.zip" "$artifact_path"
    
    log "Artifact placeholder created: $artifact_path"
    log "SHA-256: $artifact_sha256"
    log "Size: $artifact_size bytes"
}

write_evidence_record() {
    local evidence_id="$1"
    local build_identity_file="$2"
    local artifact_path="$3"
    
    local file_size="0"
    local digest_sha256="UNABLE_TO_CALCULATE"
    
    if [ -f "$artifact_path" ]; then
        file_size=$(stat -f%z "$artifact_path" 2>/dev/null || stat -c%s "$artifact_path" 2>/dev/null || echo "0")
        if command -v sha256sum &> /dev/null; then
            digest_sha256=$(sha256sum "$artifact_path" | awk '{print $1}')
        elif command -v shasum &> /dev/null; then
            digest_sha256=$(shasum -a 256 "$artifact_path" | awk '{print $1}')
        fi
    fi
    
    cat > "${EVIDENCE_DIR}/${evidence_id}.json" << EOF
{
  "evidence_id": "${evidence_id}",
  "evidence_class": "${EVIDENCE_CLASS}",
  "gate": "${GATE}",
  "criterion": {
    "c-5.1": "Build identity matches artifact",
    "c-5.2": "SHA-256 digest verified"
  },
  "build_identity_ref": "${build_identity_file}",
  "artifact": {
    "filename": "$(basename "$artifact_path")",
    "path": "${artifact_path}",
    "size_bytes": ${file_size},
    "digest_sha256": "${digest_sha256}"
  },
  "export_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "export_preset": "${EXPORT_PRESET}",
  "target_platform": "Windows_x86_64",
  "build_mode": "${BUILD_MODE}",
  "version": "${VERSION}",
  "status": "NOT_AUTHORIZED",
  "note": "Placeholder - actual export requires implementation authorization"
}
EOF
    
    log "Evidence record written: ${EVIDENCE_DIR}/${evidence_id}.json"
}

# =============================================================================
# 主流程
# =============================================================================
main() {
    log "=== EVIDENCE COLLECTION GATE 5 v0.1 ==="
    log "Project: $PROJECT_DIR"
    log "Build Mode: $BUILD_MODE"
    log "Version: $VERSION"
    log "Evidence Class: $EVIDENCE_CLASS"
    log "Gate: $GATE"
    log "Dry Run: $DRY_RUN"
    log "========================================="
    
    # 检查配置
    if [ -z "${GODOT_BIN:-}" ]; then
        log "WARNING: GODOT_BIN not set, using 'godot'"
    fi
    
    # 创建证据目录
    mkdir -p "$EVIDENCE_DIR"
    
    # 生成证据 ID
    local evidence_id=$(generate_evidence_id)
    log "Evidence ID: $evidence_id"
    
    # 收集构建身份
    collect_build_identity "${EVIDENCE_DIR}/${evidence_id}_build.json"
    
    # 收集导出 artifact
    collect_export_artifact "$evidence_id" "RUN-$(date +%Y%m%d%H%M%S)"
    
    # 生成证据记录
    local artifact_path="${EVIDENCE_DIR}/${PROJECT_DIR##*/}_${VERSION}_${BUILD_MODE}_windows_x86_64_$(date +%Y%m%d_%H%M%S)_placeholder.zip"
    write_evidence_record "$evidence_id" "${EVIDENCE_DIR}/${evidence_id}_build.json" "$artifact_path"
    
    log "=== EVIDENCE COLLECTION COMPLETE ==="
    log "Evidence directory: $EVIDENCE_DIR"
    log "Evidence ID: $evidence_id"
    log "Status: NOT_AUTHORIZED (placeholder)"
    log "All data marked as placeholder - real data requires NOT_AUTHORIZED lift"
}

main "$@"