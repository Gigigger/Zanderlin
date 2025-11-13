/datum/ai_controller/hermitcrab
	movement_delay = 0.5 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/flee_target,

		/datum/ai_planning_subtree/simple_find_target/hermitcrab,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/sneak,
		/datum/ai_planning_subtree/no_target_hide,
	)

	idle_behavior = /datum/idle_behavior/idle_hide


/datum/ai_planning_subtree/simple_find_target/hermitcrab

/datum/ai_planning_subtree/simple_find_target/hermitcrab/SelectBehaviors(datum/ai_controller/controller, delta_time)
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets/ambush/hermitcrab, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
