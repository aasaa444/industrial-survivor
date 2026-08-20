# EXPORT CONFIGURATION v0.1 — Gate 5 导出配置与构建脚本

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **Owner:** Tech Lead（`godot-tech-lead-expert`）。
>
> **本文件是什么：** 为 Gate 5 导出提供**可执行的 PC/Windows 10+ 导出配置与构建脚本**，包含导出预设、构建命令、artifact 命名约定、以及验证流程。
>
> **本文件不是什么：** 不是实际导出执行/运行；不是发布承诺；不替用户决策；不豁免 QA blocker；不替 Independent QA 下 verdict。
>
> **证据类别：** `static/source` only。未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未派发任何成员。
>
> **前置依赖：** `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-08 build identity）、DC-PLAT-01 → P1（Windows x86_64 单一导出）。

---

## 1. 版本与状态

| 属性 | 值 |
|---|---|
| 文档版本 | v0.1 |
| 状态 | `PROPOSAL / DRAFT / NOT APPROVED` |
| 适用 Gate | Gate 5（Export / Build） |
| 实现授权 | `NOT_AUTHORIZED` |
| 关联决策 | DC-PLAT-01 → P1 (R01)：Windows x86_64 单一导出 |
| 关联 ADR | ADR-TECH-08（build identity） |
| 关联 CR | cr-112（target 身份字段） |

---

## 2. Evidence Required（Gate 5 所需证据清单）

### 2.1 必需证据字段（per-export-build）

| 字段类别 | 字段名 | 说明 | 必填 |
|---|---|---|---|
| 身份链 | `evidence_id` | 不可变唯一 ID | YES |
| 身份链 | `build_identity` | 完整构建身份 | YES |
| 身份链 | `export_timestamp` | 导出时间（ISO 8601 UTC） | YES |
| 构建参数 | `godot_version` | Godot 引擎版本 | YES |
| 构建参数 | `export_preset` | 导出预设名称 | YES |
| 构建参数 | `target_platform` | 目标平台（Windows x86_64） | YES |
| 构建参数 | `build_mode` | debug / release / release_debug | YES |
| Artifact | `artifact_filename` | 输出文件名 | YES |
| Artifact | `artifact_path` | 输出路径 | YES |
| Artifact | `artifact_size_bytes` | 文件大小 | YES |
| Artifact | `artifact_digest_sha256` | SHA-256 摘要 | YES |
| Artifact | `executable_size_bytes` | 可执行文件大小（Windows .exe） | YES |
| 验证 | `export_log_ref` | 导出日志引用 | YES |
| 验证 | `verification_status` | pass / fail / error | YES |
| 验证 | `verification_errors` | 错误列表（如有） | YES |

### 2.2 必需证据字段（per-runtime-test）

| 字段名 | 说明 |
|---|---|
| `runtime_test_evidence_id` | 运行时测试证据 ID |
| `launch_success` | 是否成功启动 |
| `first_frame_time_ms` | 首帧渲染时间 |
| `scene_load_status` | 场景加载状态 |
| `runtime_errors` | 运行时错误列表 |

---

## 3. Implementation Steps（实现步骤）

### 步骤 1：Godot 导出预设配置

1. 在 Godot 编辑器中配置 Export Presets：
   - Platform: Windows Desktop
   - Architecture: x86_64
   - Build Template: release 或 release_debug
2. 导出预设存入 `export_presets.cfg`（已在项目中）

### 步骤 2：构建脚本准备

1. 创建 `scripts/build_windows.bat`（Windows 原生）或 `scripts/build_windows.sh`（Git Bash）
2. 创建 `scripts/verify_export.sh`（构建验证）
3. 创建 `scripts/package_artifact.sh`（artifact 打包）

### 步骤 3：Artifact 命名约定

采用以下命名格式：

```
{project_name}_{version}_{build_mode}_{target}_{timestamp}.{ext}
```

示例：
```
new_game_0.1.0_release_windows_x86_64_20260819_120000.zip
new_game_0.1.0_release_debug_windows_x86_64_20260819_120000.zip
```

### 步骤 4：构建执行

```bash
# Release 构建
./scripts/build_windows.sh --mode release --version 0.1.0

# Release Debug 构建
./scripts/build_windows.sh --mode release_debug --version 0.1.0
```

### 步骤 5：验证与存档

```bash
# 验证构建
./scripts/verify_export.sh {artifact_path}

# 存档
./scripts/package_artifact.sh {artifact_path} evidence/builds/
```

---

## 4. Verification Commands（验证命令）

```bash
# 验证 1：检查导出预设存在
ls -la export_presets.cfg

# 验证 2：检查构建脚本可执行
ls -la scripts/build_windows.sh
head -5 scripts/build_windows.sh

# 验证 3：检查 Godot 可用
which godot || echo "GODOT_BIN: ${GODOT_BIN:-not set}"

# 验证 4：Dry-run 构建
./scripts/build_windows.sh --dry-run --mode release --version 0.1.0

# 验证 5：检查 evidence/builds 目录
ls -la evidence/builds/ 2>/dev/null || echo "evidence/builds/ not yet created"

# 验证 6：验证已有 artifact（如有）
./scripts/verify_export.sh path/to/artifact.zip
```

---

## 5. 构建脚本

### 5.1 主构建脚本：`scripts/build_windows.sh`

```bash
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
```

### 5.2 构建验证脚本：`scripts/verify_export.sh`

```bash
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
```

### 5.3 Artifact 打包脚本：`scripts/package_artifact.sh`

```bash
#!/bin/bash
# ARTIFACT PACKAGING SCRIPT v0.1
# Status: PROPOSAL / DRAFT / NOT APPROVED / NOT AUTHORIZED

set -euo pipefail

ARTIFACT_PATH="${1:-}"
EVIDENCE_DIR="${2:-evidence/builds/$(date +%Y-%m-%d)}"

if [ -z "$ARTIFACT_PATH" ] || [ ! -f "$ARTIFACT_PATH" ]; then
    echo "ERROR: Valid artifact path required"
    echo "Usage: $0 <artifact_path> [evidence_dir]"
    exit 1
fi

mkdir -p "$EVIDENCE_DIR"

# 计算摘要
if command -v sha256sum &> /dev/null; then
    digest=$(sha256sum "$ARTIFACT_PATH" | awk '{print $1}')
elif command -v shasum &> /dev/null; then
    digest=$(shasum -a 256 "$ARTIFACT_PATH" | awk '{print $1}')
else
    digest="UNABLE_TO_CALCULATE"
fi

# 复制 artifact
cp "$ARTIFACT_PATH" "$EVIDENCE_DIR/"

# 生成清单
manifest_file="${EVIDENCE_DIR}/$(basename "$ARTIFACT_PATH").manifest.json"
cat > "$manifest_file" << EOF
{
  "artifact": "$(basename "$ARTIFACT_PATH")",
  "source_path": "$(realpath "$ARTIFACT_PATH")",
  "destination_path": "$(realpath "$EVIDENCE_DIR/$(basename "$ARTIFACT_PATH")")",
  "digest_sha256": "${digest}",
  "packaged_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "packaged_by": "$(whoami)@$(hostname)"
}
EOF

echo "Artifact packaged to: $EVIDENCE_DIR"
echo "Manifest: $manifest_file"
echo "SHA-256: $digest"
```

---

## 6. Artifact 命名约定

### 6.1 文件名格式

```
{project_name}_{version}_{build_mode}_{target}_{timestamp}.{ext}
```

| 组件 | 说明 | 示例 |
|---|---|---|
| `project_name` | 项目名称（小写、下划线） | `new_game` |
| `version` | 语义版本号 | `0.1.0` |
| `build_mode` | 构建模式 | `release`, `release_debug`, `debug` |
| `target` | 目标平台 | `windows_x86_64` |
| `timestamp` | 时间戳（YYYYMMDD_HHMMSS） | `20260819_120000` |
| `ext` | 扩展名 | `.zip`, `.exe`, `.pck` |

### 6.2 示例

```
new_game_0.1.0_release_windows_x86_64_20260819_120000.zip
new_game_0.1.0_release_debug_windows_x86_64_20260819_120000.zip
new_game_0.1.0_debug_windows_x86_64_20260819_120000.zip
```

---

## 7. 构建身份字段

### 7.1 字段定义

| 字段 | 说明 | 来源 |
|---|---|---|
| `source_revision` | Git commit SHA（短格式，12 字符） | `git rev-parse --short=12 HEAD` |
| `build_mode` | 构建模式 | 命令行参数 |
| `config_version` | 配置版本 | 项目配置 |
| `target_platform` | 目标平台 | 固定：`Windows_x86_64` |
| `engine_version` | Godot 引擎版本 | `godot --version` |
| `export_preset` | 导出预设名称 | 固定：`Windows Desktop` |
| `version` | 项目版本号 | 命令行参数 |
| `timestamp` | 构建时间（ISO 8601 UTC） | 系统时间 |

### 7.2 与 cr-112 的对齐

- `target_platform` = `Windows_x86_64`（P1 单一目标）
- `build_mode` = `release` 或 `release_debug`
- `source_revision` + `config_version` + `engine_version` 构成完整 build identity

---

## 8. 不变量保留声明

- 22 项原始 `user_confirmed`、8+1 项 canonical revision-02 inputs、PRECHARTER-01..11、四层 provenance、unresolved 全量保留——本文件不把任何 unresolved 项升级为决策。
- 候选预算（六项性能候选 + `1280×720` 红线）全部保持仅候选，本文件不涉及、不提升。
- 本文件不批准/冻结任何 ADR 或合同。

---

## 9. 边界声明与 Closure

- 未执行任何实际导出/构建；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未派发/扩展成员。
- 所有脚本为 **PROPOSAL / DRAFT** 状态，标记 `NOT_AUTHORIZED`，placeholder 数据不得作为真实证据。
- **Closure：** `closure_ready = yes`（仅限本静态导出配置文档与脚本模板）。不是 kickoff pass、不是实现授权、不是导出验收。

---

## 10. 版本与变更记录

| 版本 | 日期 | 变更 |
|---|---|---|
| v0.1 | 2026-08-19 | 初始版本：导出配置、构建脚本、artifact 命名约定、验证流程 |
