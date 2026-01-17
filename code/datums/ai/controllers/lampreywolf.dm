/datum/ai_controller/lampreywolf
	movement_delay = 0.2 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGET_BLOOD_THRESHOLD = 1, // all the way
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/blooded(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_BASIC_MOB_FLEEING = TRUE,
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/aggro_find_target/if_hungry,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic_watcher,
		/datum/ai_planning_subtree/spacing/lampreywolf, // this helps with move targets
		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body/drink_blood,
		)

	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/lampreywolf/TryPossessPawn(atom/new_pawn)
	. = ..()
	RegisterSignal(new_pawn, COMSIG_ANIMAL_TAMED, PROC_REF(on_user_tamed))

/datum/ai_controller/lampreywolf/UnpossessPawn(destroy)
	UnregisterSignal(pawn, COMSIG_ANIMAL_TAMED)
	. = ..()

/datum/ai_controller/lampreywolf/proc/on_user_tamed()
	movement_delay = 0.3 SECONDS
	set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)
	idle_behavior = null


/datum/ai_planning_subtree/spacing/lampreywolf
	minimum_distance = 3
	/// How far away will we allow our target to get?
	maximum_distance = 6
	//need_los = TRUE

/datum/ai_planning_subtree/spacing/lamprey_volf/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(.)
		return SUBTREE_RETURN_FINISH_PLANNING
