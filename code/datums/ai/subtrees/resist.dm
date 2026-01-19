/datum/ai_planning_subtree/resist

/datum/ai_planning_subtree/resist/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(!isliving(controller.pawn))
		return
	var/mob/living/pawn = controller.pawn
	if(pawn.pulledby || pawn.buckling)
		controller.queue_behavior(/datum/ai_behavior/resist)
