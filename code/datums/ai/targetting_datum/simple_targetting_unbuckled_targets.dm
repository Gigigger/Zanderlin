/// subtype for ignoring buckled (grappled) targets
/datum/targetting_datum/basic/unbuckled_targets

/datum/targetting_datum/basic/unbuckled_targets/can_attack(mob/living/living_mob, atom/the_target)
	if(living_mob.buckled_mobs?.Find(the_target))
		return FALSE
	return ..()
