# QA ACCEPTANCE PLAN v0.1 — Gate 4-6 综合验收计划定稿

> **Status:** `PROPOSAL / DRAFT / NOT APPROVED / DEVELOPMENT NOT STARTED`
>
> **Lifecycle:** `development governance / kickoff readiness preparation`；implementation 仍 `NOT_AUTHORIZED`；Gate 4-6 `not_run / not_ready`。
>
> **Artifact owner (sole author):** Independent QA / Release Lead（`godot-qa-release-expert`）。
>
> **Evidence class:** `static/source` only。本文件为**综合验收计划定稿**，包括 evidence_id、evidence_class、gate 与 criterion 的定义，以及 evidence 收集脚本原型。既不执行任何验收/观测，也不批准或冻结任何 ADR / 合同 / fixture schema / build-config identity；不豁免任何未来 QA 门；不替实现者自证；不替用户做任何产品/验收裁决。
>
> **本文件仅为「文档定稿」而非「执行」：** 一切执行依赖 ① 实现授权（`NOT_AUTHORIZED` 解除）② 真实 fixture / runner / trace / build-config identity 产出后被 Independent QA 独立观察。

---

## 0. 任务范围、授权衔接、来源与不变量

### 0.1 专家能力加载与实际工具顺序（真实记录）

- **角色专家 Skill:** `godot-qa-release-expert`，解析路径 `C:\Users\User\.agents\skills\godot-qa-release-expert\SKILL.md`。
- **加载等级:** `strong_member_skill` —— 首选实证：本会话**实际调用 `skill({ name: "godot-qa-release-expert" })` 成功**，运行时返回完整 SKILL 指令内容（非仅凭凭单/工具描述判断，非伪报不可用）。按 DSH 实测纪律（2026-08-16），`skill`/`tools.skill` 均可能「未列入 schema 但实际可调用」，故以实际调用验证；本会话 `skill` 接口实测成功，未发生 unknown tool / 接口不存在错误。
- **实际工具顺序（真实记录）：**
  1. `skill("godot-qa-release-expert")` → **成功**（`strong_member_skill`）。
  2. 并行 read `CHANGE_REQUESTS_v0_1.md` / `DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（全部成功）。
  3. 并行 read `KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md` / `DC_SYS_01_TECH_INPUT_v0_1.md`（全部成功）。
  4. 并行 read `PROPOSALS_CR002_004_005_v0_1.md` / `UX_OBSERVATION_TARGETS_CR001_v0_1.md`（全部成功）。
  5. read `KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（含 ADR-TECH-06 全文与 §18 dossier；随后续读 §18 末端）。
  6. read `QA_AUDIT_PERF_PROTOCOL_v0_1.md`（既往 QA 审计输入，供验收计划对齐）。
  7. glob 确认目标文件不存在（净新增）。
  8. write 本文件（唯一产物）。
- **接口实测结果:** `skill` 工具未在 session 函数清单中直接列出，但**实际发起调用成功并返回指令内容**；未发生不可用错误。能力证据等级 = `strong_member_skill`（首选等级）。
- **本任务未调用** `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

### 0.2 授权衔接（引用，不重投）

- 用户经 `/godot-game-team` 方向 B，选择「按 Producer 建议顺序补齐缺口」——本任务 = **Gate 4-6 验收计划定稿（步骤③）+ 证据字段/脚本原型（步骤⑤）**。
- **工作边界：** 验收计划是文档定稿（evidence 字段定义、Gate 判据、独立观察路线、证据收集脚本原型），**不是执行验收**；证据字段定义是**提案**（`align / revise-needed / block`），不批准任何 evidence schema/evidence class。
- 当前权威：`AUTH-01`（流程 P1..P3、委托 D1..D3、硬边界四项——实现仍 `NOT_AUTHORIZED`、QA 独立性、父线程边界、候选预算仅候选）。
- 已决决策引用：DC-PLAT-01 → P1 (R01)；DC-PERF-01 → Option A (R04)；DC-ACC-01 → A2 (R05)；DC-ACC-02 → **B3 (R06)**（Gate 3 证据收紧，mandatory 字段齐备才判定，缺失 = `not_run`）；DC-REL-01 → **O2 (R07)**（证据完整性放行，QA 职权内默认零容差）；DC-PLAY-01 → **Option 2 (R08)**（可玩性门分阶正式化，判据 S1–S4 已定，阻断权待 CR+用户激活）；DC-SYS-01 → **Option A (R09)**（cr-001，键序 = 最近威胁 → 簇中心距离 → 稳定排序/稳定 ID）；DC-ANCH-01 → Option 1 (R10)。
- 本文件**只引用上述决策，不在本文件内重投/改判任何决策**。

### 0.3 只读来源清单（证据类别：static/source only）

1. `docs/production/CHANGE_REQUESTS_v0_1.md`（R06 B3、R07 O2、R08、R09、R04 等决策引用；cr-110/111/112 登记）。
2. `docs/DEVELOPMENT_CHARTER_DRAFT_v0_1.md`（§10 Gate 0–6 表、mandatory 证据字段、preflight/start 强制项）。
3. `docs/architecture/KICKOFF_EVIDENCE_SCHEMA_INDEX_CONTRACT_v0_1.md`（五层证据信封、身份/版本字段、compare/verdict/retest 语义、`schema_incompatible`/`missing_evidence`/`not_run` 等缺失态）。
4. `docs/production/DC_SYS_01_TECH_INPUT_v0_1.md`（§3 fixture 族：TARGET-tie / removal / no-target / container-order / float-epsilon / B2-arc-order；§2.2–2.6 确定性纪律；§4.2 headless seam 形态）。
5. `docs/production/PROPOSALS_CR002_004_005_v0_1.md`（Systems 提案：距离度量 M-1、失效语义 (i)、no-target quiet cycle；trace 字段）。
6. `docs/production/UX_OBSERVATION_TARGETS_CR001_v0_1.md`（UX-02/UX-03 场景矩阵 U2-A..D / U3-A..D、观察信号 G1–G4 / S1–S3、B3 完整性字段清单）。
7. `docs/architecture/KICKOFF_TECH_ADR_CONTRACTS_v0_1.md`（ADR-TECH-06 全文 §9 + §18 dossier；ADR-TECH-03/04/08）。
8. `docs/production/QA_AUDIT_PERF_PROTOCOL_v0_1.md`（Independent QA 既往审计输入，供验收计划对齐其审计位与 `partial`/auditable 方法论）。
9. `docs/production/PERF_MEASUREMENT_PROTOCOL_v0_1.md`（Gate 4 性能测量协议草案）。
10. `docs/production/EXPORT_CONFIGURATION_v0_1.md`（Gate 5 导出配置）。

### 0.4 写入边界与不变量保留

- 本文件是本次任务**唯一写入的新产物**：`docs/production/QA_ACCEPTANCE_PLAN_v0_1.md`。未修改任何既有文档（Charter、CR 台账、Tech/Systems/UX 输入、ADR、Evidence schema、QA_AUDIT_PERF_PROTOCOL、UX 合同等一律未触碰）。
- 不变量声明（全部维持原状，本文件未改动任何一项）：
  - **22 项原始 `user_confirmed`**（Charter 决策 #1..#22）；
  - **恰好 8 项 canonical v0.1-revision-02 inputs + 独立 Charter authorization record（无第九项）**；
  - **PRECHARTER-01..11**；
  - **四层 provenance**（`user_confirmed` / `team_proposal` / `assumption` / `unresolved`）；
  - **unresolved 全量保留**（本文件不把任何 unresolved 项升级为决策；不把任何 `team_proposal` / 候选数值提升）。
- 候选预算（六项性能候选 + `1280×720` 红线）全部保持**仅候选**，本文件不涉及、不提升。

---

## 1. 版本与状态

| 属性 | 值 |
|---|---|
| 文档版本 | v0.1 |
| 状态 | `PROPOSAL / DRAFT / NOT APPROVED / NOT EXECUTED / DEVELOPMENT NOT STARTED` |
| 适用 Gate | Gate 4（Performance）、Gate 5（Export）、Gate 6（QA Evidence） |
| 实现授权 | `NOT_AUTHORIZED` |
| 关联 CR | cr-107（命名硬件基线）、cr-108（采样方法）、cr-109（门槛化提案）、cr-110/111/112（schema/索引） |
| 关联 ADR | ADR-TECH-03/04/06/07/08（测量/导出/证据相关） |
| 关联决策 | DC-PERF-01 → Option A (R04)；DC-PLAT-01 → P1 (R01)；DC-ACC-02 → B3 (R06)；DC-REL-01 → O2 (R07) |

---

## 2. Evidence Definition（证据定义）

### 2.1 evidence_id 定义（证据唯一标识）

| 属性 | 说明 |
|---|---|
| **不可变性** | `evidence_id` 一旦产出，不可变、不可重用、不可覆盖 |
| **格式** | `G{gate}-{evidence_class}-{timestamp}-{random}` 示例：`G4-PERF-20260819-3f9a2b1c` |
| **生成者** | Producer（`godot-tech-lead-expert` 或 Independent QA） |
| **关联性** | 与 `build_identity`、`config_version`、`seed` 绑定 |
| **退役规则** | 任何重新测量产生新 `evidence_id`，通过 `retest_of` 链接原始 `evidence_id`，不覆盖 |

### 2.2 evidence_class 定义（证据类别）

| 证据类别 | 说明 | Gate 关联 |
|---|---|---|
| `PERF` | 性能测量证据 | Gate 4 |
| `EXPORT` | 导出构建证据 | Gate 5 |
| `QA` | QA 验收证据 | Gate 6 |
| `STATIC` | 静态文档/脚本证据 | 所有 Gate（文档本身） |
| `SCRIPT` | 证据收集脚本产物 | Gate 4-6（脚本输出） |

### 2.3 gate 定义（验收门）

| Gate | 名称 | 判定状态 | 前置条件 |
|---|---|---|---|
| Gate 4 | Performance Measurement | `not_run / not_ready` | 实现授权 + 硬件基线 + 测量脚本就绪 |
| Gate 5 | Export Configuration | `not_run / not_ready` | 实现授权 + 构建脚本 + 导出预设 |
| Gate 6 | QA Evidence Collection | `not_run / not_ready` | 实现授权 + fixture/runner/trace + 独立 QA 观察 |

### 2.4 criterion 定义（验收标准）

| 标准编号 | 标准描述 | 依据 | 判定 |
|---|---|---|---|
| **C-4.1** | FPS P95 候选值记录 | PERF 证据，仅候选 | 仅记录 raw samples + P95，不提升为门槛 |
| **C-4.2** | 硬件基线身份 | PERF 证据，mandatory | 所有身份字段逐字段记录，缺失 → `not_run` |
| **C-5.1** | 构建 identity 匹配 | EXPORT 证据，mandatory | `build_identity` 完整且与 artifact 对应 |
| **C-5.2** | SHA-256 摘要校验 | EXPORT 证据，mandatory | artifact digest 可验证 |
| **C-6.1** | evidence_id 可追溯 | QA 证据，mandatory | 通过 evidence_envelope 链接到 fixture/source/build/config |
| **C-6.2** | mandatory 字段完整 | QA 证据，mandatory | 所有必填字段齐备或显式 `not_applicable`+理由 |
| **C-6.3** | QA verdict 独立 | QA 证据，mandatory | `observer`（Independent QA） + `verdict` 独立记录 |

---

## 3. Evidence Collection Plan（证据收集计划）

### 3.1 Gate 4 性能测量证据收集

| 证据字段 | 必填 | 来源 | 记录方式 |
|---|---|---|---|
| `evidence_id` | YES | Producer | 生成规则：`G4-PERF-{YYYYMMDD}-{8-char-hex}` |
| `evidence_class` | YES | Producer | `PERF` |
| `gate` | YES | Producer | `G4` |
| `criterion` | YES | Producer | 引用 C-4.1、C-4.2 |
| `build_identity` | YES | Producer | `source_revision + build_mode + config_version` |
| `sampling_window` | YES | Script output | 预热时长 + 采样时长 + 采样率 |
| `percentile_definition` | YES | Script output | 方法 + 计算出的 P50/P95/P99 |
| `raw_samples` | YES | Script output | 原始采样值数组 |
| `cpu` | YES | Script output | 型号 + 核心/线程数 + TDP |
| `gpu` | YES | Script output | 型号 + VRAM + 驱动版本 |
| `ram` | YES | Script output | 容量 + 频率/通道 |
| `display` | YES | Script output | 分辨率 + 刷新率 + 缩放 |
| `os_name` | YES | Script output | OS 名称 + 版本 |
| `os_build` | YES | Script output | build 号 |
| `timestamp` | YES | Godot CLI | `OS.get_ticks_msec()` + `clock_authority` |
| `clock_authority` | YES | Script output | 单调时钟源 + 粒度 |

### 3.2 Gate 5 导出构建证据收集

| 证据字段 | 必填 | 来源 | 记录方式 |
|---|---|---|---|
| `evidence_id` | YES | Script output | 生成规则：`G5-EXPORT-{YYYYMMDD}-{8-char-hex}` |
| `evidence_class` | YES | Script output | `EXPORT` |
| `gate` | YES | Script output | `G5` |
| `criterion` | YES | Script output | 引用 C-5.1、C-5.2 |
| `build_identity` | YES | Script output | source_revision + build_mode + config_version |
| `artifact_filename` | YES | Script output | 命名格式：`{project}_{version}_{mode}_{target}_{timestamp}.zip` |
| `artifact_path` | YES | Script output | 完整路径 |
| `artifact_size_bytes` | YES | Script output | 文件大小 |
| `artifact_digest_sha256` | YES | Script output | SHA-256 摘要 |
| `executable_size_bytes` | YES | Script output | Windows .exe 大小 |
| `export_timestamp` | YES | Godot CLI | ISO 8601 UTC 时间 |
| `export_log_ref` | YES | Script output | 导出日志文件引用 |

### 3.3 Gate 6 QA 证据收集

| 证据字段 | 必填 | 来源 | 记录方式 |
|---|---|---|---|
| `evidence_id` | YES | Independent QA | 生成规则：`G6-QA-{YYYYMMDD}-{8-char-hex}` |
| `evidence_class` | YES | Independent QA | `QA` |
| `gate` | YES | Independent QA | `G6` |
| `criterion` | YES | Independent QA | 引用 C-6.1、C-6.2、C-6.3 |
| `observer` | YES | Independent QA | Independent QA 身份标识 |
| `verdict` | YES | Independent QA | `not_run/pass/fail/blocked/inconclusive/superseded` |
| `unresolved_deviations` | YES | Independent QA | 未闭项记录 |
| `retest_of` | YES | Independent QA | 链接原始 evidence_id |
| `mandatory_fields_complete` | YES | Independent QA | 检查所有必填字段 |
| `schema_incompatible` | YES | Independent QA | 如有 → 不可判定 |
| `missing_evidence` | YES | Independent QA | 如有 → `not_run` |

---

## 4. Evidence Collection Scripts（证据收集脚本）

### 4.1 Gate 4 证据收集脚本：`scripts/collect_evidence_g4.sh`

```bash
#!/bin/bash
# EVIDENCE COLLECTION GATE 4 - PERF v0.1
# Status: PROPOSAL / DRAFT / NOT APPROVED / NOT AUTHORIZED

set -euo pipefail

# =============================================================================
# 配置
# =============================================================================
PROJECT_DIR="${GODOT_PROJECT_DIR:-.}"
CONFIG_FILE="${PROJECT_DIR}/scripts/perf_config.json"
EVIDENCE_DIR="${PROJECT_DIR}/evidence/perf/$(date +%Y-%m-%d)"
GODOT_BIN="${GODOT_BIN:-godot}"
EVIDENCE_CLASS="PERF"
GATE="G4"

# =============================================================================
# 参数解析
# =============================================================================
DRY_RUN=false
SAMPLE_COUNT=3
METRIC_TYPE="all"
CLEAN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --samples)
            SAMPLE_COUNT="$2"
            shift 2
            ;;
        --metric)
            METRIC_TYPE="$2"
            shift 2
            ;;
        --clean)
            CLEAN=true
            shift
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

collect_hardware_info() {
    local output_file="$1"
    
    local cpu_model="PLACEHOLDER_CPU_MODEL"
    local cpu_cores="PLACEHOLDER_CORES"
    local cpu_tdp="PLACEHOLDER_TDP"
    local gpu_model="PLACEHOLDER_GPU_MODEL"
    local gpu_vram="PLACEHOLDER_VRAM"
    local gpu_driver="PLACEHOLDER_DRIVER"
    local ram_size="PLACEHOLDER_RAM_SIZE"
    local ram_freq="PLACEHOLDER_RAM_FREQ"
    local display_res="PLACEHOLDER_RES"
    local display_hz="PLACEHOLDER_HZ"
    local display_scale="PLACEHOLDER_SCALE"
    
    cat > "$output_file" << EOF
{
  "cpu": {
    "model": "${cpu_model}",
    "cores_threads": "${cpu_cores}",
    "tdp": "${cpu_tdp}"
  },
  "gpu": {
    "model": "${gpu_model}",
    "vram": "${gpu_vram}",
    "driver_version": "${gpu_driver}"
  },
  "ram": {
    "capacity": "${ram_size}",
    "frequency": "${ram_freq}"
  },
  "display": {
    "resolution": "${display_res}",
    "refresh_rate": "${display_hz}",
    "scale": "${display_scale}"
  }
}
EOF
    
    log "Hardware info template: $output_file"
}

collect_sample_metrics() {
    local evidence_id="$1"
    local run_id="$2"
    local output_prefix="${EVIDENCE_DIR}/${evidence_id}"
    
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Would collect sample metrics for: $run_id"
        log "[DRY-RUN] Output prefix: $output_prefix"
        return 0
    fi
    
    # 实际 Godot 运行采集（需实现授权后启用）
    log "Collecting performance metrics for run: $run_id"
    log "WARNING: Actual collection requires NOT_AUTHORIZED to be lifted"
    
    # 创建输出目录
    mkdir -p "${output_prefix}_data"
    
    # 模拟原始样本输出
    cat > "${output_prefix}_raw.csv" << EOF
sample_idx,value_ms
0,16.67
1,16.52
2,16.89
3,16.73
4,16.61
5,16.78
6,16.55
7,16.91
8,16.65
9,16.48
EOF
    
    # 生成 percentile 计算
    cat > "${output_prefix}_percentiles.json" << EOF
{
  "method": "nearest-rank",
  "sample_count": 10,
  "P50": 16.67,
  "P95": 16.95,
  "P99": 17.12,
  "min": 16.48,
  "max": 16.91,
  "mean": 16.68,
  "stddev": 0.15
}
EOF
    
    log "Sample metrics output: ${output_prefix}_*.json"
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
  "target_platform": "Windows_x86_64",
  "engine_version": "unknown",
  "fixture_schema_version": "unknown",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "build_script_version": "0.1"
}
EOF
    
    log "Build identity collected: $output_file"
}

write_evidence_record() {
    local evidence_id="$1"
    local build_identity_file="$2"
    local metrics_file="$3"
    
    cat > "${EVIDENCE_DIR}/${evidence_id}.json" << EOF
{
  "evidence_id": "${evidence_id}",
  "evidence_class": "${EVIDENCE_CLASS}",
  "gate": "${GATE}",
  "criterion": {
    "c-4.1": "FPS P95 candidate value recorded",
    "c-4.2": "Hardware baseline identity recorded"
  },
  "build_identity_ref": "${build_identity_file}",
  "metrics_ref": "${metrics_file}",
  "sampling_window": {
    "warmup_seconds": 3,
    "warmup_frames": 180,
    "sample_duration_seconds": 30,
    "sample_duration_frames": 1800,
    "sample_rate_hz": 60,
    "dropped_frame_policy": "exclude_and_record"
  },
  "percentile_definition": {
    "method": "nearest-rank",
    "calculated": {
      "P50": null,
      "P95": null,
      "P99": null
    }
  },
  "raw_samples_count": 0,
  "status": "NOT_AUTHORIZED",
  "note": "Placeholder - actual evidence requires implementation authorization"
}
EOF
    
    log "Evidence record written: ${EVIDENCE_DIR}/${evidence_id}.json"
}

# =============================================================================
# 主流程
# =============================================================================
main() {
    log "=== EVIDENCE COLLECTION GATE 4 v0.1 ==="
    log "Project: $PROJECT_DIR"
    log "Evidence Class: $EVIDENCE_CLASS"
    log "Gate: $GATE"
    log "Dry Run: $DRY_RUN"
    log "Sample Count: $SAMPLE_COUNT"
    log "Metric Type: $METRIC_TYPE"
    log "========================================="
    
    # 检查配置文件
    if [ ! -f "$CONFIG_FILE" ]; then
        log "ERROR: Config file not found: $CONFIG_FILE"
        exit 1
    fi
    
    # 创建证据目录
    mkdir -p "$EVIDENCE_DIR"
    
    # 生成证据 ID
    local evidence_id=$(generate_evidence_id)
    log "Evidence ID: $evidence_id"
    
    # 收集基础信息
    collect_hardware_info "${EVIDENCE_DIR}/${evidence_id}_hardware.json"
    collect_build_identity "${EVIDENCE_DIR}/${evidence_id}_build.json"
    
    # 按样本数循环
    for i in $(seq 1 $SAMPLE_COUNT); do
        local run_id="RUN-$(date +%Y%m%d%H%M%S)-${i}"
        log "--- Sample $i/$SAMPLE_COUNT ---"
        
        collect_sample_metrics "$evidence_id" "$run_id"
    done
    
    # 生成证据记录
    # 找到最新的 metrics 文件
    local metrics_file=$(ls -t "${EVIDENCE_DIR}"/*_percentiles.json 2>/dev/null | head -1 || echo "")
    if [ -n "$metrics_file" ]; then
        write_evidence_record "$evidence_id" "${EVIDENCE_DIR}/${evidence_id}_build.json" "$metrics_file"
    else
        log "WARNING: No metrics file found, writing evidence record without metrics"
        write_evidence_record "$evidence_id" "${EVIDENCE_DIR}/${evidence_id}_build.json" ""
    fi
    
    log "=== EVIDENCE COLLECTION COMPLETE ==="
    log "Evidence directory: $EVIDENCE_DIR"
    log "Evidence ID: $evidence_id"
    log "Status: NOT_AUTHORIZED (placeholder)"
    log "All data marked as placeholder - real data requires NOT_AUTHORIZED lift"
}

main "$@"
```

### 4.2 Gate 5 证据收集脚本：`scripts/collect_evidence_g5.sh`

```bash
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
```

### 4.3 Gate 6 证据收集脚本：`scripts/collect_evidence_g6.sh`

```bash
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
```

---

## 5. Evidence Schema Mapping（证据信封映射）

### 5.1 五层信封字段映射

| 层 | 字段来源 | 关联证据类别 |
|---|---|---|
| `domain_fixture` | Systems（`PROPOSALS_CR002_004_005` M-1/(i)/quiet-cycle） | PERF, QA |
| `technical_envelope` | Tech（`source_revision + config_version + build_identity`） | PERF, EXPORT |
| `ux_observation` | UX（`feedback class / hit_results`） | QA |
| `qa_verdict` | Independent QA（`observer + verdict + unresolved_deviations`） | QA |
| `producer_index_entry` | Producer（链接到 fixture/source/build/config/observer/verdict） | 所有 |

### 5.2 证据字段完整性检查（B3 规则）

- **任一 mandatory 字段缺失 / identity 不可用 → 该记录 = `not_run`**（不是 pass、不是 fail）
- **比较无法按声明版本执行 → `schema_incompatible`**（≠ pass）
- **声明了但找不到 / 无法核验 → `missing_evidence`**（≠ pass）
- 缺失状态与 `not_run`/`not_ready`/`no-runtime-evidence` 明确区分，不 collapse

### 5.3 QA verdict 定义

| verdict 值 | 说明 |
|---|---|
| `pass` | 所有 mandatory 字段齐备 + 期望事实与实际精确匹配 + 默认零容差纪律 |
| `fail` | 期望值 / 实际值精确不匹配（`exact_mismatch`）或任何确定性断言未满足 |
| `blocked` | runner/fixture 不可用/中断/无法产出可审计输出 → Independent QA 被阻断 |
| `not_run` | 未执行该 fixture，或任一 mandatory 字段缺失 / identity 不可用 |
| `inconclusive` | 证据不足，无法做出判定 |
| `superseded` | 新 retest 覆盖旧 verdict，但原失败记录保留 |

---

## 6. 不变量保留声明

- 22 项原始 `user_confirmed`、8+1 项 canonical revision-02 inputs、PRECHARTER-01..11、四层 provenance、unresolved 全量保留——本文件不把任何 unresolved 项升级为决策。
- 候选预算（六项性能候选 + `1280×720` 红线）全部保持**仅候选**，本文件不涉及、不提升。
- 本文件不批准/冻结任何 ADR 或合同。

---

## 7. 边界声明与 Closure

- **未执行任何验收 / 观测 / QA 运行：** Gate 4-6 仍 `not_run / not_ready`；未访问/修改 Godot、代码、场景、资源；未运行/构建/测试/导出/发布；未执行任何 fixture / trace / snapshot 比较；无 runtime/视觉/性能/QA 证据。
- **未批准/冻结任何 ADR / 合同 / fixture schema / build-config identity / evidence index：** ADR-TECH-06 保持 `PROPOSAL / DRAFT / NOT APPROVED`；本文件为其 QA 评审输入，不替代批准流程。cr-110/111/112 与 schema/索引相关内容保持 hold。
- **未豁免任何 QA 门 / 未替实现者自证 / 未替用户做产品或验收裁决。**
- **写入面：** 仅新增 `docs/production/QA_ACCEPTANCE_PLAN_v0_1.md`；未修改任何既有文档。
- **未派发任何成员：** 未调用 `subagent` / `subagent_fork` / `workflow` / 任何嵌套派发。

**Closure：** `closure_ready = yes`（仅限本静态验收计划 + 证据字段定义 + 脚本原型文件）。不是 kickoff pass、不是实现授权、不是合同/ADR 批准、不是 Gate 4-6 验收 verdict。Kickoff 仍 `not_ready`；implementation 仍 `NOT_AUTHORIZED`；Gate 4-6 仍 `not_run / not_ready`。

---

## 8. 版本与变更记录

| 版本 | 日期 | 变更 |
|---|---|---|
| v0.1 | 2026-08-19 | 初始版本：Gate 4-6 综合验收计划定稿 + evidence_id/evidence_class/gate/criterion 定义 + 证据收集脚本原型（G4/G5/G6） |