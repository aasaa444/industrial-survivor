#!/bin/bash
# WINDOWS BUILD SCRIPT v0.1
# Gate 5 Export Configuration - Godot CLI 构建
# Status: PROPOSAL / DRAFT / NOT APPROVED / NOT AUTHORIZED

set -euo pipefail

# =============================================================================
# 配置
# =============================================================================
PROJECT_DIR="${GODOT_PROJECT_DIR:-.}"
EXPORT_PRESET="Windows Desktop"
EVIDENCE_DIR="${PROJECT_DIR}/evidence/builds/$(date +%Y-%m-%d)"
GODOT_BIN="${GODOT_BIN:-godot}"
BUILD_OUTPUT_DIR="${PROJECT_DIR}/builds"

# =============================================================================
# 参数解析
# =============================================================================
DRY_RUN=false
BUILD_MODE="release"
VERSION="0.1.0"
CLEAN=false

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
        --clean)
            CLEAN=true
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
    local timestamp=$(date +%Y%m%d%H%M%S%3N)
    local random=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c 8)
    echo "EXPORT-${timestamp}-${random}"
}

generate_artifact_name() {
    local project_name="new_game"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    echo "${project_name}_${VERSION}_${BUILD_MODE}_windows_x86_64_${timestamp}"
}

calculate_sha256() {
    local file="$1"
    if command -v sha256sum &> /dev/null; then
        sha256sum "$file" | awk '{print $1}'
    elif command -v shasum &> /dev/null; then
        shasum -a 256 "$file" | awk '{print $1}'
    else
        echo "UNABLE_TO_CALCULATE"
    fi
}

run_export() {
    local output_path="$1"
    
    log "Running Godot export..."
    log "  Preset: $EXPORT_PRESET"
    log "  Output: $output_path"
    
    # 实际 Godot 导出命令
    # 需实现授权后启用
    "${GODOT_BIN}" --headless --export-release "${EXPORT_PRESET}" "${output_path}" 2>&1
    
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        log "ERROR: Godot export failed with exit code $exit_code"
        return $exit_code
    fi
    
    log "Export completed successfully"
    return 0
}

verify_export() {
    local artifact_path="$1"
    local verification_status="pass"
    local verification_errors=()
    
    log "Verifying export artifact..."
    
    # 检查文件存在
    if [ ! -f "$artifact_path" ]; then
        verification_status="fail"
        verification_errors+=("Artifact file does not exist")
        log "  FAIL: Artifact file does not exist"
    else
        log "  PASS: Artifact file exists"
    fi
    
    # 检查文件大小
    if [ -f "$artifact_path" ]; then
        local file_size=$(stat -f%z "$artifact_path" 2>/dev/null || stat -c%s "$artifact_path" 2>/dev/null || echo "0")
        if [ "$file_size" -gt 0 ]; then
            log "  PASS: Artifact size: $file_size bytes"
        else
            verification_status="fail"
            verification_errors+=("Artifact file is empty")
            log "  FAIL: Artifact file is empty"
        fi
    fi
    
    # 检查 ZIP 格式（如果适用）
    if [[ "$artifact_path" == *.zip ]]; then
        if command -v unzip &> /dev/null; then
            if unzip -t "$artifact_path" &> /dev/null; then
                log "  PASS: ZIP integrity check passed"
            else
                verification_status="fail"
                verification_errors+=("ZIP integrity check failed")
                log "  FAIL: ZIP integrity check failed"
            fi
        else
            log "  WARN: unzip not available, skipping integrity check"
        fi
    fi
    
    echo "$verification_status"
    return 0
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

# =============================================================================
# 主流程
# =============================================================================
main() {
    log "=== WINDOWS BUILD v0.1 ==="
    log "Project: $PROJECT_DIR"
    log "Mode: $BUILD_MODE"
    log "Version: $VERSION"
    log "Dry Run: $DRY_RUN"
    log "=========================="
    
    # 创建目录
    mkdir -p "$BUILD_OUTPUT_DIR"
    mkdir -p "$EVIDENCE_DIR"
    
    # 生成 ID
    local evidence_id=$(generate_evidence_id)
    local artifact_name=$(generate_artifact_name)
    local artifact_path="${BUILD_OUTPUT_DIR}/${artifact_name}"
    
    log "Evidence ID: $evidence_id"
    log "Artifact Name: $artifact_name"
    
    # 收集构建身份
    collect_build_identity "${EVIDENCE_DIR}/${evidence_id}_build.json"
    
    # 清理构建目录（如果指定）
    if [ "$CLEAN" = true ]; then
        log "Cleaning build directory..."
        rm -rf "${BUILD_OUTPUT_DIR:?}/"* 2>/dev/null || true
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Would export with preset: $EXPORT_PRESET"
        log "[DRY-RUN] Would output to: ${artifact_path}.zip"
        log "[DRY-RUN] Build identity saved to: ${EVIDENCE_DIR}/${evidence_id}_build.json"
        
        # 创建 dry-run 占位文件
        echo "DRY-RUN placeholder" > "${artifact_path}_dryrun.txt"
        artifact_path="${artifact_path}_dryrun.txt"
    else
        # 实际导出（需实现授权后启用）
        log "WARNING: Actual export requires NOT_AUTHORIZED to be lifted"
        run_export "${artifact_path}.zip"
        artifact_path="${artifact_path}.zip"
    fi
    
    # 验证
    local verification_status="not_executed"
    local verification_errors=()
    
    if [ "$DRY_RUN" = true ]; then
        verification_status="dry_run"
        log "[DRY-RUN] Would verify artifact: $artifact_path"
    else
        # 验证逻辑（需实现授权后启用）
        log "WARNING: Actual verification requires NOT_AUTHORIZED to be lifted"
        verification_status="not_authorized"
    fi
    
    # 计算摘要
    local artifact_digest="UNABLE_TO_CALCULATE"
    local artifact_size="0"
    if [ -f "$artifact_path" ]; then
        artifact_digest=$(calculate_sha256 "$artifact_path")
        artifact_size=$(stat -f%z "$artifact_path" 2>/dev/null || stat -c%s "$artifact_path" 2>/dev/null || echo "0")
    fi
    
    # 生成证据记录
    cat > "${EVIDENCE_DIR}/${evidence_id}_export.json" << EOF
{
  "evidence_id": "${evidence_id}",
  "export_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "build_identity_ref": "${evidence_id}_build.json",
  "export_preset": "${EXPORT_PRESET}",
  "target_platform": "Windows_x86_64",
  "build_mode": "${BUILD_MODE}",
  "version": "${VERSION}",
  "artifact": {
    "filename": "$(basename "$artifact_path")",
    "path": "${artifact_path}",
    "size_bytes": ${artifact_size},
    "digest_sha256": "${artifact_digest}"
  },
  "verification": {
    "status": "${verification_status}",
    "errors": [$(printf '"%s",' "${verification_errors[@]}" | sed 's/,$//')]
  },
  "status": "NOT_AUTHORIZED",
  "note": "Placeholder - actual export requires implementation authorization"
}
EOF
    
    log "Export evidence saved: ${EVIDENCE_DIR}/${evidence_id}_export.json"
    
    log "=== BUILD COMPLETE ==="
    log "Evidence ID: $evidence_id"
    log "Artifact: $artifact_path"
    log "Status: NOT_AUTHORIZED (placeholder)"
}

main "$@"
