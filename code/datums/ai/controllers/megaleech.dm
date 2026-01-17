/datum/ai_controller/megaleech
	movement_delay = 0.7 SECONDS
	blackboard = list(
		BB_TARGET_BLOOD_THRESHOLD = BLOOD_VOLUME_SURVIVE,
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/blooded(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_BASIC_MOB_FLEEING = TRUE,
	)

	ai_movement = /datum/ai_movement/hybrid_pathing
	idle_behavior = /datum/idle_behavior/idle_random_walk

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/aggro_find_target/if_hungry,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/saiga,
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee,
		/datum/ai_planning_subtree/flee_target/saiga,
		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body/drink_blood,
	)

/datum/ai_controller/megaleech/TryPossessPawn(atom/new_pawn)
	. = ..()
	RegisterSignal(new_pawn, COMSIG_ANIMAL_TAMED, PROC_REF(on_user_tamed))

/datum/ai_controller/megaleech/UnpossessPawn(destroy)
	UnregisterSignal(pawn, COMSIG_ANIMAL_TAMED)
	. = ..()

/datum/ai_controller/megaleech/proc/on_user_tamed()
	movement_delay = 0.3 SECONDS
	set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)
	idle_behavior = null
