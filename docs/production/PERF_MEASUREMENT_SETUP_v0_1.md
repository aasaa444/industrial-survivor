# PERF MEASUREMENT SETUP v0.1 — Gate 4 性能测量设置与采集脚本

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`。
>
> **Owner:** Tech Lead（`godot-tech-lead-expert`）。
>
> **本文件是什么：** 为 Gate 4 性能测量提供**可执行的设置文档与 Godot CLI 采集脚本**，包含采样窗口定义、percentile 计算方法、硬件规格记录模板、以及自动化采集脚本。
>
> **本文件不是什么：** 不是性能测量执行/运行；不是门槛、验收、发布承诺；不把任何候选预算提升为正式门槛；不替用户决策；不豁免 QA blocker；不替 Independent QA 下 verdict。
>
> **证据类别：** `static/source` only。未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/测性能/导出/发布；未派发任何成员。
>
> **前置依赖：** `PERF_MEASUREMENT_PROTOCOL_v0_1.md`（测量身份与方法论定义）。

---

## 1. 版本与状态

| 属性 | 值 |
|---|---|
| 文档版本 | v0.1 |
| 状态 | `PROPOSAL / DRAFT / NOT APPROVED` |
| 适用 Gate | Gate 4（Performance） |
| 实现授权 | `NOT_AUTHORIZED` |
| 关联 CR | cr-107（命名硬件基线）、cr-108（采样方法）、cr-109（门槛化提案） |
| 关联 ADR | ADR-TECH-07（测量协议模板） |

---

## 2. Evidence Required（Gate 4 所需证据清单）

### 2.1 必需证据字段（mandatory per-sample）

| 字段类别 | 字段名 | 说明 | 必填 |
|---|---|---|---|
| 身份链 | `evidence_id` | 不可变唯一 ID | YES |
| 身份链 | `build_identity` | source revision + build_mode + config_version | YES |
| 身份链 | `sample_run_id` | 采样运行 ID | YES |
| 硬件规格 | `cpu` | 型号 + 核心/线程数 + TDP/睿频档 | YES |
| 硬件规格 | `gpu` | 型号 + VRAM + 驱动版本 | YES |
| 硬件规格 | `ram` | 容量 + 频率/通道 | YES |
| 硬件规格 | `display` | 分辨率 + 刷新率 + 缩放 | YES |
| OS 信息 | `os_name` | OS 名称 + 精确版本（如 Windows 10 22H2） | YES |
| OS 信息 | `os_build` | build 号 | YES |
| OS 信息 | `power_mode` | 电源模式（平衡/高性能/游戏模式） | YES |
| 设置 | `resolution` | 渲染分辨率 ≠ 窗口/物理分辨率 | YES |
| 设置 | `renderer` | renderer/后端 + VSync/帧上限/抗锯齿 | YES |
| 设置 | `window_mode` | 窗口化/无边框/独占全屏 | YES |
| 采样上下文 | `sampling_window` | 预热时长 + 采样时长 + 采样率 | YES |
| 采样上下文 | `dropped_frames` | 丢帧行为（排除/记录） | YES |
| 时间戳 | `timestamp` | 墙钟时间（ISO 8601） | YES |
| 时间戳 | `clock_authority` | 单调时钟源 API + 粒度 | YES |

### 2.2 必需证据字段（mandatory per-metric）

| 字段名 | 说明 |
|---|---|
| `metric_name` | 被测指标名称（如 `fps`, `input_latency_ms`, `cold_start_ms`） |
| `raw_samples` | 原始采样值数组 |
| `sample_count` | 样本数 |
| `percentile_definition` | percentile 方法（nearest-rank / linear interpolation） |
| `P50` | 第 50 百分位值 |
| `P95` | 第 95 百分位值 |
| `P99` | 第 99 百分位值 |
| `min` | 最小值 |
| `max` | 最大值 |
| `mean` | 均值 |
| `stddev` | 标准差 |
| `dropped_count` | 被排除的样本数 |

---

## 3. Implementation Steps（实现步骤）

### 步骤 1：环境准备

1. 确认 Godot 项目可编译/运行（`NOT_AUTHORIZED` 解除后）
2. 确认目标平台为 Windows 10+ x86_64
3. 确认测量机硬件基线已记录

### 步骤 2：采样窗口配置

在 `scripts/perf_config.json` 中定义：

```json
{
  "sampling": {
    "warmup_seconds": 3,
    "warmup_frames": 180,
    "sample_duration_seconds": 30,
    "sample_duration_frames": 1800,
    "sample_rate_hz": 60,
    "dropped_frame_policy": "exclude_and_record"
  },
  "percentile": {
    "method": "nearest-rank",
    "requested": ["P50", "P95", "P99"]
  },
  "clock": {
    "primary": "monotonic",
    "source_api": "OS.get_ticks_msec()",
    "granularity_ms": 1
  }
}
```

### 步骤 3：采集脚本执行

运行 `scripts/collect_perf_metrics.sh`（见 §5）

### 步骤 4：数据导出与存档

1. 采集数据存入 `evidence/perf/YYYY-MM-DD/` 目录
2. 每个样本目录包含：
   - `{evidence_id}_metadata.json`（硬件/OS/设置身份）
   - `{evidence_id}_raw.csv`（原始采样值）
   - `{evidence_id}_percentiles.json`（计算后的 percentile）
   - `{evidence_id}_build.json`（构建身份）

### 步骤 5：QA 审计准备

1. 确保 `evidence_id` 唯一且不可变
2. 确保硬件/OS/设置字段逐字段记录，缺失项标注 `missing_evidence`
3. 确保 `timestamp` 配 `clock_authority`

---

## 4. Verification Commands（验证命令）

```bash
# 验证 1：检查采样配置文件存在且格式正确
cat scripts/perf_config.json | python -m json.tool

# 验证 2：检查采集脚本可执行
ls -la scripts/collect_perf_metrics.sh
head -5 scripts/collect_perf_metrics.sh  # 应有 #!/bin/bash

# 验证 3：检查硬件信息采集脚本
ls -la scripts/collect_hardware_info.sh
cat scripts/collect_hardware_info.sh | grep -i "cpu\|gpu\|ram"

# 验证 4：检查 evidence 输出目录结构
ls -la evidence/perf/ 2>/dev/null || echo "evidence/perf/ not yet created"

# 验证 5：Dry-run 采集脚本（不实际采集，仅测试逻辑）
./scripts/collect_perf_metrics.sh --dry-run
```

---

## 5. Godot CLI 采集脚本

### 5.1 主采集脚本：`scripts/collect_perf_metrics.sh`

```bash
#!/bin/bash
# PERF METRICS COLLECTION SCRIPT v0.1
# Gate 4 Performance Measurement - Godot CLI 采集
# Status: PROPOSAL / DRAFT / NOT APPROVED / NOT AUTHORIZED

set -euo pipefail

# =============================================================================
# 配置
# =============================================================================
PROJECT_DIR="${GODOT_PROJECT_DIR:-.}"
CONFIG_FILE="${PROJECT_DIR}/scripts/perf_config.json"
EVIDENCE_DIR="${PROJECT_DIR}/evidence/perf/$(date +%Y-%m-%d)"
GODOT_BIN="${GODOT_BIN:-godot}"

# =============================================================================
# 参数解析
# =============================================================================
DRY_RUN=false
METRIC_TYPE="all"
SAMPLE_COUNT=3

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --metric)
            METRIC_TYPE="$2"
            shift 2
            ;;
        --samples)
            SAMPLE_COUNT="$2"
            shift 2
            ;;
        --project-dir)
            PROJECT_DIR="$2"
            CONFIG_FILE="${PROJECT_DIR}/scripts/perf_config.json"
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
    echo "PERF-${timestamp}-${random}"
}

collect_hardware_info() {
    local output_file="$1"
    
    cat > "$output_file" << 'HARDWARE_EOF'
{
  "platform_target": "Windows x86_64",
  "os_name": "PLACEHOLDER_OS_NAME",
  "os_build": "PLACEHOLDER_OS_BUILD",
  "os_edition": "PLACEHOLDER_EDITION",
  "power_mode": "PLACEHOLDER_POWER_MODE",
  "cpu": {
    "model": "PLACEHOLDER_CPU_MODEL",
    "cores_threads": "PLACEHOLDER_CORES",
    "tdp": "PLACEHOLDER_TDP",
    "turbo": "PLACEHOLDER_TURBO"
  },
  "gpu": {
    "model": "PLACEHOLDER_GPU_MODEL",
    "vram": "PLACEHOLDER_VRAM",
    "driver_version": "PLACEHOLDER_DRIVER"
  },
  "ram": {
    "capacity": "PLACEHOLDER_RAM_SIZE",
    "frequency": "PLACEHOLDER_RAM_FREQ",
    "channels": "PLACEHOLDER_RAM_CH"
  },
  "display": {
    "resolution": "PLACEHOLDER_RES",
    "refresh_rate": "PLACEHOLDER_HZ",
    "scale": "PLACEHOLDER_SCALE",
    "window_mode": "PLACEHOLDER_WINDOW_MODE"
  }
}
HARDWARE_EOF
    
    log "Hardware info template created: $output_file"
    log "WARNING: PLACEHOLDER values must be filled before actual measurement"
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
  "build_mode": "release",
  "config_version": "unknown",
  "fixture_schema_version": "unknown",
  "target_platform": "Windows_x86_64",
  "engine_version": "unknown",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    
    log "Build identity collected: $output_file"
}

collect_fps_metrics() {
    local evidence_id="$1"
    local run_id="$2"
    local output_file="${EVIDENCE_DIR}/${evidence_id}_fps.json"
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Would collect FPS metrics for run: $run_id"
        log "[DRY-RUN] Output: $output_file"
        return 0
    fi
    
    # 实际 Godot 运行采集逻辑（需实现授权后启用）
    log "Collecting FPS metrics for run: $run_id"
    log "NOTE: Actual collection requires NOT_AUTHORIZED to be lifted"
    
    # 模拟输出结构
    cat > "$output_file" << EOF
{
  "evidence_id": "${evidence_id}",
  "sample_run_id": "${run_id}",
  "metric_name": "fps",
  "sampling_window": {
    "warmup_seconds": 3,
    "sample_duration_seconds": 30,
    "sample_rate_hz": 60,
    "dropped_frame_policy": "exclude_and_record"
  },
  "raw_samples": [],
  "sample_count": 0,
  "percentile_definition": "nearest-rank",
  "P50": null,
  "P95": null,
  "P99": null,
  "min": null,
  "max": null,
  "mean": null,
  "stddev": null,
  "dropped_count": 0,
  "clock_authority": {
    "source_api": "OS.get_ticks_msec()",
    "granularity_ms": 1,
    "type": "monotonic"
  },
  "status": "NOT_AUTHORIZED",
  "note": "Placeholder - actual collection requires implementation authorization"
}
EOF
    
    log "FPS metrics output: $output_file"
}

collect_input_latency() {
    local evidence_id="$1"
    local run_id="$2"
    local output_file="${EVIDENCE_DIR}/${evidence_id}_input_latency.json"
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Would collect input latency for run: $run_id"
        return 0
    fi
    
    log "Collecting input latency for run: $run_id"
    log "NOTE: Actual collection requires NOT_AUTHORIZED to be lifted"
    
    cat > "$output_file" << EOF
{
  "evidence_id": "${evidence_id}",
  "sample_run_id": "${run_id}",
  "metric_name": "input_latency_ms",
  "candidate_threshold_ms": 50,
  "sampling": {
    "method": "input_event_to_observable_state_change",
    "input起点": "Input.is_action_pressed() timestamp",
    "反馈终点": "visual/audio feedback first frame"
  },
  "raw_samples": [],
  "sample_count": 0,
  "percentile_definition": "nearest-rank",
  "P50": null,
  "P95": null,
  "P99": null,
  "min": null,
  "max": null,
  "mean": null,
  "stddev": null,
  "dropped_count": 0,
  "status": "NOT_AUTHORIZED"
}
EOF
    
    log "Input latency output: $output_file"
}

collect_cold_start() {
    local evidence_id="$1"
    local run_id="$2"
    local output_file="${EVIDENCE_DIR}/${evidence_id}_cold_start.json"
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Would collect cold start for run: $run_id"
        return 0
    fi
    
    log "Collecting cold start for run: $run_id"
    log "NOTE: Actual collection requires NOT_AUTHORIZED to be lifted"
    
    cat > "$output_file" << EOF
{
  "evidence_id": "${evidence_id}",
  "sample_run_id": "${run_id}",
  "metric_name": "cold_start_ms",
  "candidate_threshold_ms": 3000,
  "timing_definition": {
    "start_point": "process launch",
    "end_point": "first playable frame",
    "includes_window_init": true
  },
  "raw_samples": [],
  "sample_count": 0,
  "percentile_definition": "nearest-rank",
  "P50": null,
  "P95": null,
  "P99": null,
  "min": null,
  "max": null,
  "mean": null,
  "status": "NOT_AUTHORIZED"
}
EOF
    
    log "Cold start output: $output_file"
}

# =============================================================================
# 主流程
# =============================================================================
main() {
    log "=== PERF METRICS COLLECTION v0.1 ==="
    log "Project: $PROJECT_DIR"
    log "Config: $CONFIG_FILE"
    log "Evidence Dir: $EVIDENCE_DIR"
    log "Dry Run: $DRY_RUN"
    log "Metric Type: $METRIC_TYPE"
    log "Sample Count: $SAMPLE_COUNT"
    log "====================================="
    
    # 检查配置文件
    if [ ! -f "$CONFIG_FILE" ]; then
        log "ERROR: Config file not found: $CONFIG_FILE"
        exit 1
    fi
    
    # 创建证据目录
    mkdir -p "$EVIDENCE_DIR"
    
    # 收集基础信息
    local base_evidence_id=$(generate_evidence_id)
    log "Base Evidence ID: $base_evidence_id"
    
    collect_hardware_info "${EVIDENCE_DIR}/${base_evidence_id}_hardware.json"
    collect_build_identity "${EVIDENCE_DIR}/${base_evidence_id}_build.json"
    
    # 按样本数循环
    for i in $(seq 1 $SAMPLE_COUNT); do
        local sample_evidence_id="${base_evidence_id}-S${i}"
        local run_id="RUN-$(date +%Y%m%d%H%M%S)-${i}"
        
        log "--- Sample $i/$SAMPLE_COUNT: $sample_evidence_id ---"
        
        case $METRIC_TYPE in
            fps)
                collect_fps_metrics "$sample_evidence_id" "$run_id"
                ;;
            input_latency)
                collect_input_latency "$sample_evidence_id" "$run_id"
                ;;
            cold_start)
                collect_cold_start "$sample_evidence_id" "$run_id"
                ;;
            all)
                collect_fps_metrics "$sample_evidence_id" "$run_id"
                collect_input_latency "$sample_evidence_id" "$run_id"
                collect_cold_start "$sample_evidence_id" "$run_id"
                ;;
            *)
                log "ERROR: Unknown metric type: $METRIC_TYPE"
                exit 1
                ;;
        esac
    done
    
    log "=== COLLECTION COMPLETE ==="
    log "Evidence directory: $EVIDENCE_DIR"
    log "Status: All samples marked NOT_AUTHORIZED (placeholder)"
}

main "$@"
```

### 5.2 硬件信息采集脚本：`scripts/collect_hardware_info.sh`

```bash
#!/bin/bash
# HARDWARE INFO COLLECTION SCRIPT v0.1
# Status: PROPOSAL / DRAFT / NOT APPROVED / NOT AUTHORIZED

set -euo pipefail

OUTPUT_FILE="${1:-hardware_info.json}"

cat > "$OUTPUT_FILE" << 'EOF'
{
  "platform_target": "Windows x86_64",
  "os_name": "PLACEHOLDER_OS_NAME",
  "os_build": "PLACEHOLDER_OS_BUILD",
  "os_edition": "PLACEHOLDER_EDITION",
  "power_mode": "PLACEHOLDER_POWER_MODE",
  "cpu": {
    "model": "PLACEHOLDER_CPU_MODEL",
    "cores_threads": "PLACEHOLDER_CORES",
    "tdp": "PLACEHOLDER_TDP",
    "turbo": "PLACEHOLDER_TURBO"
  },
  "gpu": {
    "model": "PLACEHOLDER_GPU_MODEL",
    "vram": "PLACEHOLDER_VRAM",
    "driver_version": "PLACEHOLDER_DRIVER"
  },
  "ram": {
    "capacity": "PLACEHOLDER_RAM_SIZE",
    "frequency": "PLACEHOLDER_RAM_FREQ",
    "channels": "PLACEHOLDER_RAM_CH"
  },
  "display": {
    "resolution": "PLACEHOLDER_RES",
    "refresh_rate": "PLACEHOLDER_HZ",
    "scale": "PLACEHOLDER_SCALE",
    "window_mode": "PLACEHOLDER_WINDOW_MODE"
  },
  "collection_timestamp": "PLACEHOLDER_TIMESTAMP",
  "clock_authority": {
    "source_api": "date (wall clock)",
    "type": "wall"
  },
  "status": "PLACEHOLDER_NOT_FILLED",
  "note": "All PLACEHOLDER values must be filled manually or via automation before measurement"
}
EOF

echo "Hardware info template written to: $OUTPUT_FILE"
echo "WARNING: This is a PLACEHOLDER template. Fill all PLACEHOLDER values before actual measurement."
```

### 5.3 验证脚本：`scripts/verify_perf_setup.sh`

```bash
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
```

---

## 6. 采样窗口详细定义

### 6.1 FPS 采样窗口

| 参数 | 值 | 说明 |
|---|---|---|
| 预热时长 | 3 秒（180 帧 @60fps） | 排除场景加载/初始化抖动 |
| 采样时长 | 30 秒（1800 帧 @60fps） | 稳定状态性能 |
| 采样率 | 每逻辑帧 | 即 60Hz 采样 |
| 丢帧策略 | 排除并记录 | 丢帧不计入有效样本，但记录丢帧数 |

### 6.2 Input Latency 采样窗口

| 参数 | 值 | 说明 |
|---|---|---|
| 预热 | 10 次输入 | 排除首次输入抖动 |
| 采样次数 | 100 次 | 每次记录输入到可观测状态改变 |
| 候选阈值 | ≤50ms | 仅候选，须 CR + 用户批准 |

### 6.3 Cold Start 采样窗口

| 参数 | 值 | 说明 |
|---|---|---|
| 采样次数 | 10 次 | 多次取中位数 |
| 起点 | 进程启动 | `CreateProcess()` 时间戳 |
| 终点 | 首个可玩帧 | 场景加载完成 + 首帧渲染 |
| 候选阈值 | <3s | 仅候选，须 CR + 用户批准 |

---

## 7. Percentile 计算方法

### 7.1 方法定义

- **Nearest-rank（默认）：**
  - 排序样本后，选择第 `ceil(percentile/100 * n)` 个值
  - `P50` = 中位数（第 50 百分位）
  - `P95` = 第 95 百分位
  - `P99` = 第 99 百分位

- **Linear interpolation（备选）：**
  - 在相邻秩之间线性插值
  - 需在 `percentile_definition` 字段中明确标注

### 7.2 实现参考（Python）

```python
import numpy as np

def calculate_percentiles(raw_samples, method='nearest-rank'):
    samples = np.array(raw_samples)
    n = len(samples)
    
    if method == 'nearest-rank':
        p50 = np.percentile(samples, 50, interpolation='nearest')
        p95 = np.percentile(samples, 95, interpolation='nearest')
        p99 = np.percentile(samples, 99, interpolation='nearest')
    elif method == 'linear':
        p50 = np.percentile(samples, 50, interpolation='linear')
        p95 = np.percentile(samples, 95, interpolation='linear')
        p99 = np.percentile(samples, 99, interpolation='linear')
    else:
        raise ValueError(f"Unknown method: {method}")
    
    return {
        'P50': float(p50),
        'P95': float(p95),
        'P99': float(p99),
        'min': float(np.min(samples)),
        'max': float(np.max(samples)),
        'mean': float(np.mean(samples)),
        'stddev': float(np.std(samples)),
        'sample_count': n
    }
```

---

## 8. 时钟权威定义

### 8.1 单调时钟（主）

- **用途：** 帧时间、间隔、采样窗口、input latency 测量
- **API：** `OS.get_ticks_msec()`（Godot）或平台等效
- **粒度：** 1ms
- **特性：** 不受系统时间调整影响

### 8.2 墙钟（辅）

- **用途：** 事件起始/索引、`timestamp` 字段
- **格式：** ISO 8601（UTC）
- **用途：** 可审计性、时间线重建

---

## 9. 不变量保留声明

- 22 项原始 `user_confirmed`、8+1 项 canonical revision-02 inputs、PRECHARTER-01..11、四层 provenance、unresolved 全量保留——本文件不把任何 unresolved 项升级为决策。
- 候选预算 = `1080p/60`、`50 FPS minimum`、input `≤50ms`、hit-feedback start `≤100ms`、cold start `<3s`、restart `<1s`。**全部仅候选**，本文件不提升任何一项。
- 本文件不批准/冻结任何 ADR 或合同。

---

## 10. 边界声明与 Closure

- 未执行任何实际测量；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未派发/扩展成员。
- 所有脚本为 **PROPOSAL / DRAFT** 状态，标记 `NOT_AUTHORIZED`，placeholder 数据不得作为真实证据。
- **Closure：** `closure_ready = yes`（仅限本静态设置文档与脚本模板）。不是 kickoff pass、不是实现授权、不是性能验收。

---

## 11. 版本与变更记录

| 版本 | 日期 | 变更 |
|---|---|---|
| v0.1 | 2026-08-19 | 初始版本：采样窗口定义、percentile 方法、硬件规格模板、Godot CLI 采集脚本 |
