/// simple_animals only.
/datum/idle_behavior/idle_hide
	///Chance that the mob enters its hiding stage
	var/hide_chance = 25
	var/cooldown = 2 SECONDS
	var/next_time = 0

/datum/idle_behavior/idle_hide/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	. = ..()
	if(next_time > world.time)
		return
	if(!controller.able_to_run())
		return
	if(controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]) // this means we are likely eating a corpse
		return
	if(controller.blackboard[BB_RESISTING]) //we are trying to resist
		return
	if(controller.blackboard[BB_IS_BEING_RIDDEN])
		return

	var/mob/living/simple_animal/hider = controller.pawn
	if(!istype(hider) || hider.binded)
		return

	next_time = world.time + cooldown
	if(prob(hide_chance) && isturf(hider.loc) && !hider.pulledby)
		hider.hide()
