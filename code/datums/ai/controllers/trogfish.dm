/datum/ai_controller/trogfish
	movement_delay = 0.4 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,

		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/targeted_mob_ability/trogfish_burst,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,

		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk


/datum/ai_planning_subtree/targeted_mob_ability/trogfish_burst
	finish_planning = FALSE
	var/burst_health = 0.6

/datum/ai_planning_subtree/targeted_mob_ability/trogfish_burst/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if(isanimal(controller.pawn) && !isdead(controller.pawn))
		var/mob/living/simple_animal/A = controller.pawn
		if(A.health <= round(A.maxHealth * burst_health))
			return ..()

