extends GdUnitTestSuite

const CATALOG = preload("res://content/weapon_catalog.gd")


func test_catalog_validates_current_definitions_and_resources() -> void:
	var errors: Array = CATALOG.validate_catalog()
	assert_array(errors).is_empty()


func test_catalog_choice_order_is_stable() -> void:
	var choices: Array = CATALOG.choice_definitions()
	assert_int(choices.size()).is_equal(3)
	assert_str(String(choices[0].get("id", ""))).is_equal("rail_pierce")
	assert_str(String(choices[1].get("id", ""))).is_equal("scatter_fan")
	assert_str(String(choices[2].get("id", ""))).is_equal("arc_coil")
	assert_bool(not choices.any(func(choice): return String(choice.get("id", "")) == "kinetic_pulse")).is_true()


func test_catalog_all_weapon_ranks_are_complete_and_behavior_specific() -> void:
	var pierce_rank_1: Dictionary = CATALOG.rank_profile("rail_pierce", 1)
	var pierce_rank_3: Dictionary = CATALOG.rank_profile("rail_pierce", 3)
	assert_int(int(pierce_rank_1.get("max_targets", 0))).is_equal(3)
	assert_int(int(pierce_rank_3.get("max_targets", 0))).is_equal(5)

	var fan_rank_1: Dictionary = CATALOG.rank_profile("scatter_fan", 1)
	var fan_rank_3: Dictionary = CATALOG.rank_profile("scatter_fan", 3)
	assert_int(int(fan_rank_1.get("fan_arcs", 0))).is_equal(3)
	assert_int(int(fan_rank_3.get("max_targets", 0))).is_equal(6)

	var pulse_rank_1: Dictionary = CATALOG.rank_profile("kinetic_pulse", 1)
	var pulse_rank_3: Dictionary = CATALOG.rank_profile("kinetic_pulse", 3)
	assert_float(float(pulse_rank_1.get("pulse_radius", 0.0))).is_equal(185.0)
	assert_float(float(pulse_rank_3.get("pulse_push_force", 0.0))).is_equal(165.0)


func test_catalog_rejects_duplicate_order_entry() -> void:
	var bad_order := ["rail_pierce", "rail_pierce", "kinetic_pulse"]
	var errors: Array = CATALOG.validate_catalog(CATALOG.DEFINITIONS, bad_order, false)
	assert_bool(not errors.is_empty()).is_true()
	assert_bool(errors.any(func(error): return String(error).contains("duplicate weapon id"))).is_true()


func test_catalog_rejects_missing_rank() -> void:
	var bad_definitions: Dictionary = CATALOG.DEFINITIONS.duplicate(true)
	var ranks: Dictionary = bad_definitions["scatter_fan"].get("ranks", {})
	ranks.erase(2)
	bad_definitions["scatter_fan"]["ranks"] = ranks
	var errors: Array = CATALOG.validate_catalog(bad_definitions, CATALOG.ORDER, false)
	assert_bool(not errors.is_empty()).is_true()
	assert_bool(errors.any(func(error): return String(error).contains("missing rank 2: scatter_fan"))).is_true()
