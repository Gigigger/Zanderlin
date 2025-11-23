/// Does the target have blood?
/datum/targetting_datum/basic/blooded
	/// BB key that holds the value of blood the target should have before selecting
	var/target_blood_threshold_key = BB_TARGET_BLOOD_THRESHOLD

/datum/targetting_datum/basic/blooded/can_attack(mob/living/living_mob, atom/the_target)
	. = ..()
	var/datum/ai_controller/controller = living_mob.ai_controller
	var/blood_threshold = controller.blackboard[target_blood_threshold_key]

	// we found a normal success, they have enough blood to want do it, and they actually have blood
	if(. && living_mob?.blood_volume > blood_threshold)
		if(iscarbon(living_mob))
			var/mob/living/carbon/C = living_mob
			//and it's not like a skeleton or some shit
			if(NOBLOOD in C.dna?.species?.species_traits)
				return FALSE
		return TRUE
