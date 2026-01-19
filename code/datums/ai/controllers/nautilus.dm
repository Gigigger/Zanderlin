/datum/ai_controller/nautilus
	movement_delay = 0.3 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/resist,
		/datum/ai_planning_subtree/simple_find_priority/nautilus,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,

		/datum/ai_planning_subtree/find_dead_bodies/nautilus,
		/datum/ai_planning_subtree/eat_dead_body/then_hide,

		/datum/ai_planning_subtree/no_target_hide,
	)
	idle_behavior = /datum/idle_behavior/idle_hide


/datum/ai_planning_subtree/simple_find_priority/nautilus

/datum/ai_planning_subtree/simple_find_priority/nautilus/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(isliving(controller.pawn))
		var/mob/living/basicmob = controller.pawn
		if(basicmob.pulledby)
			controller.set_blackboard_key(BB_BASIC_MOB_PRIORITY_TARGETS, basicmob.pulledby)
			return ..()
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets/ambush/nautilus, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)


/datum/ai_planning_subtree/find_dead_bodies/nautilus
	vision_range = 4
	behavior = /datum/ai_behavior/find_and_set/dead_bodies/ambush
