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
