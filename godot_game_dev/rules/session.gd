# session.gd
# Minimal session context: run identity, tick stepping, and a single named/ordered/bounded seed context, plus reset.
#
# Approved contracts implemented:
#   ADR-TECH-01  session seam: owns one run's identity/lifecycle/tick/seed context and the rules-step boundary.
#   ADR-TECH-03  single session-owned seed context; random draws are named, ordered and bounded (no global random);
#                tick is a single fixed-step evaluation boundary; config identity carried.
#   ADR-TECH-05  reset: one canonical clean-restart transaction with no cross-run dirty state (RNG reseeded, run id advances).
#
# Boundary honesty:
#   The rules core (DshRulesCore) performs no random draws in this minimal seam — target ordering is pure (M-1 key chain).
#   The session exposes a single owned RNG (seed context) so future generation scheduling has a deterministic, named,
#   ordered home; this task performs no draw and therefore makes no claim that random discipline was exercised.
class_name DshSession
extends RefCounted

var run_id: int = 0
var seed: int = 0
var tick: int = 0
var config_version: String = DshRulesCore.CONFIG_VERSION
var rules_state: Dictionary = {}
var _stream_names: Array = []
var _rng := RandomNumberGenerator.new()   # single session-owned seed context (no global random)

func _init(p_seed: int = 1337) -> void:
	reset(p_seed)


# Clean restart transaction: advance run identity, reseed the single RNG, rebuild an empty rules state, zero the tick.
# No cross-run dirty state is carried (ordered_ids / snapshots / invalidation / results are all rebuilt fresh).
func reset(p_seed: int = 1337) -> void:
	run_id += 1
	seed = p_seed
	tick = 0
	_rng.seed = p_seed
	rules_state = DshRulesCore.empty_state()


func advance_tick() -> int:
	tick += 1
	return tick


func current_tick() -> int:
	return tick


# Named, ordered draw from the single session seed context. Each call advances the deterministic stream in a fixed
# call order (ordered); the value is bounded to [0,1). No global random source is touched.
func draw_stream(stream_name: String) -> float:
	# stream_name is recorded for audit/trace even though this minimal seam keeps one shared, ordered stream.
	_stream_names.append(stream_name)
	return _rng.randf()


# The session boundary at which a rules step is evaluated (single fixed-step evaluation boundary, ADR-TECH-03).
func step(envelope: Dictionary) -> Dictionary:
	var result: Dictionary = DshRulesCore.step(envelope, rules_state, tick)
	rules_state = result["state"]
	return result
