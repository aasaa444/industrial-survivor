class_name WeaponCatalog
extends RefCounted

const CATALOG_VERSION := "m4-weapon-catalog-v1"
const ORDER := ["rail_pierce", "scatter_fan", "kinetic_pulse", "arc_coil"]
const INITIAL_CHOICE_ORDER := ["rail_pierce", "scatter_fan", "arc_coil"]
const ALLOWED_BEHAVIORS := ["line_pierce", "fan", "pulse", "arc_chain"]
const ALLOWED_TAGS := ["pierce", "area", "control", "survival"]

const DEFINITIONS := {
	"rail_pierce": {
		"id": "rail_pierce",
		"legacy_build_id": "pierce",
		"display_name": "\u8F68\u9053\u7A7F\u900F\u6A21\u5757",
		"build_tag": "pierce",
		"behavior_id": "line_pierce",
		"card_difference": "\u76F4\u7EBF\u6E05\u573A",
		"card_effect": "\u4E00\u53D1\u7A7F\u8FC7\u4E09\u4E2A\u654C\u4EBA",
		"sfx_path": "res://assets/audio/attack_pierce.wav",
		"ranks": {
			1: {"max_targets": 3, "fan_arcs": 1, "pulse_radius": 0.0, "pulse_push_force": 0.0, "cooldown_ticks": 36, "card_effect": "\u4E00\u53D1\u7A7F\u8FC7\u4E09\u4E2A\u654C\u4EBA"},
			2: {"max_targets": 4, "fan_arcs": 1, "pulse_radius": 0.0, "pulse_push_force": 0.0, "cooldown_ticks": 33, "card_effect": "\u7A7F\u900F\u76EE\u6807\u589E\u52A0"},
			3: {"max_targets": 5, "fan_arcs": 1, "pulse_radius": 0.0, "pulse_push_force": 0.0, "cooldown_ticks": 30, "card_effect": "\u8F68\u9053\u66F4\u5BBD\u3001\u66F4\u4EAE"},
		},
	},
	"scatter_fan": {
		"id": "scatter_fan",
		"legacy_build_id": "fan",
		"display_name": "\u6563\u5C04\u6247\u9762\u6A21\u5757",
		"build_tag": "control",
		"behavior_id": "fan",
		"card_difference": "\u6247\u9762\u63A7\u573A",
		"card_effect": "\u4E00\u53D1\u8986\u76D6\u56DB\u4E2A\u654C\u4EBA",
		"sfx_path": "res://assets/audio/attack_normal.wav",
		"ranks": {
			1: {"max_targets": 4, "fan_arcs": 3, "pulse_radius": 0.0, "pulse_push_force": 0.0, "cooldown_ticks": 42, "card_effect": "\u4E00\u53D1\u8986\u76D6\u56DB\u4E2A\u654C\u4EBA"},
			2: {"max_targets": 5, "fan_arcs": 3, "pulse_radius": 0.0, "pulse_push_force": 0.0, "cooldown_ticks": 39, "card_effect": "\u6247\u9762\u8986\u76D6\u8303\u56F4\u6269\u5927"},
			3: {"max_targets": 6, "fan_arcs": 3, "pulse_radius": 0.0, "pulse_push_force": 0.0, "cooldown_ticks": 36, "card_effect": "\u6247\u9762\u8F68\u8FF9\u66F4\u5BBD\u3001\u66F4\u4EAE"},
		},
	},
	"arc_coil": {
		"id": "arc_coil",
		"legacy_build_id": "arc_coil",
		"display_name": "\u7535\u5f27\u7ebf\u5708\u6a21\u5757",
		"build_tag": "area",
		"build_tags": ["area", "control"],
		"behavior_id": "arc_chain",
		"card_difference": "\u8fd1\u573a\u8fde\u9501",
		"card_effect": "\u7b2c\u4e00\u6bb5\u7535\u5f27\u9023\u5411\u90bb\u8fd1\u76ee\u6807",
		"sfx_path": "res://assets/attack_arc_coil.wav",
		"icon_path": "res://assets/arc_coil_icon.svg",
		"ranks": {
			1: {"max_targets": 3, "fan_arcs": 1, "pulse_radius": 0.0, "pulse_push_force": 0.0, "chain_width": 4.0, "cooldown_ticks": 48, "card_effect": "\u8fde\u9501\u4e09\u4e2a\u8fd1\u573a\u76ee\u6807"},
			2: {"max_targets": 4, "fan_arcs": 1, "pulse_radius": 0.0, "pulse_push_force": 0.0, "chain_width": 5.0, "cooldown_ticks": 45, "card_effect": "\u8fde\u9501\u76ee\u6807\u589e\u52a0"},
			3: {"max_targets": 5, "fan_arcs": 1, "pulse_radius": 0.0, "pulse_push_force": 0.0, "chain_width": 6.0, "cooldown_ticks": 42, "card_effect": "\u7535\u5f27\u66f4\u5bbd\u3001\u66f4\u4eae"},
		},
	},
	"kinetic_pulse": {
		"id": "kinetic_pulse",
		"legacy_build_id": "pulse",
		"display_name": "\u52A8\u80FD\u51B2\u51FB\u6A21\u5757",
		"build_tag": "survival",
		"behavior_id": "pulse",
		"card_difference": "\u8FD1\u8DDD\u8131\u56F4",
		"card_effect": "\u8FD1\u8EAB\u654C\u4EBA\u88AB\u51B2\u5F00",
		"sfx_path": "res://assets/audio/attack_normal.wav",
		"ranks": {
			1: {"max_targets": 1, "fan_arcs": 1, "pulse_radius": 185.0, "pulse_push_force": 115.0, "card_effect": "\u8FD1\u8EAB\u654C\u4EBA\u88AB\u51B2\u5F00"},
			2: {"max_targets": 1, "fan_arcs": 1, "pulse_radius": 220.0, "pulse_push_force": 140.0, "card_effect": "\u51B2\u51FB\u8303\u56F4\u6269\u5927"},
			3: {"max_targets": 1, "fan_arcs": 1, "pulse_radius": 255.0, "pulse_push_force": 165.0, "card_effect": "\u51B2\u51FB\u51FB\u9000\u66F4\u5F3A"},
		},
	},
}


static func validate_catalog(definitions: Dictionary = DEFINITIONS, order: Array = ORDER, check_resources: bool = true) -> Array:
	var errors: Array = []
	if order.size() != definitions.size():
		errors.append("catalog order and definitions have different sizes")
	var seen := {}
	for weapon_id_raw in order:
		var weapon_id := String(weapon_id_raw)
		if seen.has(weapon_id):
			errors.append("duplicate weapon id: %s" % weapon_id)
			continue
		seen[weapon_id] = true
		if not definitions.has(weapon_id):
			errors.append("missing definition: %s" % weapon_id)
			continue
		var definition: Dictionary = definitions[weapon_id]
		if String(definition.get("id", "")) != weapon_id:
			errors.append("definition id mismatch: %s" % weapon_id)
		if not ALLOWED_BEHAVIORS.has(String(definition.get("behavior_id", ""))):
			errors.append("unsupported behavior: %s" % weapon_id)
		if not ALLOWED_TAGS.has(String(definition.get("build_tag", ""))):
			errors.append("unsupported build tag: %s" % weapon_id)
		var ranks: Dictionary = definition.get("ranks", {})
		for rank in range(1, 4):
			if not ranks.has(rank):
				errors.append("missing rank %d: %s" % [rank, weapon_id])
				continue
			var profile: Dictionary = ranks[rank]
			if int(profile.get("max_targets", 0)) < 1:
				errors.append("invalid max_targets rank %d: %s" % [rank, weapon_id])
			if int(profile.get("fan_arcs", 0)) < 1:
				errors.append("invalid fan_arcs rank %d: %s" % [rank, weapon_id])
			if String(profile.get("card_effect", "")).is_empty():
				errors.append("missing card effect rank %d: %s" % [rank, weapon_id])
		if check_resources:
			for resource_key in ["sfx_path", "icon_path"]:
				var resource_path := String(definition.get(resource_key, ""))
				if resource_path.is_empty():
					if resource_key == "icon_path" and String(definition.get("behavior_id", "")) != "arc_chain":
						continue
					errors.append("missing resource path %s: %s" % [resource_key, weapon_id])
				elif not ResourceLoader.exists(resource_path):
					errors.append("missing resource %s: %s" % [resource_key, weapon_id])
	return errors


static func choice_definitions() -> Array:
	var definitions: Array = []
	for weapon_id in INITIAL_CHOICE_ORDER:
		definitions.append(DEFINITIONS[weapon_id].duplicate(true))
	return definitions


static func definition_for_id(weapon_id: String) -> Dictionary:
	return DEFINITIONS.get(weapon_id, {}).duplicate(true)


static func definition_for_legacy_build(legacy_build_id: String) -> Dictionary:
	for weapon_id in ORDER:
		var definition: Dictionary = DEFINITIONS[weapon_id]
		if String(definition.get("legacy_build_id", "")) == legacy_build_id:
			return definition.duplicate(true)
	return {}


static func rank_profile(weapon_id: String, rank: int) -> Dictionary:
	var definition := definition_for_id(weapon_id)
	if definition.is_empty():
		return {}
	return (definition.get("ranks", {}) as Dictionary).get(clampi(rank, 1, 3), {}).duplicate(true)