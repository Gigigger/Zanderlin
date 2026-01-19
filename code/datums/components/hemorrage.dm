//causes direct bloodloss to victim, unused but i made it so do whatever with it
/datum/component/hemorrage
	var/bloodloss // how much blood do we lose on a hit
	var/vampiric // should we give this blood to the person who took it

/datum/component/hemorrage/Initialize(bloodloss=0, vampiric=FALSE)
	if(!isitem(parent) && !ishostile(parent) && !isgun(parent))
		return COMPONENT_INCOMPATIBLE

	src.bloodloss = bloodloss
	src.vampiric = vampiric

/datum/component/hemorrage/RegisterWithParent()
	if(isgun(parent))
		RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(projectile_hit))
	else if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else if(ishostile(parent))
		RegisterSignal(parent, COMSIG_HOSTILE_ATTACKINGTARGET, PROC_REF(hostile_attackingtarget))

/datum/component/hemorrage/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_AFTERATTACK, COMSIG_HOSTILE_ATTACKINGTARGET, COMSIG_PROJECTILE_ON_HIT))

/datum/component/hemorrage/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	do_hemorrage(user, target)

/datum/component/hemorrage/proc/hostile_attackingtarget(mob/living/simple_animal/hostile/attacker, atom/target)
	do_hemorrage(attacker, target)

/datum/component/hemorrage/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	do_hemorrage(firer, target)

/datum/component/hemorrage/proc/do_hemorrage(atom/heal_target, atom/damage_target)
	if(isliving(damage_target))
		var/mob/living/damaging = damage_target
		var/bloodToLose = min(bloodloss, damaging.blood_volume)
		damaging.blood_volume = max(damaging.blood_volume - bloodToLose, 0)
		damaging.handle_blood()

		if(isliving(heal_target) && vampiric)
			var/mob/living/healing = heal_target
			healing.blood_volume = min(healing.blood_volume + bloodToLose, BLOOD_VOLUME_MAXIMUM)
			healing.handle_blood()
