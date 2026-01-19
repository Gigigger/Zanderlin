
/datum/ai_behavior/hide
	required_distance = 1

/datum/ai_behavior/hide/perform(seconds_per_tick, datum/ai_controller/controller, target_key, hunger_timer_key)
	. = ..()
	if(isanimal(controller.pawn))
		var/mob/living/simple_animal/mob = controller.pawn
		mob.hide()

	finish_action(controller, TRUE)
