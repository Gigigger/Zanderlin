/datum/ai_planning_subtree/eat_dead_body
	var/datum/ai_behavior/eat_dead_body/behavior = /datum/ai_behavior/eat_dead_body

/datum/ai_planning_subtree/eat_dead_body/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]
	if(QDELETED(target))
		return
	var/mob/living/pawn = controller.pawn
	if(pawn.doing())
		return
	controller.queue_behavior(behavior, BB_BASIC_MOB_FOOD_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	return SUBTREE_RETURN_FINISH_PLANNING //we are going into battle...no distractions.


/datum/ai_planning_subtree/eat_dead_body/then_hide
	behavior = /datum/ai_behavior/eat_dead_body/then_hide

/datum/ai_planning_subtree/eat_dead_body/drink_blood
	behavior = /datum/ai_behavior/interact_with_target/drink_blood

/datum/ai_planning_subtree/eat_dead_body/drink_blood/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]
	if(QDELETED(target))
		return
	if(isliving(target))
		var/mob/living/L = target
		if(L.blood_volume > 0)
			return ..()
	return FALSE
