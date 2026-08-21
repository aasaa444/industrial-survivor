# runtime/main.gd
# S4 minimal runtime scene controller, v0.2 (playable-slice polish, NEXT_IMPL_UNIT_PLAN_v0_2 candidate A)
# + v0.3 (contact slice, NEXT_IMPL_UNIT_PLAN_v0_3 unit B: C2/C3/C4/C5).
# + v0.4 (terminal/reset slice, NEXT_IMPL_UNIT_PLAN_v0_4 unit 4: T2/T3/T4/T5).
# Provides the smallest observable vertical slice:
#   player node (real keyboard movement), >=1 enemy node (fed as ordered_candidates to the pure rules core),
#   a visible auto-attack line pointing at the locked snapshot target, hit/kill feedback bound to
#   hit_results / kill_outcomes, and kill -> enemy removal -> clear (placeholder presentation, no art commitment).
#
# Seam / ownership (ADR-TECH-01/02):
#   - The scene talks to the rules core ONLY through the adapter (input->envelope, candidate_from_observation) and the
#     session (session.step). It never invents target selection / ordering / hit legality / contact legality itself.
#   - Feedback is applied strictly from DshAdapter.feedback_from_result so an empty shot never fabricates a lock or hit.
#
# R1 (this unit) — real input-driven movement (formalized):
#   WASD + arrow keys (held-key polling) -> ADAPTER.movement_from_input -> carried as intent into the domain envelope
#   (make_envelope) -> engine applies displacement to the player node. The rules core never reads movement values; the
#   engine re-observes enemy positions AFTER the player has moved, so the NEXT pre-fire refresh re-locks a snapshot
#   from the moved location (ADR-TECH-04: no live retargeting within a shot; the shot's snapshot is immutable).
#   The dead `_unhandled_input` / `_set_move_axis` scaffolding of v0.1 is removed: `_read_movement_input` is now the
#   single formal movement input path.
#   Self-test mode is kept ONLY as a restricted deterministic regression (scripted zero-move + scripted fire); it is
#   explicitly NOT player-playable input evidence (a [SELF-TEST] marker is printed at start; real keyboard input is
#   observed by Independent QA through the runtime, not through this headless regression).
#
# R2 (this unit) — read-model full-field presentation (READ_MODEL_MINIMAL_FIELDS_v0_1 S5; ADR-TECH-02; UX-03 S1-S3):
#   HUD minimal face       LIFE (three segments) / TIMER / B2 pre-fission structure placeholder.
#   attack_state           four states idle/resolving/resolved/no_target derived ONLY from rules trace fields.
#   kill_state             none -> killed, presented only while kill_outcomes is non-empty (settlement trace).
#   feedback binding       lock/hit/kill classes emitted only when their rule source is non-empty.
#   invalidation section   invalidation_event(id,tick) surfaced as "no hit this shot".
#   no-target quiet        no_target_branch => quiet form (no lock, no phantom hit); optional ONE-SHOT restrained
#                          non-color cue bound to the branch (exact presentation form NOT frozen).
#   hint field             explicitly NOT implemented (S5 §4.4 exclusion).
#
# C4 (this unit) — adapter/运行时 contact · damage · separation · re-arm (NEXT_IMPL_UNIT_PLAN_v0_3 unit B):
#   - Engine-side overlap detection (ADR-TECH-01 seam): AABB overlap between the player rect and each live enemy rect
#     is computed HERE (engine geometry), then translated by the adapter (ADAPTER.contact_observations) into the
#     domain contact input the rules core consumes.
#   - Contact input rides every domain envelope (empty included) so separation/re-arm is evaluated every step.
#   - Light separation is an ENGINE-side physical response: on a legal contact damage the player is nudged a small
#     distance away from the contacting victim so the pair separates and re-arm can occur.
#   - self-test gains a deterministic contact regression phase.
#
# C5 (this unit) — life deduction read-model presentation:
#   LIFE line reflects the REAL deductions: three segments, `[x]` = lost / `[o]` = alive, segments_lost read from
#   the rules trace (non-color, text/shape only; UX-13). A contact read-model line is bound to the contact events.
#
# T4 + T5 (this unit) — runtime terminal arbitration -> RESULT presentation -> automatic immediate retry
#   (NEXT_IMPL_UNIT_PLAN_v0_4 unit 4; ADR-TECH-05 §8; decision #5/#11/#12):
#   - The rules core arbitrates the terminal outcome (victory=control completion / defeat=life depletion, life-depletion-
#     same-frame-priority) from `terminal_input.timer_completed` + its own `segments_lost`. This runtime only sends the
#     session domain input (timer_completed when the candidate run_duration_ticks is reached) and OBSERVES the outcome.
#   - While a terminal result is active (rules result_locked), gameplay input is DISABLED (movement + attack are not
#     read; result/input lock, ADR-TECH-05 / Systems §4 step 5), and the RESULT is presented readable and non-color
#     (UX-13) in an HUD region that does not occlude player/danger/space (UX-09):
#         "RESULT: victory (clear)"          (decision #11, control completion)
#         "RESULT: defeat (light interruption)" (decision #12, non-punitive)
#   - After the short candidate result duration (terminal_result_duration), the runtime triggers the canonical
#     automatic reset (session.reset(): run identity advances, RNG reseeded, clean rules state — no out-of-run loss)
#     and re-spawns fresh placeholder enemies for the new run (immediate retry, no out-of-run loss; Systems §3 reset /
#     UX matrix Restart).
#   - RNG/session/run-id reset remains session-owned mechanical handling (ADR-TECH-01/05); this node only calls
#     session.reset() for the restart transaction. presentation consumes only the read-model / rules trace.
#   - All timing candidates (terminal_result_duration, run_duration_ticks) are candidate values, NOT frozen rule
#     constants (promotion_authority=User).
extends Node2D

const ADAPTER = preload("res://adapter/adapter.gd")
const SESSION = preload("res://rules/session.gd")

# Phase A observation fix: per-frame / per-shot high-frequency logs are gated behind DEBUG_VERBOSE (default false).
# Lifecycle / terminal / upgrade / contact / self-test logs stay always-on.
const DEBUG_VERBOSE := false
const DEBUG_HUD := false


# Debug-verbose log sink (keeps runtime output free of per-frame flood; set DEBUG_VERBOSE=true to re-enable).
func dbg_verbose(message: String) -> void:
	if DEBUG_VERBOSE:
		print(message)

@export var move_speed: float = 160.0
@export var attack_interval: float = 0.6
@export var contact_separate_dist: float = 26.0   # C4 candidate separation magnitude (NOT a frozen rule constant)
@export var contact_invuln_ticks: int = 30         # C4 candidate invulnerability ticks (NOT a frozen rule constant)
@export var terminal_result_duration: float = 1.2  # T4 candidate short-result duration before auto-restart (NOT frozen)
@export var run_duration_ticks: int = 4800         # T4 candidate opaque eight-minute run-bound in session ticks (NOT frozen;
												   # exact tick<->time mapping deferred to Systems; victory path also covered by
												   # the rules-core TERMINAL-victory fixture)

var session  # DshSession instance (untyped to avoid a global-class-cache dependency at headless scene load)
var locked_this_epoch: bool = false
var last_fire_time: float = 0.0
var spawn_grace_remaining: float = 1.0
var resolve_delay_remaining: float = 0.0
var _grace_phase_logged: bool = false

# QA debug-only observation seam: when true, pauses grace countdown so QA can capture runtime state.
var qa_hold_grace: bool = false

# Node handles built at runtime (placeholder presentation).
var player_visual: ColorRect
var _player_sprite_node: Sprite2D    # animation handle (bob + facing flip)
var _anim_time: float = 0.0
var attack_line: Line2D
var life_label: Label
var timer_label: Label
var b2_label: Label
var objective_label: Label
var state_label: Label
var kill_label: Label
var feedback_label: Label
var invalidation_label: Label
var no_target_label: Label
var contact_label: Label
var result_label: Label
var enemies: Array = []          # [{node, stable_id, hp, hit_flash}]
var next_stable_id: int = 1

# --- Slice B: first complete growth path (energy cores -> XP -> Rail Pierce) ---
const XP_TO_LEVEL_2: int = 5
const XP_TO_LEVEL_3: int = 10
const XP_TO_LEVEL_4: int = 15
const XP_PICKUP_RADIUS: float = 420.0
const XP_PICKUP_SPEED: float = 520.0
var player_level: int = 1
var player_xp: int = 0
var rail_pierce_active: bool = false
var scatter_fan_active: bool = false
var kinetic_pulse_active: bool = false
var energy_cores: Array = []  # [{node: Polygon2D, active: bool}]; bounded visual object pool
var xp_label: Label

# B5: Arena background
var arena_bg: Sprite2D

# Audio nodes
var _bgm_player: AudioStreamPlayer
var _attack_sfx_player: AudioStreamPlayer2D
var _enemy_death_sfx_player: AudioStreamPlayer
var _upgrade_sfx_player: AudioStreamPlayer
var _card_confirm_sfx_player: AudioStreamPlayer
var _jingle_player: AudioStreamPlayer

# Texture resources for player animation
var _player_idle_texture: Texture2D
var _player_attack_texture: Texture2D

# Read-model presentation state (presentation layer only; never a second rules authority).
var _quiet_episode_active: bool = false
var _last_presented_line: String = ""

# T4/T5 terminal-result runtime state (presentation + input-lock + auto-restart cadence).
var _in_result: bool = false
var _result_state: String = ""         # "" | "victory" | "defeat"  (runtime mirror of rules terminal_outcome)
var _result_remaining: float = 0.0     # countdown to automatic immediate retry (short result, then reset)

var self_test_mode: bool = false
var self_test_t: float = 0.0
var self_test_killed: Array = []
var self_test_fire_issued: bool = false
var self_test_done: bool = false
var self_test_contact_frames: int = 0
var self_test_contact_done: bool = false
var self_test_contact_enemy: Dictionary = {}
var self_test_terminal_depleted: bool = false   # T4: deterministic terminal regression flag (life depletion reached)
var self_test_drive_terminal: bool = false       # T4: while true, drive the terminal via direct session.step (skip engine combat)
var self_test_seen_result: bool = false          # T4: observed the result phase enter (for the post-restart pass check)

# B2 upgrade runtime state (presentation + selection + visual).
var _upgrade_pending: bool = false
var _upgrade_phase: String = ""           # "pierce" | "fan"
var _upgrade_cards: Array = []            # [{id, keyword, difference, effect, shortcut}]
var _upgrade_first_done: bool = false
var _upgrade_second_done: bool = false
var _upgrade_card_labels: Array = []      # [Label, Label, Label] card text labels (deprecated; kept for cleanup)
var _upgrade_prompt_label: Label          # prompt label
var _fan_left_line: Line2D                # fan left arc line
var _fan_right_line: Line2D               # fan right arc line

# B2 card UI state (UX spec v0.1: six-state card selection interface).
var _card_state: int = 0                  # 0=hidden, 1=transition_in, 2=inspection, 3=pressed, 4=acquired, 5=transition_out
var _card_focused_idx: int = 1            # 0/1/2 (default center)
var _card_selected_idx: int = -1          # -1 = none selected
var _card_input_guarded: bool = false     # true during transition/feedback phases
var _card_phase_timer: float = 0.0        # remaining time in current phase
var _card_input_mode: String = "keyboard" # "keyboard" or "mouse"
var _card_nodes: Array = []               # [{bg, container, keyword, diff, effect}]
var _card_hud: CanvasLayer = null         # card canvas layer reference

# B2 attack visual upgrade: glow layers + hit flash + kill tween state
var _attack_glow_line: Line2D             # glow layer behind attack line (wider, semi-transparent)
var _fan_left_glow_line: Line2D           # glow for left fan arc
var _fan_right_glow_line: Line2D          # glow for right fan arc
var _fan_mid_line: Line2D
var _fan_mid_glow_line: Line2D
var _attack_afterimage_line: Line2D
var _pierce_clear_line: Line2D
var _fan_clear_line: Line2D
var _fan_clear_left_line: Line2D
var _fan_clear_right_line: Line2D
var _upgrade_confirm_flash: ColorRect
var _attack_afterimage_tween: Tween
var _clear_effect_tween: Tween
var _upgrade_confirm_tween: Tween
var _hit_flash_remaining: float = 0.0     # seconds remaining for hit flash (white flash on hit)
var _hit_flash_particles: CPUParticles2D  # VFX-01: hit impact particle system
var _attack_base_color: Color = Color(0.0, 0.94, 1.0)
var _attack_glow_base_color: Color = Color(0.0, 0.51, 0.56, 0.28)
var _fan_base_color: Color = Color(0.0, 0.90, 1.0)
var _fan_glow_base_color: Color = Color(0.0, 0.51, 0.56, 0.20)

# VFX colors - core/transition/falloff hierarchy
const VFX_CORE_CYAN: Color = Color(0.0, 0.94, 1.0)      # #00f0ff - ultra cyan, hit flash core
const VFX_MID_CYAN: Color = Color(0.0, 0.90, 1.0)      # #00e5ff - mid cyan, attack arc body
const VFX_FALL_CYAN: Color = Color(0.0, 0.51, 0.55)     # #00838f - dark cyan, falloff/transition
const VFX_RUST_PARTICLE: Color = Color(0.72, 0.35, 0.18) # #b85c2e - bright rust
const VFX_RUST_DARK: Color = Color(0.55, 0.22, 0.10)    # #8b3a1a - deep rust


func _ready() -> void:
	session = SESSION.new(2026)
	_self_test_mode_detect()

	# Load texture resources for player animation
	_player_idle_texture = preload("res://assets/player_idle_48.png")
	_player_attack_texture = preload("res://assets/player_attack_48.png")

	# Initialize audio players
	# BGM: dedicated Music bus with a low-pass filter — the raw industrial ambience is harsh at
	# full bandwidth (user-reported ear fatigue 2026-08-20); keep ambience, cut piercing highs.
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.stream = preload("res://assets/audio/bg_industrial_ambient.wav")
	_bgm_player.volume_db = -14.0
	var _music_bus_idx: int = AudioServer.bus_count
	AudioServer.add_bus(_music_bus_idx)
	AudioServer.set_bus_name(_music_bus_idx, "Music")
	var _lp: AudioEffectLowPassFilter = AudioEffectLowPassFilter.new()
	_lp.cutoff_hz = 2400.0
	_lp.resonance = 0.4
	AudioServer.add_bus_effect(_music_bus_idx, _lp)
	_bgm_player.bus = "Music"
	add_child(_bgm_player)
	_bgm_player.playing = true

	_attack_sfx_player = AudioStreamPlayer2D.new()
	_attack_sfx_player.stream = preload("res://assets/audio/attack_normal.wav")
	# Attack SFX at background level (-24dB) with the verified soft air-swish tone:
	# audible feedback without reading as a drum loop at ~0.7 shots/sec.
	_attack_sfx_player.volume_db = -24.0
	add_child(_attack_sfx_player)

	_enemy_death_sfx_player = AudioStreamPlayer.new()
	_enemy_death_sfx_player.stream = preload("res://assets/audio/enemy_death.wav")
	# Kill SFX at -21dB: subordinate to upgrade sounds, above the near-inaudible attack snap.
	_enemy_death_sfx_player.volume_db = -21.0
	add_child(_enemy_death_sfx_player)

	_upgrade_sfx_player = AudioStreamPlayer.new()
	_upgrade_sfx_player.stream = preload("res://assets/audio/upgrade_open.wav")
	_upgrade_sfx_player.volume_db = -4.0
	add_child(_upgrade_sfx_player)

	_card_confirm_sfx_player = AudioStreamPlayer.new()
	_card_confirm_sfx_player.stream = preload("res://assets/audio/card_confirm.wav")
	_card_confirm_sfx_player.volume_db = -4.0
	add_child(_card_confirm_sfx_player)

	# Win/lose jingle player (reward-audio layer 2026-08-21).
	_jingle_player = AudioStreamPlayer.new()
	_jingle_player.volume_db = -8.0
	add_child(_jingle_player)

	_build_visuals(self_test_mode)
	spawn_grace_remaining = 1.0
	resolve_delay_remaining = 0.0
	_grace_phase_logged = false
	if self_test_mode:
		_self_test_add_enemies()
		# Restricted deterministic regression marker: this is NOT player-playable input evidence.
		print("[SELF-TEST] restricted deterministic regression (scripted zero-move + scripted fire; NOT player-playable input evidence)")

# VFX-01: Initialize hit impact particle system
	_hit_flash_particles = CPUParticles2D.new()
	_hit_flash_particles.name = "HitImpactParticles"
	# Godot 4.7.1: CPUParticles2D emits in all directions by default
	_hit_flash_particles.lifetime = 0.30  # 300ms total, fades out
	_hit_flash_particles.amount = 5   # keep impact readable without a particle burst spike
	_hit_flash_particles.one_shot = true
	_hit_flash_particles.gravity = Vector2(0, 0)
	_hit_flash_particles.emitting = false
	_hit_flash_particles.visible = false
	# Particle scale: 3.0 (uniform scaling)
	_hit_flash_particles.scale_amount_min = 3.0
	_hit_flash_particles.scale_amount_max = 4.0
	# Particle color: rust colors
	_hit_flash_particles.color = VFX_RUST_PARTICLE
	# Particle velocity: 20-28 px outward from center
	_hit_flash_particles.initial_velocity_min = 16.0
	_hit_flash_particles.initial_velocity_max = 28.0
	# Spread: 360 degrees (emission in all directions)
	_hit_flash_particles.spread = 180.0  # 180 degrees = full 360 spread
	_hit_flash_particles.angle_min = 0.0
	_hit_flash_particles.angle_max = 360.0
	world_root.add_child(_hit_flash_particles)


func _self_test_mode_detect() -> void:
	# Scan both user args and the full engine arg list: some Godot 4 invocations deliver trailing flags to one or the other.
	for a in OS.get_cmdline_user_args():
		if a == "--self-test":
			self_test_mode = true
	for a in OS.get_cmdline_args():
		if a == "--self-test":
			self_test_mode = true


# Fixed world layer: the root Main node IS the player and moves with input, so all
# world-space content (arena, enemies, world VFX) must live under world_root, which is
# counter-offset every frame to stay stationary in world space.
var world_root: Node2D

# --- Iteration 2: fixed-step tick + chase AI + wave pressure ---
const TICK_HZ: float = 60.0                     # fixed session tick rate; run_duration 4800 ticks = 80s regardless of FPS
var _tick_accumulator: float = 0.0
const WAVE_INTERVAL: float = 3.5                # seconds between waves (after grace)
const MAX_LIVE_ENEMIES: int = 22                # pressure/readability/perf cap
const WALKER_SPEED: float = 62.0                # fast, fragile
const BRUTE_SPEED: float = 34.0                 # slow, tanky (hp 3)
const ATTACK_RANGE: float = 280.0               # engine observation boundary: enemies beyond this are not targetable
const ENEMY_TINT: Color = Color(0.9, 0.35, 0.2)
const WORLD_SIZE: Vector2 = Vector2(2304.0, 1296.0)   # 2x2 viewport scrolling arena (survivors-style)
const SPAWN_RING_RADIUS: float = 760.0               # enemies spawn just outside the camera view around the player
var _wave_timer: float = 0.0
var _wave_index: int = 0
var _perf_probe_timer: float = 0.0
var _sfx_muted: bool = false   # M-key toggle: player-owned SFX escape hatch
var _kill_streak: int = 0
var _last_kill_time: float = -10.0
var _last_kill_sfx_time: float = -10.0

const SFX_BASE_VOLUMES: Dictionary = {"attack": -24.0, "kill": -21.0, "upgrade": -4.0, "card": -4.0}


func _toggle_sfx_mute() -> void:
	_sfx_muted = not _sfx_muted
	if _attack_sfx_player:
		_attack_sfx_player.volume_db = -60.0 if _sfx_muted else SFX_BASE_VOLUMES["attack"]
	if _enemy_death_sfx_player:
		_enemy_death_sfx_player.volume_db = -60.0 if _sfx_muted else SFX_BASE_VOLUMES["kill"]
	if _upgrade_sfx_player:
		_upgrade_sfx_player.volume_db = -60.0 if _sfx_muted else SFX_BASE_VOLUMES["upgrade"]
	if _card_confirm_sfx_player:
		_card_confirm_sfx_player.volume_db = -60.0 if _sfx_muted else SFX_BASE_VOLUMES["card"]
	if _jingle_player:
		_jingle_player.volume_db = -60.0 if _sfx_muted else -8.0
	print("[AUDIO] SFX %s (M toggles)" % ("muted" if _sfx_muted else "unmuted"))


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_M:
		_toggle_sfx_mute()


func _new_enemy_node(pos: Vector2, hp: int, color: Color, enemy_type: String = "walker") -> Node2D:
	var e := Node2D.new(); e.name = "Enemy_%d" % next_stable_id; e.add_to_group("enemies"); e.add_to_group("enemy_actor")
	e.position = pos
	# Use sprite instead of color rect
	var sprite := Sprite2D.new()
	sprite.name = "EnemySprite"
	if enemy_type == "brute":
		sprite.texture = preload("res://assets/enemy_brute_64.png")
	else:
		sprite.texture = preload("res://assets/enemy_walker_48.png")
	# Pre-scaled textures (48/64px) shown at native size — the raw 1024px textures
	# minified to ~46px collapsed fps to ~20 with 20+ enemies (2026-08-20 perf bug).
	var sprite_scale := 1.3 if enemy_type == "brute" else 1.0
	sprite.scale = Vector2(sprite_scale, sprite_scale)
	# Apply the enemy tint so the raw texture reads against the dark arena (was unused, enemies were grey-on-grey)
	sprite.modulate = color
	e.add_child(sprite)
	world_root.add_child(e)
	enemies.append({"node": e, "stable_id": next_stable_id, "hp": hp, "hit_flash": 0.0, "visual": sprite,
		"type": enemy_type, "speed": BRUTE_SPEED if enemy_type == "brute" else WALKER_SPEED})
	next_stable_id += 1
	return e


# --- Slice B energy core pool: bounded runtime visuals, reused after pickup ---
func _spawn_energy_core(world_pos: Vector2) -> void:
	var core: Dictionary = {}
	for candidate in energy_cores:
		if not bool(candidate.get("active", false)):
			core = candidate
			break
	if core.is_empty():
		var diamond := Polygon2D.new()
		diamond.name = "EnergyCore"
		diamond.polygon = PackedVector2Array([Vector2(0, -7), Vector2(6, 0), Vector2(0, 7), Vector2(-6, 0)])
		diamond.color = Color(0.20, 0.92, 1.0, 0.95)
		world_root.add_child(diamond)
		core = {"node": diamond, "active": false}
		energy_cores.append(core)
	var node: Polygon2D = core.node
	node.position = world_pos
	node.visible = true
	core.active = true
	print("[GROWTH] energy_drop at=(%.0f,%.0f) active_cores=%d" % [world_pos.x, world_pos.y, energy_cores.size()])


func _update_energy_cores(delta: float) -> void:
	for core in energy_cores:
		if not bool(core.get("active", false)):
			continue
		var node: Polygon2D = core.node
		if not is_instance_valid(node):
			core.active = false
			continue
		var to_player: Vector2 = position - node.position
		if to_player.length() <= XP_PICKUP_RADIUS:
			node.position += to_player.normalized() * XP_PICKUP_SPEED * delta
			if node.position.distance_to(position) <= 12.0:
				node.visible = false
				core.active = false
				player_xp += 1
				print("[GROWTH] energy_collected xp=%d/%d" % [player_xp, XP_TO_LEVEL_2])
				if player_level == 1 and player_xp >= XP_TO_LEVEL_2 and not _upgrade_first_done and not _upgrade_pending:
					player_level = 2
					_start_upgrade("pierce")
				elif player_level == 2 and player_xp >= XP_TO_LEVEL_3 and not _upgrade_second_done and not _upgrade_pending:
					player_level = 3
					_start_upgrade("fan")
				elif player_level == 3 and player_xp >= XP_TO_LEVEL_4 and not kinetic_pulse_active and not _upgrade_pending:
					player_level = 4
					_start_upgrade("pulse")


func _update_growth_hud() -> void:
	if b2_label:
		var build_name: String = "基础模块"
		if kinetic_pulse_active: build_name = "动能冲击"
		elif scatter_fan_active: build_name = "散射扇面"
		elif rail_pierce_active: build_name = "轨道穿透"
		b2_label.text = "等级 %d  %s" % [player_level, build_name]
	if xp_label:
		var next_threshold: int = XP_TO_LEVEL_2 if player_level <= 1 else (XP_TO_LEVEL_3 if player_level == 2 else (XP_TO_LEVEL_4 if player_level == 3 else 0))
		if next_threshold > 0:
			var filled: int = min(player_xp, next_threshold)
			xp_label.text = "能量  [" + "#".repeat(filled) + "-".repeat(max(0, next_threshold - filled)) + "]  %d/%d" % [filled, next_threshold]
		else:
			xp_label.text = "能量  已满  %d" % player_xp


func _build_visuals(for_self_test: bool) -> void:
	# World layer first: everything world-space is parented here, not to the moving player root.
	world_root = Node2D.new()
	world_root.name = "WorldRoot"
	add_child(world_root)
	# B5: Arena background - full viewport, behind all game elements
	arena_bg = Sprite2D.new()
	arena_bg.name = "ArenaBackground"
	# Load the arena background texture via the imported resource
	var bg_texture: Texture2D = preload("res://assets/arena_bg.png")
	arena_bg.texture = bg_texture
	# Cover the full scrolling world (not just the viewport) — the camera pans across it.
	var cover_scale: float = float(max(WORLD_SIZE.x / bg_texture.get_width(), WORLD_SIZE.y / bg_texture.get_height()))
	arena_bg.scale = Vector2(cover_scale, cover_scale)
	arena_bg.position = WORLD_SIZE * 0.5
	world_root.add_child(arena_bg)

	# Survivors-style camera: child of Main (= the player) so it follows automatically,
	# clamped to the world rect, with light smoothing.
	var cam := Camera2D.new()
	cam.name = "PlayerCamera"
	cam.position = Vector2.ZERO
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = int(WORLD_SIZE.x)
	cam.limit_bottom = int(WORLD_SIZE.y)
	cam.position_smoothing_enabled = false   # direct-control feel: camera locked to player (smoothing lag read as unresponsive input)
	cam.position_smoothing_speed = 8.0
	add_child(cam)
	cam.make_current()

	# Player setup - Sprite2D with attack texture
	var player_sprite := Sprite2D.new()
	player_sprite.name = "PlayerSprite"
	player_sprite.texture = _player_idle_texture
	player_sprite.position = Vector2.ZERO
	# Scale to ~24x24 px in-game (1024 -> 24 = 0.0234)
	player_sprite.scale = Vector2.ONE   # pre-scaled 48px texture; keep native display size
	add_child(player_sprite)
	_player_sprite_node = player_sprite

	player_visual = ColorRect.new(); player_visual.name = "Player"; player_visual.add_to_group("player"); player_visual.add_to_group("player_actor")
	player_visual.color = Color(0.2, 0.7, 1.0)   # cyan signal (restrained, non-color-distinguishable by shape too)
	player_visual.size = Vector2(24, 24)
	player_visual.position = -player_visual.size / 2.0
	player_visual.visible = false  # Hidden, replaced by sprite
	add_child(player_visual)
	position = WORLD_SIZE * 0.5   # start centered in the scrolling arena

	# Attack line: thin bright core + wide tapered glow for penetration visual weight.
	# Glow layer renders behind the core line.
	_attack_glow_line = Line2D.new()
	_attack_glow_line.width = 10.0
	_attack_glow_line.default_color = _attack_glow_base_color
	_attack_glow_line.visible = false
	var glow_curve := Curve.new()
	glow_curve.add_point(Vector2(0.0, 0.15))
	glow_curve.add_point(Vector2(0.4, 0.5))
	glow_curve.add_point(Vector2(1.0, 1.0))
	_attack_glow_line.width_curve = glow_curve
	add_child(_attack_glow_line)

	attack_line = Line2D.new()
	attack_line.width = 3.0
	attack_line.default_color = _attack_base_color
	attack_line.visible = false
	# Width taper: root thin -> tip full width (penetration directionality)
	var core_curve := Curve.new()
	core_curve.add_point(Vector2(0.0, 0.4))
	core_curve.add_point(Vector2(0.5, 0.75))
	core_curve.add_point(Vector2(1.0, 1.0))
	attack_line.width_curve = core_curve
	add_child(attack_line)

	var hud := CanvasLayer.new()
	hud.layer = 10
	add_child(hud)

	# --- R2 HUD minimal face (S5 §4.1 life/timer/b2) + read-model presentation lines. ---
	life_label = Label.new()
	life_label.position = Vector2(16, 12)
	life_label.text = "生命  [o][o][o]"
	hud.add_child(life_label)

	timer_label = Label.new()
	timer_label.position = Vector2(16, 30)
	timer_label.text = "时间  00:00"
	hud.add_child(timer_label)

	b2_label = Label.new()
	b2_label.position = Vector2(16, 48)
	b2_label.text = "等级 1"
	hud.add_child(b2_label)

	xp_label = Label.new()
	xp_label.position = Vector2(16, 66)
	xp_label.text = "能量  [-----]  0/5"
	xp_label.add_theme_color_override("font_color", Color(0.35, 0.92, 1.0))
	hud.add_child(xp_label)

	objective_label = Label.new()
	objective_label.position = Vector2(16, 84)
	objective_label.text = "目标  WASD / 方向键移动，自动攻击"
	objective_label.add_theme_color_override("font_color", Color(0.86, 0.86, 0.82))
	hud.add_child(objective_label)

	state_label = Label.new()
	state_label.position = Vector2(16, 84)
	state_label.text = "attack: idle"
	state_label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	state_label.visible = DEBUG_HUD
	hud.add_child(state_label)

	kill_label = Label.new()
	kill_label.position = Vector2(16, 102)
	kill_label.text = "kill: none"
	kill_label.visible = DEBUG_HUD
	hud.add_child(kill_label)

	feedback_label = Label.new()
	feedback_label.position = Vector2(16, 120)
	feedback_label.text = "feedback: - (quiet)"
	feedback_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	feedback_label.visible = DEBUG_HUD
	hud.add_child(feedback_label)

	invalidation_label = Label.new()
	invalidation_label.position = Vector2(16, 138)
	invalidation_label.text = ""
	invalidation_label.add_theme_color_override("font_color", Color(0.75, 0.75, 0.75))
	invalidation_label.visible = DEBUG_HUD
	hud.add_child(invalidation_label)

	no_target_label = Label.new()
	no_target_label.position = Vector2(16, 156)
	no_target_label.text = ""
	no_target_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	no_target_label.visible = DEBUG_HUD
	hud.add_child(no_target_label)

	# C5 contact read-model line (bound to the rules contact events; non-color text).
	contact_label = Label.new()
	contact_label.position = Vector2(16, 174)
	contact_label.text = "contact: none"
	contact_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	contact_label.visible = DEBUG_HUD
	hud.add_child(contact_label)

	# T5 RESULT presentation line (readable, non-color text UX-13; HUD region, not over player/danger/space UX-09).
	result_label = Label.new()
	result_label.position = Vector2(16, 192)
	result_label.text = ""
	result_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	result_label.visible = DEBUG_HUD
	hud.add_child(result_label)

	# B2 upgrade card interface (UX spec v0.1: horizontal cards on separate canvas layer).
	_card_hud = CanvasLayer.new()
	_card_hud.layer = 10
	add_child(_card_hud)

	# Semi-transparent backdrop (spans full viewport, blocks mouse passthrough during card selection).
	var backdrop := ColorRect.new()
	backdrop.name = "CardBackdrop"
	backdrop.color = Color(0.0, 0.0, 0.0, 0.0)
	backdrop.size = Vector2(640, 360)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backdrop.visible = false
	_card_hud.add_child(backdrop)

	_upgrade_prompt_label = Label.new()
	_upgrade_prompt_label.position = Vector2(0, 332)
	_upgrade_prompt_label.size = Vector2(640, 20)
	_upgrade_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_upgrade_prompt_label.text = ""
	_upgrade_prompt_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.4))
	_upgrade_prompt_label.add_theme_font_size_override("font_size", 13)
	_upgrade_prompt_label.visible = false
	_card_hud.add_child(_upgrade_prompt_label)

	# Three card containers: ColorRect background + VBoxContainer with three Label children.
	var card_centers_x := [160.0, 320.0, 480.0]
	var card_width := 160.0
	var card_height := 96.0
	var card_center_y := 270.0

	for i in range(3):
		var card_data := _build_card_widget(i, card_centers_x[i], card_center_y, card_width, card_height)
		_card_hud.add_child(card_data.bg)
		_card_nodes.append(card_data)

	# Keep old label references for backward compat (hidden, unused but not breaking).
	for i in range(3):
		var cl := Label.new()
		cl.position = Vector2(48, 222 + i * 22)
		cl.text = ""
		cl.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
		cl.visible = false
		_card_hud.add_child(cl)
		_upgrade_card_labels.append(cl)

	# B2 fan arc glow lines (behind the core fan lines, wider + semi-transparent).
	_fan_left_glow_line = Line2D.new()
	_fan_left_glow_line.width = 6.0
	_fan_left_glow_line.default_color = _fan_glow_base_color
	_fan_left_glow_line.visible = false
	add_child(_fan_left_glow_line)

	_fan_right_glow_line = Line2D.new()
	_fan_right_glow_line.width = 6.0
	_fan_right_glow_line.default_color = _fan_glow_base_color
	_fan_right_glow_line.visible = false
	add_child(_fan_right_glow_line)

	# B2 fan arc lines (hidden by default; shown after fan upgrade).
	_fan_left_line = Line2D.new()
	_fan_left_line.width = 2.0
	_fan_left_line.default_color = _fan_base_color
	_fan_left_line.visible = false
	add_child(_fan_left_line)

	_fan_right_line = Line2D.new()
	_fan_right_line.width = 2.0
	_fan_right_line.default_color = _fan_base_color
	_fan_right_line.visible = false
	add_child(_fan_right_line)

	_fan_mid_line = Line2D.new()
	_fan_mid_line.width = 2.0
	_fan_mid_line.default_color = _fan_base_color
	_fan_mid_line.visible = false
	add_child(_fan_mid_line)
	_fan_mid_glow_line = Line2D.new()
	_fan_mid_glow_line.width = 6.0
	_fan_mid_glow_line.default_color = _fan_glow_base_color
	_fan_mid_glow_line.visible = false
	add_child(_fan_mid_glow_line)
	_attack_afterimage_line = Line2D.new()
	_attack_afterimage_line.width = 4.0
	_attack_afterimage_line.default_color = Color(0.30, 0.82, 0.88, 0.32)
	_attack_afterimage_line.visible = false
	add_child(_attack_afterimage_line)
	_pierce_clear_line = Line2D.new()
	_pierce_clear_line.width = 2.0
	_pierce_clear_line.default_color = Color(0.0, 0.90, 1.0, 0.0)
	_pierce_clear_line.visible = false
	world_root.add_child(_pierce_clear_line)
	_fan_clear_line = Line2D.new()
	_fan_clear_line.width = 2.0
	_fan_clear_line.default_color = Color(0.0, 0.90, 1.0, 0.0)
	_fan_clear_line.visible = false
	world_root.add_child(_fan_clear_line)
	_fan_clear_left_line = Line2D.new()
	_fan_clear_left_line.width = 2.0
	_fan_clear_left_line.default_color = Color(0.0, 0.90, 1.0, 0.0)
	_fan_clear_left_line.visible = false
	world_root.add_child(_fan_clear_left_line)
	_fan_clear_right_line = Line2D.new()
	_fan_clear_right_line.width = 2.0
	_fan_clear_right_line.default_color = Color(0.0, 0.90, 1.0, 0.0)
	_fan_clear_right_line.visible = false
	world_root.add_child(_fan_clear_right_line)
	_upgrade_confirm_flash = ColorRect.new()
	_upgrade_confirm_flash.size = Vector2(174, 110)
	_upgrade_confirm_flash.position = Vector2(233, 215)
	_upgrade_confirm_flash.color = Color(0.0, 0.85, 1.0, 0.0)
	_upgrade_confirm_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_upgrade_confirm_flash.visible = false
	_card_hud.add_child(_upgrade_confirm_flash)

	if not for_self_test:
		# Iteration 2: no static targets — waves spawn from the arena edges shortly after grace (see _update_waves).
		_wave_timer = WAVE_INTERVAL - 2.0   # first wave ~2s after grace ends
		_wave_index = 0


func _self_test_add_enemies() -> void:
	# Deterministic scene layout for the headless self-test.
	# Enemy 1 is placed OUTSIDE the player's AABB overlap range (dx=40 > 12+13) so the kill/clear phase is contact-free;
	# the dedicated contact phase adds a separate overlapping enemy to assert exactly one contact damage.
	_new_enemy_node(Vector2(280, 360), 1, Color(0.9, 0.35, 0.2))
	_new_enemy_node(Vector2(560, 180), 1, Color(0.9, 0.35, 0.2))
	# Distance to player start (320,360): enemy id1 at (280,360) dist 40 (no AABB overlap); enemy id2 at (560,180) dist ~290.
	# Nearest-threat -> enemy id1 locks first.


# --- R1 formalized real input path: WASD + arrows, held-key polling. ---
# Continuous movement reading (works whether or not key-release events are received). This is the SINGLE movement input
# path; v0.1's `_unhandled_input`/`_set_move_axis` dead scaffolding is removed.
func _read_movement_input() -> Dictionary:
	var axis := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# ui_down is represented by axis.y > 0.01
	# ui_left is represented by axis.x < -0.01
	# ui_right is represented by axis.x > 0.01
	return ADAPTER.movement_from_input({"up": axis.y < -0.01, "down": axis.y > 0.01, "left": axis.x < -0.01, "right": axis.x > 0.01})


# --- C4 engine-side overlap detection (ADR-TECH-01 seam) ------------------------
# AABB overlap between the player rect (24x24) and each live enemy rect (26x26). This is ENGINE geometry/movement
# ownership; the adapter translates it into domain contact observations and the rules core judges legality.
func _overlapping_enemy_ids(on_screen: Array) -> Array:
	var half_player := Vector2(12, 12)
	var overlaps: Array = []
	for e in on_screen:
		var half_enemy := Vector2(13, 13)
		var dx: float = absf(e.node.position.x - position.x)
		var dy: float = absf(e.node.position.y - position.y)
		overlaps.append({
			"id": e.stable_id,
			"overlapping": (dx < half_player.x + half_enemy.x) and (dy < half_player.y + half_enemy.y),
		})
	return ADAPTER.contact_observations(overlaps)


# --- C4 engine-side light separation (physical response; adapter/engine owned) ---
# On a legal contact damage from victim v, nudge the player a small distance away from v along the normalized
# separation direction so the pair separates and re-arm can occur. Candidate magnitude, NOT a frozen rule constant.
func _apply_light_separation(victim_id: int, on_screen: Array) -> void:
	var victim_pos := Vector2.ZERO
	var found := false
	for e in on_screen:
		if e.stable_id == victim_id and is_instance_valid(e.node):
			victim_pos = e.node.position
			found = true
			break
	if not found:
		return
	var away := position - victim_pos
	if away.length_squared() < 0.0001:
		away = Vector2(0, -1)   # degenerate identical position -> deterministic upward nudge
	away = away.normalized()
	position += away * contact_separate_dist
	position = position.clamp(Vector2(14.0, 14.0), WORLD_SIZE - Vector2(14.0, 14.0))
	dbg_verbose("[CONTACT-SEPARATE] victim_id=%d player=(%.0f,%.0f) (light separation; candidate mag %.0f)" % [victim_id, position.x, position.y, contact_separate_dist])


# --- T4: terminal result phase handling ---
# While a terminal result is active (rules result_locked), gameplay input is DISABLED (result/input lock), the RESULT
# is presented (readable, non-color), and after the short candidate result duration the runtime triggers the canonical
# automatic immediate reset (session.reset(): run identity advances, RNG reseeded, clean rules state) + fresh enemies.
func _handle_result_phase(delta: float) -> void:
	if result_label:
		result_label.visible = true
		if _result_state == "defeat":
			result_label.text = "RESULT: 失败 —— 生命耗尽（任意键立即重试）"
		elif _result_state == "victory":
			result_label.text = "RESULT: 胜利 —— 成功存活！"
		else:
			result_label.text = "RESULT: ..."
	# Result/input lock: suppress gameplay presentation detail during the terminal result (presentation reads only the
	# locked result — no re-arbitration, no new combat state), then count down to the automatic immediate retry.
	_result_remaining -= delta
	if _result_remaining <= 0.0:
		_auto_restart()


# --- T4: canonical automatic immediate reset (immediate retry, no out-of-run loss) ---
# session.reset() is the session-owned canonical clean-restart transaction (ADR-TECH-01/05): run identity advances,
# the single RNG is reseeded, and the rules state is rebuilt fresh (segments_lost=0, terminal cleared, snapshots/results
# cleared) — so a new run carries NO cross-run loss. This node re-spawns fresh placeholder enemies for the new run.
func _auto_restart() -> void:
	session.reset()
	for e in enemies:
		if is_instance_valid(e.node):
			e.node.queue_free()
	enemies.clear()
	next_stable_id = 1
	# Iteration 2: waves replace static placeholder enemies on restart; first wave ~2s after grace.
	_wave_timer = WAVE_INTERVAL - 2.0
	_wave_index = 0
	_tick_accumulator = 0.0
	player_level = 1
	player_xp = 0
	rail_pierce_active = false
	for core in energy_cores:
		if is_instance_valid(core.node): core.node.visible = false
		core.active = false
	position = WORLD_SIZE * 0.5   # start centered in the scrolling arena
	attack_line.visible = false
	locked_this_epoch = false
	last_fire_time = 0.0
	spawn_grace_remaining = 1.0
	resolve_delay_remaining = 0.0
	_quiet_episode_active = false
	_in_result = false
	_result_state = ""
	_result_remaining = 0.0
	if result_label:
		result_label.text = ""
		result_label.visible = false
	# Reset B2 upgrade runtime state.
	_upgrade_pending = false
	_upgrade_phase = ""
	_upgrade_cards = []
	_upgrade_first_done = false
	_upgrade_second_done = false
	attack_line.width = 3.0
	attack_line.default_color = _attack_base_color
	_fan_left_line.visible = false
	_fan_right_line.visible = false
	# VFX visibility reset omissions fixed 2026-08-20 (cross-run visual residue): mid fan, afterimage, pierce clear.
	if _fan_mid_line:
		_fan_mid_line.visible = false
	if _fan_mid_glow_line:
		_fan_mid_glow_line.visible = false
	if _attack_afterimage_line:
		_attack_afterimage_line.visible = false
	if _pierce_clear_line:
		_pierce_clear_line.visible = false
	# Reset glow layers.
	if _attack_glow_line:
		_attack_glow_line.visible = false
		_attack_glow_line.default_color = _attack_glow_base_color
	if _fan_left_glow_line:
		_fan_left_glow_line.visible = false
	if _fan_right_glow_line:
		_fan_right_glow_line.visible = false
	if _fan_clear_line:
		_fan_clear_line.visible = false
	if _fan_clear_left_line:
		_fan_clear_left_line.visible = false
	if _fan_clear_right_line:
		_fan_clear_right_line.visible = false
	_hit_flash_remaining = 0.0
	_upgrade_prompt_label.visible = false
	for c in _card_nodes:
		if is_instance_valid(c.bg):
			c.bg.visible = false
	for cl in _upgrade_card_labels:
		cl.visible = false
	_card_state = 0
	_card_input_guarded = false
	_card_selected_idx = -1
	_card_focused_idx = 1
	_card_hovered_idx = -1
	# Print the deterministic no-cross-run-loss evidence line (segments_lost now 0 in the fresh rules state).
	print("[TERMINAL-AUTO-RESTART] canonical reset -> new run; segments_lost=%d (no cross-run loss)" % int(session.rules_state.get("segments_lost", 0)))


# --- T4: enter the terminal result phase when the rules core has arbitrated an outcome ---
func _enter_result_if_needed() -> void:
	if _in_result:
		return
	var outcome: String = String(session.rules_state.get("terminal_outcome", ""))
	if outcome != "":
		_in_result = true
		_result_state = outcome
		_result_remaining = terminal_result_duration if terminal_result_duration > 0.0 else 0.15
		# Win/lose jingle (2026-08-21 reward-audio layer): the outcome moment gets the
		# brightest, most satisfying sound in the game.
		if _jingle_player:
			_jingle_player.stream = preload("res://assets/audio/defeat.wav") if outcome == "defeat" else preload("res://assets/audio/victory.wav")
			_jingle_player.play()
		if _result_state == "defeat":
			print("[TERMINAL] outcome=defeat (life depletion; short light-interruption result)")
		elif _result_state == "victory":
			print("[TERMINAL] outcome=victory (control completion)")


# --- B2 card widget builder (UX spec v0.1: TextureRect + StyleBoxFlat + VBox + Labels) ---
func _build_card_widget(idx: int, cx: float, cy: float, w: float, h: float) -> Dictionary:
	var bg := TextureRect.new()
	bg.name = "CardBg_%d" % idx
	bg.size = Vector2(w, h)
	bg.position = Vector2(cx - w / 2.0, cy - h / 2.0)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	bg.mouse_default_cursor_shape = Control.CURSOR_ARROW
	bg.visible = false
	# Load card texture based on index (pierce = 0,1,2; fan = 3,4,5 will be set later)
	if idx < 3:
		bg.texture = preload("res://assets/card_pierce_raw.png")
	else:
		bg.texture = preload("res://assets/card_fan_split_raw.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE

	# StyleBoxFlat for rounded corners and border control.
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.10, 0.85)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.30, 0.30, 0.35)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	bg.add_theme_stylebox_override("panel", style)

	# Inner VBoxContainer for text layout.
	var vbox := VBoxContainer.new()
	vbox.name = "CardVBox_%d" % idx
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 2)
	bg.add_child(vbox)

	# Tier 1: Keyword (18px, bold).
	var kw := Label.new()
	kw.name = "Keyword_%d" % idx
	kw.add_theme_font_size_override("font_size", 18)
	kw.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	kw.text = ""
	vbox.add_child(kw)

	# Tier 2: Difference dimension (14px, regular).
	var diff := Label.new()
	diff.name = "Diff_%d" % idx
	diff.add_theme_font_size_override("font_size", 14)
	diff.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	diff.text = ""
	vbox.add_child(diff)

	# Tier 3: Effect description (12px, muted).
	var eff := Label.new()
	eff.name = "Effect_%d" % idx
	eff.add_theme_font_size_override("font_size", 12)
	eff.add_theme_color_override("font_color", Color(0.55, 0.55, 0.55))
	eff.text = ""
	vbox.add_child(eff)

	# Connect mouse signals (using callables with bind).
	bg.mouse_entered.connect(_on_card_mouse_entered.bind(idx))
	bg.mouse_exited.connect(_on_card_mouse_exited.bind(idx))
	bg.gui_input.connect(_on_card_gui_input.bind(idx))

	return {"bg": bg, "container": vbox, "keyword": kw, "diff": diff, "effect": eff}


# --- B2 card visual state management ---
func _update_card_visuals() -> void:
	if _card_state == 0:
		return
	for i in range(3):
		var card: Dictionary = _card_nodes[i]
		var bg: TextureRect = card.bg
		if not is_instance_valid(bg):
			continue
		var kw: Label = card.keyword
		var diff: Label = card.diff
		var eff: Label = card.effect
		match _card_state:
			1:  # transition_in — handled by tween; use default.
				_apply_card_style(bg, kw, diff, eff, i, "default")
			2:  # inspection
				if i == _card_selected_idx and _card_selected_idx != -1:
					_apply_card_style(bg, kw, diff, eff, i, "pressed")
				elif _card_input_mode == "keyboard" and i == _card_focused_idx:
					_apply_card_style(bg, kw, diff, eff, i, "focus")
				elif _card_input_mode == "mouse" and i == _card_hovered_idx and _card_hovered_idx != -1:
					_apply_card_style(bg, kw, diff, eff, i, "hover")
				elif _card_selected_idx != -1:
					_apply_card_style(bg, kw, diff, eff, i, "dimmed")
				else:
					_apply_card_style(bg, kw, diff, eff, i, "default")
			3:  # pressed
				if i == _card_selected_idx:
					_apply_card_style(bg, kw, diff, eff, i, "pressed")
				else:
					_apply_card_style(bg, kw, diff, eff, i, "dimmed")
			4:  # acquired
				if i == _card_selected_idx:
					_apply_card_style(bg, kw, diff, eff, i, "selected")
				else:
					_apply_card_style(bg, kw, diff, eff, i, "dimmed")
			5:  # transition_out — handled by tween.
				pass


var _card_hovered_idx: int = -1

func _apply_card_style(bg: TextureRect, kw: Label, diff: Label, eff: Label, idx: int, state_name: String) -> void:
	var style: StyleBoxFlat = bg.get_theme_stylebox("panel", "ColorRect")
	if style == null:
		style = StyleBoxFlat.new()
		bg.add_theme_stylebox_override("panel", style)

	match state_name:
		"default":
			style.bg_color = Color(0.08, 0.08, 0.10, 0.85)
			style.border_color = Color(0.30, 0.30, 0.35)
			style.border_width_left = 1; style.border_width_right = 1
			style.border_width_top = 1; style.border_width_bottom = 1
			style.corner_radius_top_left = 4; style.corner_radius_top_right = 4
			style.corner_radius_bottom_left = 4; style.corner_radius_bottom_right = 4
			bg.scale = Vector2(1.0, 1.0)
			bg.mouse_default_cursor_shape = Control.CURSOR_ARROW
			kw.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			kw.add_theme_font_size_override("font_size", 18)
			diff.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
			eff.add_theme_color_override("font_color", Color(0.55, 0.55, 0.55))
		"hover":
			style.bg_color = Color(0.12, 0.12, 0.16, 0.90)
			style.border_color = Color(0.50, 0.50, 0.60)
			style.border_width_left = 1.5; style.border_width_right = 1.5
			style.border_width_top = 1.5; style.border_width_bottom = 1.5
			style.corner_radius_top_left = 4; style.corner_radius_top_right = 4
			style.corner_radius_bottom_left = 4; style.corner_radius_bottom_right = 4
			bg.scale = Vector2(1.03, 1.03)
			bg.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			kw.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			kw.add_theme_font_size_override("font_size", 18)
			diff.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
			eff.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		"focus":
			style.bg_color = Color(0.12, 0.12, 0.16, 0.90)
			style.border_color = Color(0.55, 0.75, 0.95)
			style.border_width_left = 2; style.border_width_right = 2
			style.border_width_top = 2; style.border_width_bottom = 2
			style.corner_radius_top_left = 4; style.corner_radius_top_right = 4
			style.corner_radius_bottom_left = 4; style.corner_radius_bottom_right = 4
			bg.scale = Vector2(1.03, 1.03)
			bg.mouse_default_cursor_shape = Control.CURSOR_ARROW
			kw.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			kw.add_theme_font_size_override("font_size", 18)
			diff.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
			eff.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		"pressed":
			style.bg_color = Color(0.04, 0.04, 0.06, 0.95)
			style.border_color = Color(0.65, 0.85, 1.0)
			style.border_width_left = 2; style.border_width_right = 2
			style.border_width_top = 2; style.border_width_bottom = 2
			style.corner_radius_top_left = 4; style.corner_radius_top_right = 4
			style.corner_radius_bottom_left = 4; style.corner_radius_bottom_right = 4
			bg.scale = Vector2(0.97, 0.97)
			bg.mouse_default_cursor_shape = Control.CURSOR_ARROW
			kw.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			kw.add_theme_font_size_override("font_size", 18)
			diff.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
			eff.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		"selected":
			style.bg_color = Color(0.10, 0.15, 0.22, 0.90)
			style.border_color = Color(0.70, 0.90, 1.0)
			style.border_width_left = 2; style.border_width_right = 2
			style.border_width_top = 2; style.border_width_bottom = 2
			style.corner_radius_top_left = 4; style.corner_radius_top_right = 4
			style.corner_radius_bottom_left = 4; style.corner_radius_bottom_right = 4
			bg.scale = Vector2(1.0, 1.0)
			bg.mouse_default_cursor_shape = Control.CURSOR_ARROW
			kw.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			kw.add_theme_font_size_override("font_size", 18)
			diff.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
			eff.add_theme_color_override("font_color", Color(0.65, 0.65, 0.65))
		"dimmed":
			style.bg_color = Color(0.04, 0.04, 0.06, 0.70)
			style.border_color = Color(0.15, 0.15, 0.20)
			style.border_width_left = 1; style.border_width_right = 1
			style.border_width_top = 1; style.border_width_bottom = 1
			style.corner_radius_top_left = 4; style.corner_radius_top_right = 4
			style.corner_radius_bottom_left = 4; style.corner_radius_bottom_right = 4
			bg.scale = Vector2(0.95, 0.95)
			bg.mouse_default_cursor_shape = Control.CURSOR_ARROW
			kw.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			kw.add_theme_font_size_override("font_size", 18)
			diff.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4))
			eff.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3))


# --- B2 card animation: appear (transition_in, 200ms) ---
func _animate_cards_in() -> void:
	var backdrop := _card_hud.get_node_or_null("CardBackdrop") as ColorRect
	if backdrop:
		backdrop.visible = true
		var bt := create_tween()
		bt.tween_property(backdrop, "color", Color(0.0, 0.0, 0.0, 0.25), 0.2).set_ease(Tween.EASE_OUT)
	for i in range(3):
		var card: Dictionary = _card_nodes[i]
		var bg: TextureRect = card.bg
		if not is_instance_valid(bg):
			continue
		bg.visible = true
		bg.modulate.a = 0.0
		var target_y := bg.position.y
		bg.position.y = target_y + 40
		var t := create_tween()
		t.set_parallel(true)
		t.tween_property(bg, "position:y", target_y, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		t.tween_property(bg, "modulate:a", 1.0, 0.2).set_ease(Tween.EASE_OUT)
	_upgrade_prompt_label.modulate.a = 0.0
	_upgrade_prompt_label.visible = true
	var pt := create_tween()
	pt.tween_property(_upgrade_prompt_label, "modulate:a", 1.0, 0.2).set_ease(Tween.EASE_OUT)


# --- B2 card animation: dismiss (transition_out, 200ms) ---
func _animate_cards_out() -> void:
	var backdrop := _card_hud.get_node_or_null("CardBackdrop") as ColorRect
	if backdrop:
		var bt := create_tween()
		bt.tween_property(backdrop, "color", Color(0.0, 0.0, 0.0, 0.0), 0.2).set_ease(Tween.EASE_IN)
		bt.tween_callback(func(): backdrop.visible = false)
	for i in range(3):
		var card: Dictionary = _card_nodes[i]
		var bg: TextureRect = card.bg
		if not is_instance_valid(bg):
			continue
		var t := create_tween()
		t.set_parallel(true)
		t.tween_property(bg, "position:y", bg.position.y + 40, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
		t.tween_property(bg, "modulate:a", 0.0, 0.2).set_ease(Tween.EASE_IN)
		t.chain().tween_callback(func(): bg.visible = false)
	var pt := create_tween()
	pt.tween_property(_upgrade_prompt_label, "modulate:a", 0.0, 0.2).set_ease(Tween.EASE_IN)
	pt.tween_callback(func(): _upgrade_prompt_label.visible = false)


# --- B2 card mouse handlers ---
func _on_card_mouse_entered(idx: int) -> void:
	if _card_state != 2:  # only during inspection
		return
	if _card_input_guarded:
		return
	_card_input_mode = "mouse"
	_card_hovered_idx = idx
	_card_focused_idx = idx
	_update_card_visuals()


func _on_card_mouse_exited(idx: int) -> void:
	if _card_state != 2:
		return
	if _card_hovered_idx == idx:
		_card_hovered_idx = -1
		_update_card_visuals()


func _on_card_gui_input(event: InputEvent, idx: int) -> void:
	if _card_state != 2:
		return
	if _card_input_guarded:
		return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_card_input_mode = "mouse"
			_select_upgrade_card(idx)


# --- B2 keyboard focus movement ---
func _move_focus(delta: int) -> void:
	if _card_state != 2:
		return
	if _card_input_guarded:
		return
	_card_input_mode = "keyboard"
	_card_hovered_idx = -1
	_card_focused_idx = (_card_focused_idx + delta) % 3
	if _card_focused_idx < 0:
		_card_focused_idx = 2
	_update_card_visuals()


func _confirm_focused_card() -> void:
	if _card_state != 2:
		return
	if _card_input_guarded:
		return
	_card_input_mode = "keyboard"
	_select_upgrade_card(_card_focused_idx)


# --- B2 edge-triggered keyboard input (replaces per-frame polling) ---
func _unhandled_input(event: InputEvent) -> void:
	if _card_state != 2:
		return
	if _card_input_guarded:
		return
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1, KEY_KP_1:
				_card_input_mode = "keyboard"
				_select_upgrade_card(0)
			KEY_2, KEY_KP_2:
				_card_input_mode = "keyboard"
				_select_upgrade_card(1)
			KEY_3, KEY_KP_3:
				_card_input_mode = "keyboard"
				_select_upgrade_card(2)
			KEY_LEFT:
				_move_focus(-1)
			KEY_RIGHT:
				_move_focus(1)
			KEY_ENTER, KEY_SPACE:
				_confirm_focused_card()


# --- B2: check for upgrade window triggers (tick-based; before any combat) ---
func _check_upgrade_windows() -> void:
	# Slice B: progression triggers upgrades from collected energy, never from fixed clock ticks.
	return


# --- B2: start an upgrade window (pause combat, animate cards in) ---
func _start_upgrade(phase: String) -> void:
	_upgrade_pending = true
	_upgrade_phase = phase
	_card_state = 1  # transition_in
	_card_input_guarded = true
	_card_phase_timer = 0.2
	_card_selected_idx = -1
	_card_focused_idx = 1
	_card_hovered_idx = -1
	_card_input_mode = "keyboard"
	if phase == "pierce":
		_upgrade_cards = [{"id": 1, "keyword": "[1] 轨道穿透模块", "difference": "工业清场构筑", "effect": "一发穿过两个敌人", "shortcut": "1"}]
	elif phase == "fan":
		_upgrade_cards = [{"id": 1, "keyword": "[1] 散射扇面模块", "difference": "扇面控场构筑", "effect": "一发覆盖三个敌人", "shortcut": "1"}]
	else:
		_upgrade_cards = [{"id": 1, "keyword": "[1] 动能冲击模块", "difference": "近距脱围构筑", "effect": "近身敌人被冲开", "shortcut": "1"}]
	# Populate card labels.
	for i in range(3):
		if i < _upgrade_cards.size():
			var card_data: Dictionary = _upgrade_cards[i]
			var card_node: Dictionary = _card_nodes[i]
			if is_instance_valid(card_node.keyword):
				card_node.keyword.text = card_data["keyword"]
			if is_instance_valid(card_node.diff):
				card_node.diff.text = card_data["difference"]
			if is_instance_valid(card_node.effect):
				card_node.effect.text = card_data["effect"]
	_upgrade_prompt_label.text = "选择轨道穿透模块 — 按 1 确认" if phase == "pierce" else "B2 升级选择 — 按 1/2/3 或 ← → + 回车，或点击卡牌"
	_animate_cards_in()
	# B5: Play upgrade open SFX
	if not self_test_mode:
		_upgrade_sfx_player.play()
	# Also populate old labels for backward compat.
	for i in range(3):
		if i < _upgrade_cards.size() and i < _upgrade_card_labels.size():
			_upgrade_card_labels[i].text = "%s — %s" % [_upgrade_cards[i]["keyword"], _upgrade_cards[i]["effect"]]
	print("[B2-UPGRADE] window opened phase=%s tick=%d" % [phase, session.current_tick()])


# --- B2: handle upgrade card selection phase (state machine, called each frame while _upgrade_pending) ---
func _handle_upgrade_phase(delta: float) -> void:
	match _card_state:
		1:  # transition_in — wait for animation to complete
			_card_phase_timer -= delta
			if _card_phase_timer <= 0.0:
				_card_state = 2  # inspection
				_card_input_guarded = false
				_update_card_visuals()
		2:  # inspection — input handled by _unhandled_input and mouse signals
			pass
		3:  # pressed — brief darken
			_card_phase_timer -= delta
			if _card_phase_timer <= 0.0:
				_card_state = 4  # acquired
				_card_phase_timer = 0.6
				_update_card_visuals()
				# Update acquired text.
				var sel_idx: int = _card_selected_idx
				if sel_idx >= 0 and sel_idx < _upgrade_cards.size():
					var card_data: Dictionary = _upgrade_cards[sel_idx]
					var card_node: Dictionary = _card_nodes[sel_idx]
					if is_instance_valid(card_node.keyword):
						card_node.keyword.text = card_data["keyword"] + " — 获得"
				_upgrade_prompt_label.text = _upgrade_phase + " 已获得" if _upgrade_phase == "pierce" else "扇裂 已获得"
		4:  # acquired — show confirmation
			_card_phase_timer -= delta
			if _card_phase_timer <= 0.0:
				_card_state = 5  # transition_out
				_card_phase_timer = 0.2
				_animate_cards_out()
		5:  # transition_out — wait for animation
			_card_phase_timer -= delta
			if _card_phase_timer <= 0.0:
				_card_state = 0  # hidden
				_finalize_upgrade()


# --- B2: select a card (called from input handlers; transitions to pressed state) ---
func _select_upgrade_card(idx: int) -> void:
	if _card_state != 2:
		return
	if _card_input_guarded:
		return
	if idx < 0 or idx >= _upgrade_cards.size():
		return
	_card_selected_idx = idx
	# B5: Play card confirm SFX
	if not self_test_mode:
		_card_confirm_sfx_player.play()
	_trigger_upgrade_confirmation(idx)
	_card_state = 3  # pressed
	_card_input_guarded = true
	_card_phase_timer = 0.1
	_update_card_visuals()
	print("[B2-UPGRADE] card selected idx=%d phase=%s" % [idx, _upgrade_phase])


# --- B2: finalize upgrade after acquired feedback + dismiss animation ---
func _finalize_upgrade() -> void:
	var idx: int = _card_selected_idx
	if idx < 0 or idx >= _upgrade_cards.size():
		_upgrade_pending = false
		return
	var card: Dictionary = _upgrade_cards[idx]
	# Apply the upgrade via session.step (rules-core owned).
	var result: Dictionary = session.step({"task": "upgrade_select", "selected_card_id": card["id"], "b2_phase": _upgrade_phase})
	var upgrade_fb: Dictionary = ADAPTER.upgrade_feedback_from_result(result)
	if upgrade_fb["upgrade_fired"]:
		print("[B2-UPGRADE] applied phase=%s card=%d max_targets=%d fan_arcs=%d" % [
			upgrade_fb["phase"], upgrade_fb["selected_card_id"],
			upgrade_fb["attack_max_targets"], upgrade_fb["attack_fan_arcs"]])
		# Apply visual effects based on phase.
		if upgrade_fb["phase"] == "pierce":
			attack_line.width = 6.0   # wider line for pierce
			if _attack_glow_line:
				_attack_glow_line.width = 18.0   # proportionally wider glow
		elif upgrade_fb["phase"] == "fan":
			_fan_left_line.visible = true
			_fan_right_line.visible = true
			if _fan_left_glow_line:
				_fan_left_glow_line.visible = true
				_fan_right_glow_line.visible = true
	# B5: Play upgrade applied SFX
	if not self_test_mode:
		_upgrade_sfx_player.stream = preload("res://assets/audio/upgrade_applied.wav")
		_upgrade_sfx_player.play()
		# Mark phase as complete.
		if _upgrade_phase == "pierce":
			_upgrade_first_done = true
			rail_pierce_active = true
			attack_line.width = 6.0
		elif _upgrade_phase == "fan":
			_upgrade_second_done = true
			scatter_fan_active = true
		else:
			kinetic_pulse_active = true
		# Hide all card UI.
	_upgrade_prompt_label.visible = false
	for c in _card_nodes:
		if is_instance_valid(c.bg):
			c.bg.visible = false
	for cl in _upgrade_card_labels:
		cl.visible = false
	_upgrade_pending = false
	_card_input_guarded = false
	print("[B2-UPGRADE] window closed; combat resumed")


# --- B2 visual helper: build quadratic-bezier arc points for fan curvature ---
# Generates a curved arc from start to end, bulging in the direction of offset_sign
# (positive = left/perpendicular, negative = right/opposite).
func _build_arc_points(start: Vector2, end: Vector2, offset_sign: float, num_points: int = 10) -> PackedVector2Array:
	var pts := PackedVector2Array()
	pts.append(start)
	var dir := end.normalized() if end.length_squared() > 0.0001 else Vector2.RIGHT
	var perp := Vector2(-dir.y, dir.x) * offset_sign
	var mid := (start + end) * 0.5 + perp * start.distance_to(end) * 0.25
	for i in range(1, num_points):
		var t := float(i) / float(num_points)
		var p := (1.0 - t) * (1.0 - t) * start + 2.0 * (1.0 - t) * t * mid + t * t * end
		pts.append(p)
	pts.append(end)
	return pts


func _process(delta: float) -> void:
	var _t0: int = Time.get_ticks_usec()   # perf probe: frame script time
	# Fixed-step session tick (60Hz): tick-based timing (run duration, upgrade windows) stays
	# frame-rate independent. Was per-frame advance_tick, which made 4800 ticks last ~33s at 144Hz.
	_tick_accumulator += delta
	var _tick_step: float = 1.0 / TICK_HZ
	while _tick_accumulator >= _tick_step:
		session.advance_tick()
		_tick_accumulator -= _tick_step

	# Keep the world layer stationary: Main is the player and moves, so counter its offset.
	if world_root:
		world_root.position = -position

	# Perf probe: node-count heartbeat every 5s (leaks show as steady growth).
	_perf_probe_timer += delta
	if _perf_probe_timer >= 5.0:
		_perf_probe_timer = 0.0
		var dc: int = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME)
		var objs: int = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_OBJECTS_IN_FRAME)
		var alive: int = 0
		for e in enemies:
			if is_instance_valid(e.node):
				alive += 1
		print("[PERF] nodes=%d alive=%d dict=%d fps=%.0f draw_calls=%d rs_obj=%d script_ms=%.2f" % [get_tree().get_node_count(), alive, enemies.size(), Engine.get_frames_per_second(), dc, objs, (Time.get_ticks_usec()-_t0)/1000.0])

	# Hit flash timer: brief white flash on attack line when a hit registers (50ms visual feedback).
	if _hit_flash_remaining > 0.0:
		_hit_flash_remaining -= delta
		if _hit_flash_remaining <= 0.0:
			attack_line.default_color = _attack_base_color
			if _attack_glow_line:
				_attack_glow_line.default_color = _attack_glow_base_color

	# B2: upgrade window handling — pauses combat, shows card selection, waits for player input.
	if _upgrade_pending:
		_handle_upgrade_phase(delta)
		if self_test_mode:
			_self_test_step()
		return

	# B2: check for upgrade window triggers (tick-based; before any combat processing).
	if not _in_result:
		_check_upgrade_windows()

	# T4: terminal result handling — while a result is active, gameplay input is disabled (result/input lock) and the
	# short result is presented before the automatic immediate retry.
	if _in_result:
		_handle_result_phase(delta)
		if self_test_mode:
			_self_test_step()
		return

	# T4: detect a rules-arbitrated terminal outcome from the previous step (before any new gameplay input).
	_enter_result_if_needed()
	if _in_result:
		if self_test_mode:
			_self_test_step()
		return

	# T4 self-test terminal drive: while deterministically driving the terminal via direct session.step, skip the
	# engine combat path (no entanglement between the scripted drive and the normal attack/contact loop).
	if self_test_mode and self_test_drive_terminal:
		_self_test_step()
		return

	# --- R1 input -> movement (adapter) ---
	var movement: Dictionary = _read_movement_input()
	if self_test_mode:
		# Restricted deterministic regression: scripted zero movement -> player displacement is deterministic no-op.
		position += Vector2(0, 0)
	else:
		position += Vector2(float(movement["dir_x"]), float(movement["dir_y"])) * move_speed * delta
		# Arena bounds: keep the player inside the big scrolling world (walls at world edges).
		position = position.clamp(Vector2(14.0, 14.0), WORLD_SIZE - Vector2(14.0, 14.0))
		if movement["moved"]:
			# Movement causality log: position changes feed the NEXT pre-fire refresh (no live retargeting, ADR-TECH-04).
			dbg_verbose("[RUNTIME] player_moved dir=%s,%s player=(%.0f,%.0f)" % [movement["dir_x"], movement["dir_y"], position.x, position.y])

	player_visual.position = Vector2.ZERO

	# --- Simple procedural animation: player bob + facing flip, enemy chase wobble ---
	_anim_time += delta
	if _player_sprite_node:
		_player_sprite_node.position.y = sin(_anim_time * 10.0) * 1.4
		if float(movement["dir_x"]) < -0.1:
			_player_sprite_node.flip_h = true
		elif float(movement["dir_x"]) > 0.1:
			_player_sprite_node.flip_h = false

	# Spawn grace is a real runtime phase: keep Player/Enemy/HUD presentation alive, but do not
	# issue the first refresh/resolve/combat step until the full 1.0s grace has elapsed.
	var grace_before: float = spawn_grace_remaining
	if not qa_hold_grace:
		spawn_grace_remaining = maxf(0.0, spawn_grace_remaining - delta)
	if grace_before > 0.0 and spawn_grace_remaining <= 0.0 and not _grace_phase_logged:
		_grace_phase_logged = true
		print("[TIMING][GRACE-END] tick=%d elapsed=1.000s; combat/session.step now permitted" % session.current_tick())
	if spawn_grace_remaining > 0.0:
		if not _grace_phase_logged:
			dbg_verbose("[TIMING][GRACE] tick=%d remaining=%.3fs; presentation-only" % [session.current_tick(), spawn_grace_remaining])
		_present_read_model(session.rules_state, {}, [], false, {})
		if self_test_mode:
			_self_test_step()
		return

	# --- Slice B energy collection and growth HUD ---
	_update_energy_cores(delta)
	_update_growth_hud()

	# --- Iteration 2: enemy chase AI + wave spawner (world-space; deterministic self-test path untouched) ---
	if not self_test_mode:
		for e in enemies:
			if is_instance_valid(e.node):
				var _to_player: Vector2 = position - e.node.position
				if _to_player.length_squared() > 1.0:
					e.node.position += _to_player.normalized() * float(e.speed) * delta
				# Chase animation: face the player + subtle wobble so sprites don't read as static decals.
				var spr: Sprite2D = e.visual
				if spr:
					spr.flip_h = _to_player.x < 0.0
					spr.rotation = sin(_anim_time * 9.0 + float(e.stable_id) * 1.7) * 0.12
		_update_waves(delta)

	# --- build live candidates from live enemy nodes (adapter-normalized observations; read AFTER movement) ---
	var live_candidates: Array = []
	var cluster_center := Vector2.ZERO
	var on_screen: Array = []
	for e in enemies:
		if is_instance_valid(e.node):
			on_screen.append(e)
			cluster_center += e.node.position
	if not on_screen.is_empty():
		cluster_center /= on_screen.size()
	for e in on_screen:
		# Engine observation boundary (ATTACK_RANGE): distant enemies chase visibly but are not
		# targetable until inside attack range — the survivors-like pressure window.
		if e.node.position.distance_to(position) > ATTACK_RANGE:
			continue
		live_candidates.append(ADAPTER.candidate_from_observation(
			e.stable_id, e.node.position, position, cluster_center, e.hp, 1.0))

	# Lock feedback starts a short resolve phase; do not resolve on the next process frame.
	if resolve_delay_remaining > 0.0:
		resolve_delay_remaining = maxf(0.0, resolve_delay_remaining - delta)
		if resolve_delay_remaining <= 0.0:
			dbg_verbose("[TIMING][DELAY-END] tick=%d elapsed=0.250s; resolve now permitted" % session.current_tick())
		else:
			dbg_verbose("[TIMING][DELAY] tick=%d remaining=%.3fs; resolve blocked" % [session.current_tick(), resolve_delay_remaining])
			_present_read_model(session.rules_state, {}, [], false, {})
			return

	# --- C4 contact observations: engine overlap -> adapter translation -> domain contact input ---
	var contact_input: Array = _overlapping_enemy_ids(on_screen)

	if kinetic_pulse_active:
		# Real close-range pulse: push nearby enemies away from the player every combat step.
		for e in on_screen:
			var pulse_dist: float = e.node.position.distance_to(position)
			if pulse_dist < 150.0 and pulse_dist > 1.0:
				e.node.position += (e.node.position - position).normalized() * 90.0 * delta

	# --- fire cadence (rules-core drive via session) ---
	if live_candidates.is_empty():
		# Still drive the rules once per no-target epoch so timer completion is not swallowed
		# by the presentation early-return. Victory is a terminal rule, not an attack side effect.
		var quiet_env: Dictionary = ADAPTER.make_envelope(
			"refresh_fire", [], movement, 1, [], contact_input, contact_invuln_ticks, 1,
			{"timer_completed": session.current_tick() >= run_duration_ticks}, -1, 1)
		var quiet_result: Dictionary = session.step(quiet_env)
		_apply_feedback(quiet_result, on_screen)
		_enter_result_if_needed()
		if _in_result:
			return
		# Quiet no-target presentation (UX-03 S1/S2): no fabricated lock/hit; optional one-shot restrained cue.
		_enter_quiet_presentation()
		attack_line.visible = false
		if _attack_glow_line:
			_attack_glow_line.visible = false
		if self_test_mode:
			_self_test_step()
		return

	_leave_quiet_presentation()

	last_fire_time += delta
	if last_fire_time >= attack_interval:
		last_fire_time = 0.0
		locked_this_epoch = false

	# task routing: refresh when we need a fresh lock this epoch, else resolve.
	var task: String = ADAPTER.pick_task(not locked_this_epoch, locked_this_epoch)
	# T4: the envelope carries the session terminal domain input (timer_completed) + C4 contact observations.
	var atk_max: int = 999 if self_test_mode else (3 if scatter_fan_active else (2 if rail_pierce_active else int(session.rules_state.get("attack_max_targets", 1))) )
	var env: Dictionary = ADAPTER.make_envelope(
		task, live_candidates, movement, 1, [], contact_input, contact_invuln_ticks, 1,
		{"timer_completed": session.current_tick() >= run_duration_ticks},
		-1, atk_max)
	var result: Dictionary = session.step(env)
	_apply_feedback(result, on_screen)
	# C4: light separation is applied from the contact damage events (engine-side physical response).
	var contact_fb: Dictionary = ADAPTER.contact_feedback_from_result(result)
	if not (contact_fb.get("damage", []) as Array).is_empty():
		_apply_light_separation(int(contact_fb["damage"][0]["victim_id"]), on_screen)
	if not locked_this_epoch:
		locked_this_epoch = true

	# T4: check whether the just-applied rules step arbitrated a terminal outcome (transition into the result/input lock).
	_enter_result_if_needed()

	if self_test_mode:
		_self_test_step()


# --- Iteration 2: wave spawner — escalating edge spawns; walker swarms + brute walls from wave 3 ---
func _update_waves(delta: float) -> void:
	_wave_timer += delta
	if _wave_timer < WAVE_INTERVAL:
		return
	_wave_timer = 0.0
	var live_count: int = 0
	for e in enemies:
		if is_instance_valid(e.node):
			live_count += 1
	if live_count >= MAX_LIVE_ENEMIES:
		return
	_wave_index += 1
	var walkers: int = 3 + _wave_index * 2
	for i in range(walkers):
		if live_count >= MAX_LIVE_ENEMIES:
			break
		_spawn_edge_enemy("walker")
		live_count += 1
	if _wave_index >= 3:
		var brutes: int = 1 + int(_wave_index / 3)
		for i in range(brutes):
			if live_count >= MAX_LIVE_ENEMIES:
				break
			_spawn_edge_enemy("brute")
			live_count += 1
	print("[WAVE] wave=%d live_after=%d" % [_wave_index, live_count])


func _spawn_edge_enemy(enemy_type: String) -> void:
	# Spawn on a ring around the player (just outside the camera view), clamped into the world.
	var angle: float = randf() * TAU
	var pos: Vector2 = position + Vector2.from_angle(angle) * SPAWN_RING_RADIUS
	pos = pos.clamp(Vector2(20.0, 20.0), WORLD_SIZE - Vector2(20.0, 20.0))
	var hp: int = 3 if enemy_type == "brute" else 1
	_new_enemy_node(pos, hp, ENEMY_TINT, enemy_type)


func _enter_quiet_presentation() -> void:	# One-shot restrained non-color quiet-episode cue, bound ONLY to the no-target branch (S5 §4.2, UX-03 S3).
	# Exact presentation form is NOT frozen (unresolved); here it is a single log line + the quiet label.
	if not _quiet_episode_active:
		_quiet_episode_active = true
		dbg_verbose("[NO-TARGET-CUE] quiet episode begins (one-shot restrained non-color cue; bound no_target_branch)")
	if no_target_label:
		no_target_label.text = "no target (quiet)"
	# Read-model quiet face: presentation observes zero live candidates -> no_target quartile, no fabricated attack data.
	_present_read_model(session.rules_state, {}, [], true, {})


func _leave_quiet_presentation() -> void:
	if _quiet_episode_active:
		_quiet_episode_active = false
		if no_target_label:
			no_target_label.text = ""


func _present_read_model(state: Dictionary, fb: Dictionary, events: Array, engine_quiet: bool = false, contact_fb: Dictionary = {}) -> void:
	# --- HUD minimal face (S5 §4.1): life/timer/b2, all existing as read-model fields, no invented values. ---
	# life: three-segment structure; segments_lost read from the rules trace (C5: real deduction, non-color).
	var segments_lost: int = int(state.get("segments_lost", 0))
	if segments_lost < 0:
		segments_lost = 0
	if segments_lost > 3:
		segments_lost = 3
	var life_text := "LIFE "
	for i in range(3):
		life_text += "[x]" if i < segments_lost else "[o]"
	life_text += "  segments_lost=%d" % segments_lost
	if life_label:
		life_label.text = "生命  " + life_text.substr(5, 11)
	# timer: current_tick (SESSION) + run_duration_bound opaque (value deferred to Systems; not promoted).
	if timer_label:
		timer_label.text = "时间  %02d:%02d" % [int(session.current_tick() / 60), int(session.current_tick()) % 60]
	# b2: show current B2 phase (read from rules state).
	var b2_phase: String = String(state.get("b2_phase", "pre"))
	var b2_text: String = "B2: "
	if b2_phase == "pierce":
		b2_text += "穿透"
	elif b2_phase == "fan":
		b2_text += "扇裂"
	else:
		b2_text += "pre-fission"
	if b2_label:
		b2_label.text = "等级  1   经验  --"

	# --- attack_state four states (S5 §4.3), derived ONLY from rules trace fields. ---
	var no_target_branch: bool = bool(state.get("no_target_branch", false))
	var hit_empty: bool = (state.get("hit_results", {}) as Dictionary).is_empty()
	var snap_empty: bool = (state.get("target_snapshot_ids", []) as Array).is_empty()
	var attack_text: String
	if engine_quiet or (no_target_branch and snap_empty):
		attack_text = "attack: no_target (quiet)"
	elif snap_empty:
		attack_text = "attack: idle"
	elif hit_empty:
		attack_text = "attack: resolving"
	else:
		attack_text = "attack: resolved"
	if state_label:
		state_label.text = attack_text

	# --- kill_state (S5 §4.3): none -> killed while kill_outcomes is non-empty (settlement trace). ---
	var kill_outcomes: Dictionary = state.get("kill_outcomes", {})
	var kill_text: String = "kill: killed(%d)" % kill_outcomes.size() if not kill_outcomes.is_empty() else "kill: none"
	if kill_label:
		kill_label.text = kill_text

	# --- hit_results_feedback binding marker (S5 §4.3): each feedback class is emitted ONLY when its rule source is
	#     non-empty (adapter gates lock/hit/kill); the HUD line shows the class -> source binding for auditability. ---
	var lock_count: int = (fb.get("lock_target", []) as Array).size() if fb.get("lock_target", []) is Array else 0
	var hit_count: int = (fb.get("hit", []) as Array).size() if fb.get("hit", []) is Array else 0
	var kill_count: int = (fb.get("kill", []) as Array).size() if fb.get("kill", []) is Array else 0
	var fb_text: String
	if lock_count == 0 and hit_count == 0 and kill_count == 0:
		fb_text = "feedback: - (quiet)"
	else:
		fb_text = "feedback: lock=%d hit=%d kill=%d (bound: target_snapshot_ids/hit_results/kill_outcomes)" % [lock_count, hit_count, kill_count]
	if feedback_label:
		feedback_label.text = fb_text

	# --- invalidation presentation section (S5 §4.3 visible part): "target invalid -> no hit this shot", no drain detail.
	var inv_text := ""
	for e in events:
		if e.get("type", "") == "invalidation_event":
			inv_text += "invalidation: id=%d tick=%d (no hit this shot)  " % [int(e.get("id", -1)), int(e.get("tick", -1))]
	if invalidation_label:
		invalidation_label.text = inv_text

	# --- C5 contact read-model line (bound to the rules contact events; non-color). ---
	var contact_text := "contact: none"
	var c_damage: Array = contact_fb.get("damage", []) if contact_fb.get("damage", []) is Array else []
	var c_rearm: Array = contact_fb.get("rearm", []) if contact_fb.get("rearm", []) is Array else []
	if not c_damage.is_empty():
		var first_dmg: Dictionary = c_damage[0]
		contact_text = "contact: damage(victim=%d segments_lost=%d)" % [int(first_dmg.get("victim_id", -1)), int(first_dmg.get("segments_lost", 0))]
	elif not c_rearm.is_empty():
		contact_text = "contact: rearm(%s)" % str(c_rearm)
	elif bool(contact_fb.get("invulnerable", false)):
		contact_text = "contact: invulnerable"
	if contact_label:
		contact_label.text = contact_text

	# Read-model change log (edge-triggered; keeps runtime logs small and deterministic).
	var line: String = "%s | %s | %s | %s | %s" % [attack_text, kill_text, fb_text, inv_text.strip_edges(), contact_text]
	if line != _last_presented_line:
		_last_presented_line = line
		dbg_verbose("[READ-MODEL] %s" % line)


func _emit_attack_trajectory_arc(points: PackedVector2Array, attack_pos: Vector2) -> void:
	if not _attack_afterimage_line or points.size() < 2:
		return
	if _attack_afterimage_tween:
		_attack_afterimage_tween.kill()
	_attack_afterimage_line.points = points
	_attack_afterimage_line.modulate.a = 1.0
	_attack_afterimage_line.visible = true
	_attack_afterimage_tween = create_tween()
	_attack_afterimage_tween.tween_property(_attack_afterimage_line, "modulate:a", 0.0, 0.16).set_ease(Tween.EASE_OUT)
	_attack_afterimage_tween.tween_callback(func(): _attack_afterimage_line.visible = false)


func _emit_attack_afterimage(points: PackedVector2Array) -> void:
	"""Emit attack afterimage effect (alias for _emit_attack_trajectory_arc)."""
	if not _attack_afterimage_line or points.size() < 2:
		return
	if _attack_afterimage_tween:
		_attack_afterimage_tween.kill()
	_attack_afterimage_line.points = points
	_attack_afterimage_line.modulate.a = 1.0
	_attack_afterimage_line.visible = true
	_attack_afterimage_tween = create_tween()
	_attack_afterimage_tween.tween_property(_attack_afterimage_line, "modulate:a", 0.0, 0.16).set_ease(Tween.EASE_OUT)
	_attack_afterimage_tween.tween_callback(func(): _attack_afterimage_line.visible = false)


func _trigger_hit_impact_flash(impact_pos: Vector2) -> void:
	"""VFX-01: Hit Impact Flash - localized core->transition->falloff impact with rust particles.
	
	- Core cyan-white #00f0ff (ultra cyan), mid-cyan #00e5ff, falloff #00838f
	- Duration ~150ms, no persistent glow
	- 4-6 rust particles (#b85c2e, #8b3a1a) spray 16-24px before fading
	- Uses Line2D for core/transition/falloff rings + CPUParticles2D for rust debris
	"""
	# Spawn rust particles outward from impact point
	if _hit_flash_particles:
		_hit_flash_particles.position = impact_pos
		_hit_flash_particles.emitting = true
		_hit_flash_particles.restart()
		_hit_flash_particles.visible = true

	# Core ring: 8-16 px, cyan-white #00f0ff
	var core_ring := Line2D.new()
	core_ring.width = 2.0
	core_ring.default_color = VFX_CORE_CYAN
	core_ring.visible = true
	var core_points := PackedVector2Array()
	for i in range(12):
		var angle := TAU * i / 11.0
		core_points.append(Vector2(cos(angle), sin(angle)) * 12.0)
	core_ring.points = core_points
	world_root.add_child(core_ring)

	# Transition ring: 24-32 px, mid-cyan #00e5ff
	var trans_ring := Line2D.new()
	trans_ring.width = 4.0
	trans_ring.default_color = VFX_MID_CYAN
	trans_ring.visible = true
	var trans_points := PackedVector2Array()
	for i in range(12):
		var angle := TAU * i / 11.0
		trans_points.append(Vector2(cos(angle), sin(angle)) * 28.0)
	trans_ring.points = trans_points
	world_root.add_child(trans_ring)

	# Falloff ring: 48 px, dark cyan #00838f
	var fall_ring := Line2D.new()
	fall_ring.width = 6.0
	fall_ring.default_color = VFX_FALL_CYAN
	fall_ring.visible = true
	var fall_points := PackedVector2Array()
	for i in range(12):
		var angle := TAU * i / 11.0
		fall_points.append(Vector2(cos(angle), sin(angle)) * 48.0)
	fall_ring.points = fall_points
	world_root.add_child(fall_ring)

	# Tween: expand and fade over 150ms
	var tween := create_tween()
	tween.set_parallel(true)
	# Core expands from 12 -> 16 px and fades out quickly
	tween.tween_method(func(t: float): _resize_ring(core_ring, 12.0, 16.0, t), 0.0, 1.0, 0.15).set_ease(Tween.EASE_OUT)
	tween.tween_property(core_ring, "modulate:a", 0.0, 0.15).set_ease(Tween.EASE_IN)
	# Transition expands from 28 -> 32 px and fades
	tween.tween_method(func(t: float): _resize_ring(trans_ring, 28.0, 32.0, t), 0.0, 1.0, 0.15).set_ease(Tween.EASE_OUT)
	tween.tween_property(trans_ring, "modulate:a", 0.0, 0.15).set_ease(Tween.EASE_IN)
	# Falloff expands from 48 -> 48 px (stays) and fades slowly
	tween.tween_method(func(t: float): _resize_ring(fall_ring, 48.0, 48.0, t), 0.0, 1.0, 0.15).set_ease(Tween.EASE_OUT)
	tween.tween_property(fall_ring, "modulate:a", 0.0, 0.15).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(func():
		core_ring.queue_free()
		trans_ring.queue_free()
		fall_ring.queue_free()
		if _hit_flash_particles:
			_hit_flash_particles.visible = false
	)
	dbg_verbose("[VFX-01][HIT-IMPACT] core->transition->falloff (150ms); localized flash, no persistent glow")


func _resize_ring(ring: Line2D, base_radius: float, target_radius: float, t: float) -> void:
	var radius: float = lerp(base_radius, target_radius, t)
	var points := PackedVector2Array()
	for i in range(12):
		var angle := TAU * i / 11.0
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	ring.points = points


func _play_kill_dissolve(node: Node2D) -> void:
	if not is_instance_valid(node):
		return
	# VFX-02: Kill Death Dissolve - crack-collapse/dissolve sequence (~300ms)
	# Frame 1: enemy silhouette begins to crack with fracture lines
	# Frame 2: body collapses inward, rust flakes burst outward
	# Frame 3: body dissolves into grey ash and rusted scrap

	var pos = node.position

	# Frame 1: crack lines (bright cyan)
	var crack_t := create_tween()
	var crack_duration = 0.10  # 100ms
	crack_t.tween_property(node, "scale", Vector2(1.0, 0.9), crack_duration).set_ease(Tween.EASE_IN_OUT)
	# Add a visual crack effect via Line2D
	var crack_line := Line2D.new()
	crack_line.width = 2.0
	crack_line.default_color = VFX_CORE_CYAN
	crack_line.visible = true
	var crack_pts := PackedVector2Array([Vector2.ZERO, Vector2(30, 0), Vector2(15, -10)])
	crack_line.points = crack_pts
	crack_line.position = pos
	world_root.add_child(crack_line)
	# Lifecycle fix (2026-08-20 perf regression): crack_line leaked one visible Line2D per
	# kill (never freed) — after dozens of kills the accumulated draw items caused the
	# "quickly becomes laggy" report. Fade with the crack phase, then free.
	crack_t.tween_property(crack_line, "modulate:a", 0.0, crack_duration).set_ease(Tween.EASE_IN)
	crack_t.chain().tween_callback(crack_line.queue_free)

	# Frame 2: collapse inward + rust flakes burst
	var collapse_t := create_tween()
	var collapse_duration = 0.15  # 150ms
	collapse_t.set_parallel(true)
	collapse_t.tween_property(node, "scale", Vector2(0.85, 0.55), collapse_duration).set_ease(Tween.EASE_IN_OUT)
	collapse_t.tween_property(node, "rotation", 0.2, collapse_duration).set_ease(Tween.EASE_OUT)

	# Rust flakes burst: 2-3 lightweight particles (was 8-12; per-kill node/tween spikes caused frame hitches).
	# Keep a small readable burst without creating a particle node storm under wave pressure.
	if _hit_flash_particles and _hit_flash_particles.is_inside_tree():
		for i in range(2, 5):
			var flake_pos := node.position + Vector2(randf() * 50 - 25, randf() * 50 - 25)
			var flake := CPUParticles2D.new()
			flake.name = "RustFlake_%d" % i
			# Godot 4.7.1: CPUParticles2D emits in all directions by default
			flake.lifetime = 0.40  # 400ms
			flake.one_shot = true
			flake.gravity = Vector2(0, 0)
			flake.emitting = false
			flake.visible = false
			# Particle scale: 3.0
			flake.scale_amount_min = 3.0
			flake.scale_amount_max = 4.0
			flake.color = VFX_RUST_PARTICLE
			flake.initial_velocity_min = 30.0 + randf() * 20.0
			flake.initial_velocity_max = flake.initial_velocity_min + 10.0
			flake.spread = 180.0  # 180 degrees = full 360 spread
			flake.angle_min = 0.0
			flake.angle_max = 360.0
			flake.position = flake_pos
			world_root.add_child(flake)
			# Animate outward then fade
			var fade_t := create_tween()
			fade_t.tween_property(flake, "modulate:a", 0.0, 0.30).set_ease(Tween.EASE_IN)
			fade_t.tween_callback(flake.queue_free)

	# Frame 3: dissolve into ash and scrap
	var dissolve_t := create_tween()
	var dissolve_duration = 0.05  # 50ms
	dissolve_t.tween_property(node, "scale", Vector2(0.65, 0.35), dissolve_duration).set_ease(Tween.EASE_IN_OUT)
	dissolve_t.tween_property(node, "modulate:a", 0.0, dissolve_duration).set_ease(Tween.EASE_IN)
	dissolve_t.chain().tween_callback(node.queue_free)

	dbg_verbose("[VFX-02][KILL-DISSOLVE] crack-collapse->flake-burst->ash (300ms total, no persistent glow, no full-screen flash)")


func _emit_clear_effect() -> void:
	if _clear_effect_tween:
		_clear_effect_tween.kill()
	if _upgrade_first_done and not _upgrade_second_done and _pierce_clear_line:
		_pierce_clear_line.points = PackedVector2Array([position + Vector2(-320, 0), position + Vector2(320, 0)])
		_pierce_clear_line.visible = true
		_pierce_clear_line.width = 2.0
		_pierce_clear_line.default_color = Color(0.0, 0.92, 1.0, 0.85)
		_clear_effect_tween = create_tween()
		_clear_effect_tween.set_parallel(true)
		_clear_effect_tween.tween_property(_pierce_clear_line, "width", 26.0, 0.22).set_ease(Tween.EASE_OUT)
		_clear_effect_tween.tween_property(_pierce_clear_line, "default_color:a", 0.0, 0.48).set_delay(0.08).set_ease(Tween.EASE_IN)
		_clear_effect_tween.chain().tween_callback(func(): _pierce_clear_line.visible = false)
		dbg_verbose("[VFX][B2-PIERCE-CLEAR] horizontal core -> widening corridor -> open space (0.48s)")
	elif _upgrade_second_done and _fan_clear_line and _fan_clear_left_line and _fan_clear_right_line:
		var fan_mid_end := position + Vector2.RIGHT * 300.0
		var fan_left_end := position + Vector2.RIGHT.rotated(-0.52) * 300.0
		var fan_right_end := position + Vector2.RIGHT.rotated(0.52) * 300.0
		_fan_clear_left_line.points = _build_arc_points(position, fan_left_end, 1.0)
		_fan_clear_line.points = PackedVector2Array([position, fan_mid_end])
		_fan_clear_right_line.points = _build_arc_points(position, fan_right_end, -1.0)
		for clear_line in [_fan_clear_left_line, _fan_clear_line, _fan_clear_right_line]:
			clear_line.visible = true
			clear_line.width = 2.0
			clear_line.default_color = Color(0.0, 0.92, 1.0, 0.72)
		_clear_effect_tween = create_tween()
		_clear_effect_tween.set_parallel(true)
		for clear_line in [_fan_clear_left_line, _fan_clear_line, _fan_clear_right_line]:
			_clear_effect_tween.tween_property(clear_line, "width", 18.0, 0.22).set_ease(Tween.EASE_OUT)
			_clear_effect_tween.tween_property(clear_line, "default_color:a", 0.0, 0.48).set_delay(0.08).set_ease(Tween.EASE_IN)
		_clear_effect_tween.chain().tween_callback(func(): _fan_clear_left_line.visible = false)
		_clear_effect_tween.tween_callback(func(): _fan_clear_line.visible = false)
		_clear_effect_tween.tween_callback(func(): _fan_clear_right_line.visible = false)
		dbg_verbose("[VFX][B2-FAN-CLEAR] three arcs -> three corridors -> open space (0.48s)")


func _trigger_upgrade_confirmation(idx: int) -> void:
	if not _upgrade_confirm_flash or idx < 0 or idx >= 3:
		return
	if _upgrade_confirm_tween:
		_upgrade_confirm_tween.kill()
	_upgrade_confirm_flash.position = Vector2(233.0 + idx * 160.0, 215.0)
	_upgrade_confirm_flash.visible = true
	_upgrade_confirm_flash.color = Color(0.0, 0.90, 1.0, 0.0)
	_upgrade_confirm_tween = create_tween()
	_upgrade_confirm_tween.tween_property(_upgrade_confirm_flash, "color:a", 0.22, 0.08).set_ease(Tween.EASE_OUT)
	_upgrade_confirm_tween.tween_property(_upgrade_confirm_flash, "color:a", 0.0, 0.32).set_ease(Tween.EASE_IN)
	_upgrade_confirm_tween.tween_callback(func(): _upgrade_confirm_flash.visible = false)
	dbg_verbose("[VFX][UPGRADE-CONFIRM] card=%d short interruptible pulse behind text (0.40s)" % idx)


func _apply_feedback(result: Dictionary, on_screen: Array) -> void:
	var state: Dictionary = result.get("state", {})
	var fb: Dictionary = ADAPTER.feedback_from_result(result)
	var snap: Array = state.get("target_snapshot_ids", [])
	var steps: Array = result.get("diagnostics", {}).get("steps", [])
	var contact_fb: Dictionary = ADAPTER.contact_feedback_from_result(result)

	# Lock / auto-attack line points at the locked target.
	if not fb["lock_target"].is_empty():
		var sid: int = int(fb["lock_target"][0])
		# B5: Play attack SFX (normal or pierce depending on upgrade state)
		if not self_test_mode:
			if _upgrade_first_done:
				_attack_sfx_player.stream = preload("res://assets/audio/attack_pierce.wav")
			else:
				_attack_sfx_player.stream = preload("res://assets/audio/attack_normal.wav")
			# Follow player position for 2D audio and play both normal/pierce variants.
			_attack_sfx_player.position = position
			# Slight pitch variation per shot breaks the machine-gun monotony of a repeating SFX.
			_attack_sfx_player.pitch_scale = 0.94 + randf() * 0.12
			_attack_sfx_player.play()
		for e in on_screen:
			if e.stable_id == sid and is_instance_valid(e.node):
				attack_line.points = PackedVector2Array([Vector2.ZERO, e.node.position - position])
				attack_line.visible = true
				_emit_attack_afterimage(attack_line.points)
				# Sync glow layer with core line.
				if _attack_glow_line:
					_attack_glow_line.points = attack_line.points
					_attack_glow_line.visible = true
		dbg_verbose("[AUTO-ATTACK] locked id=%d" % sid)
		if "refresh_fire" in steps:
			resolve_delay_remaining = 0.25
			dbg_verbose("[TIMING][LOCK] tick=%d resolve_delay=0.250s; resolve blocked" % session.current_tick())
			# Movement causality (ADR-TECH-04 / UX-02 U2-B): this refresh re-observed positions AFTER movement,
			# so a moved player changes the NEXT shot's lock — the current shot's snapshot stays immutable.
			dbg_verbose("[LOCK-REFRESH] player=(%.0f,%.0f) lock=%s (movement re-locks NEXT refresh; current shot snapshot immutable)" % [position.x, position.y, str(snap)])
		# B2: fan arcs — draw curved bezier arcs when fan upgrade is active.
		if _fan_left_line.visible:
			var target_end: Vector2 = attack_line.points[1] if attack_line.points.size() > 1 else Vector2.ZERO
			if target_end != Vector2.ZERO:
				var fan_angle: float = target_end.angle()
				var fan_len: float = target_end.length()
				var left_end := Vector2(cos(fan_angle - 0.4) * fan_len, sin(fan_angle - 0.4) * fan_len)
				var right_end := Vector2(cos(fan_angle + 0.4) * fan_len, sin(fan_angle + 0.4) * fan_len)
				# Curved arcs: quadratic bezier bulging outward from the center line.
				_fan_left_line.points = _build_arc_points(Vector2.ZERO, left_end, 1.0)
				_fan_right_line.points = _build_arc_points(Vector2.ZERO, right_end, -1.0)
				_fan_mid_line.points = PackedVector2Array([Vector2.ZERO, target_end])
				_fan_mid_glow_line.points = _fan_mid_line.points
				_fan_mid_line.visible = true
				_fan_mid_glow_line.visible = true
				# Sync fan glow layers.
				if _fan_left_glow_line:
					_fan_left_glow_line.points = _fan_left_line.points
					_fan_right_glow_line.points = _fan_right_line.points
		dbg_verbose("[FB-BIND] lock=%s (emitted only while target_snapshot_ids non-empty)" % str(fb["lock_target"]))
	else:
		attack_line.visible = false
		if _attack_glow_line:
			_attack_glow_line.visible = false
		if fb.get("no_target", false):
			dbg_verbose("[FB-BIND] no lock/hit/kill (no_target branch; quiet, no fabrication)")

# Hit feedback bound to hit_results (VFX-01: Hit Impact Flash).
	if not fb["hit"].is_empty():
		dbg_verbose("[FB-BIND] hit=%s (emitted only while hit_results non-empty)" % str(fb["hit"]))
		for hid in fb["hit"]:
			for e in on_screen:
				if e.stable_id == int(hid) and is_instance_valid(e.node):
					_trigger_hit_impact_flash(e.node.position)
		for hid in fb["hit"]:
			dbg_verbose("[HIT] target id=%d" % hid)

	# Sync rule-owned candidate HP back to the engine entity. Without this, brute HP reset
	# on every refresh and could never die through normal combat.
	var rule_candidates: Array = state.get("live_candidates", [])
	for cand in rule_candidates:
		var cand_id: int = int(cand.get("stable_id", -1))
		for e in on_screen:
			if e.stable_id == cand_id:
				e.hp = int(cand.get("hp", e.hp))
				break

	# Kill feedback bound to kill_outcomes -> kill tween: scale up + fade out, then remove.
	if not fb["kill"].is_empty():
		# B5 + reward-audio layer (2026-08-21): randomized pitch + combo pitch-climb + throttling —
		# the survivors-like "popcorn" kill feel instead of a fixed-pitch metronome.
		if not self_test_mode:
			var now_k: float = Time.get_ticks_msec() / 1000.0
			if now_k - _last_kill_sfx_time >= 0.1:   # throttle: clustered kills merge into one pop
				if now_k - _last_kill_time < 2.0:
					_kill_streak += 1
				else:
					_kill_streak = 0
				_last_kill_time = now_k
				_last_kill_sfx_time = now_k
				_enemy_death_sfx_player.pitch_scale = clampf(1.0 + _kill_streak * 0.03, 1.0, 1.3) * randf_range(0.9, 1.1)
				_enemy_death_sfx_player.play()
		dbg_verbose("[FB-BIND] kill=%s (emitted only while kill_outcomes non-empty)" % str(fb["kill"]))
	for kid in fb["kill"]:
		dbg_verbose("[KILL] id=%d died -> kill tween (scale+fade)" % kid)
		for e in on_screen:
			if e.stable_id == kid and is_instance_valid(e.node):
				# Death -> energy core drop (Slice B reward loop).
				if not self_test_mode and is_instance_valid(e.node):
					_spawn_energy_core(e.node.position)
				if not self_test_mode:
					# Crack-collapse / dissolve: asymmetric squash, rotation, then fade.
					_play_kill_dissolve(e.node)
				else:
					e.node.queue_free()
				# Remove the dead runtime record immediately; live cap and perf metrics must
				# describe live entities, not the entire kill history.
				enemies.erase(e)
				break
			_emit_clear_effect()
		dbg_verbose("[CLEAR] enemy id=%d cleared from play" % kid)
	if not fb["kill"].is_empty():
		var remaining: int = 0
		for e in on_screen:
			if is_instance_valid(e.node):
				remaining += 1
		dbg_verbose("[RUNTIME] live enemies=%d" % remaining)

	# C4 contact feedback bound to the rules contact events (no fabrication when none present).
	if not contact_fb["damage"].is_empty():
		for dmg in contact_fb["damage"]:
			dbg_verbose("[CONTACT] damage victim_id=%d segments_lost=%d" % [int(dmg["victim_id"]), int(dmg["segments_lost"])])
	if bool(contact_fb.get("invulnerable", false)):
		dbg_verbose("[CONTACT-INVULN] brief invulnerability entered (no repeat damage during protection)")
	if not contact_fb["rearm"].is_empty():
		dbg_verbose("[CONTACT-REARM] re-armed ids=%s (separation ended invulnerability; future contact legal)" % str(contact_fb["rearm"]))

	# Full read-model presentation from this step's rules trace + gated feedback (R2) + contact feedback (C5).
	_present_read_model(state, fb, result.get("events", []), false, contact_fb)



# --- QA debug-only observation seam (read-only, explicitly releasable) ---
# qa_hold_before_combat(): pause grace countdown so QA can capture the runtime tree
# (Player + Enemy + HUD all present) before combat begins.
func qa_hold_before_combat() -> void:
	qa_hold_grace = true
	print("[QA-HOLD] grace hold engaged; spawn_grace_remaining=%.3fs; combat paused, presentation active" % spawn_grace_remaining)


# qa_release_before_combat(): release the hold and resume normal grace countdown.
func qa_release_before_combat() -> void:
	qa_hold_grace = false
	print("[QA-RELEASE] grace hold released; spawn_grace_remaining=%.3fs; normal flow resumes" % spawn_grace_remaining)


# qa_state_snapshot(): return a read-only snapshot of the current runtime tree
# for QA verification (Player + Enemy + HUD co-existence during grace).
func qa_state_snapshot() -> Dictionary:
	var nodes: Array = []
	# Player node
	nodes.append({
		"name": "Player",
		"type": "ColorRect",
		"position": {"x": position.x, "y": position.y},
		"groups": ["player", "player_actor"],
		"valid": is_instance_valid(player_visual),
	})
	# Enemy nodes
	for e in enemies:
		if is_instance_valid(e.node):
			nodes.append({
				"name": e.node.name,
				"type": "Node2D",
				"position": {"x": e.node.position.x, "y": e.node.position.y},
				"groups": ["enemies", "enemy_actor"],
				"stable_id": e.stable_id,
				"hp": e.hp,
			})
	# HUD labels
	var hud_nodes: Array = []
	for lbl in [life_label, timer_label, b2_label, state_label, kill_label, feedback_label, invalidation_label, no_target_label, contact_label, result_label]:
		if is_instance_valid(lbl):
			hud_nodes.append({
				"name": lbl.name if lbl.name else "Label",
				"text": lbl.text,
				"visible": lbl.visible,
			})
	return {
		"tick": session.current_tick(),
		"spawn_grace_remaining": spawn_grace_remaining,
		"qa_hold_grace": qa_hold_grace,
		"in_result": _in_result,
		"result_state": _result_state,
		"nodes": nodes,
		"hud": hud_nodes,
	}

func _self_test_step() -> void:
	# Scripted run: force-fire once, expect a kill, then assert removal + clear, then a contact regression (segments_lost=1),
	# then a T4 terminal regression (depletion -> defeat -> result -> auto-restart -> fresh run no cross-run loss), quit 0.
	self_test_t += 1
	if not self_test_fire_issued:
		# Ensure an epoch locked and resolved a hit -> death.
		if not locked_this_epoch:
			return
		if session.rules_state.get("kill_outcomes", {}).size() > 0:
			self_test_fire_issued = true
			print("[SELF-TEST] kill_outcomes=%s" % [Array(session.rules_state["kill_outcomes"].keys())])
	elif not self_test_done:
		# After the kill(s), verify the killed enemy is removed from play (live enemies shrank) -> clear visible.
		var remaining: int = 0
		for e in enemies:
			if is_instance_valid(e.node):
				remaining += 1
		if remaining == 0:
			print("[SELF-TEST-CLEAR] enemies removed; live enemies=%d (clear visible)" % remaining)
			self_test_done = true
			# C4/C5 contact regression: place a scripted enemy ON the player (engine AABB overlap -> domain contact).
			self_test_contact_enemy = {"node": _new_enemy_node(position, 1, Color(0.9, 0.35, 0.2)), "stable_id": next_stable_id - 1}
			print("[SELF-TEST-CONTACT] overlapping enemy placed on player (contact regression begins)")
		elif self_test_t > 120:
			print("[SELF-TEST-FAIL] enemy NOT removed; live enemies=%d" % remaining)
			get_tree().quit(1)
	elif not self_test_contact_done:
		# Assert exactly one contact damage (segments_lost=1) and NO repeat while overlapped/protected.
		self_test_contact_frames += 1
		var lost: int = int(session.rules_state.get("segments_lost", 0))
		if lost == 1 and self_test_contact_frames > 3:
			# Verify the overlapping enemy still exists, but no second damage occurred (persistent overlap -> no repeat).
			var still_there := is_instance_valid(self_test_contact_enemy.get("node"))
			if still_there and lost == 1:
				print("[SELF-TEST-CONTACT-PASS] segments_lost=1 (exactly one contact damage; overlap no repeat; life deducted)")
			else:
				print("[SELF-TEST-CONTACT-PASS] segments_lost=1 (exactly one contact damage; life deducted)")
			self_test_contact_done = true
			self_test_terminal_depleted = false
			self_test_drive_terminal = false
		elif lost > 1:
			print("[SELF-TEST-CONTACT-FAIL] repeat damage; segments_lost=%d" % lost)
			get_tree().quit(1)
		elif self_test_contact_frames > 60:
			print("[SELF-TEST-CONTACT-FAIL] no contact damage; segments_lost=%d" % lost)
			get_tree().quit(1)
	elif not self_test_drive_terminal and not self_test_terminal_depleted:
		# T4 terminal regression start: switch to direct deterministic session drive (skip engine combat path in _process).
		self_test_drive_terminal = true
		print("[SELF-TEST-TERMINAL] driving life depletion -> defeat via scripted direct session.step (terminal regression begins)")
		return
	elif self_test_drive_terminal and not self_test_terminal_depleted:
		# T4: deterministically drive one more legal contact (damage + re-arm) via direct session.step to raise life
		# depletion toward 3. The rules core arbitrates DEFEAT the moment segments_lost reaches 3 (same-frame arbitration).
		var lost: int = int(session.rules_state.get("segments_lost", 0))
		var outcome: String = String(session.rules_state.get("terminal_outcome", ""))
		if lost >= 3:
			self_test_terminal_depleted = true
			self_test_drive_terminal = false
			print("[SELF-TEST-DEPLETED] segments_lost=3 outcome=%s (life depleted -> rules arbitrates defeat)" % outcome)
			return
		# One legal contact (contact_input) then a separation re-arm step.
		session.step({
			"task": "refresh_fire",
			"contact_input": [{"id": 900}],
			"contact_invulnerability_ticks": 30,
			"contact_damage": 1,
		})
		session.step({"task": "refresh_fire", "contact_input": []})
		# Safety bound: a failure to deplete must not hang the loop.
		if self_test_t > 500:
			print("[SELF-TEST-TERMINAL-FAIL] life not depleted; segments_lost=%d outcome=%s" % [lost, outcome])
			get_tree().quit(1)
	elif not _in_result:
		# The runtime will enter the result phase on the next _process top (via _enter_result_if_needed). Wait here.
		return
	else:
		# Result phase active: when the auto-restart fires (_in_result cleared), verify the fresh run has no cross-run loss.
		if self_test_seen_result and not _in_result:
			print("[SELF-TEST-RESTART-PASS] new run segments_lost=%d (no cross-run loss) -> terminal/reset regression PASS" % int(session.rules_state.get("segments_lost", 0)))
			get_tree().quit(0)
		if not self_test_seen_result:
			self_test_seen_result = true
			if _result_state == "defeat":
				print("[SELF-TEST-RESULT] defeat result entered (input locked; readable non-color RESULT)")
		return