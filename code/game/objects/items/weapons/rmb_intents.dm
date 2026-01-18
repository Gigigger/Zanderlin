/datum/rmb_intent
	var/name = "intent"
	var/desc = ""
	var/icon_state = ""
	var/def_bonus = 0

/datum/rmb_intent/proc/special_attack(mob/living/user, atom/target)
	if(!isliving(target))
		return
	if(!user)
		return
	if(user.incapacitated(IGNORE_GRAB))
		return
	var/mob/living/L = target
	user.changeNext_move(CLICK_CD_FAST)
	playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
	user.visible_message(span_danger("[user] feints an attack at [target]!"))
	var/perc = 50
	if(user.mind)
		var/obj/item/I = user.get_active_held_item()
		var/ourskill = 0
		var/theirskill = 0
		if(I)
			if(I.associated_skill)
				ourskill = user.get_skill_level(I.associated_skill)
			if(L.mind)
				I = L.get_active_held_item()
				if(I?.associated_skill)
					theirskill = L.get_skill_level(I.associated_skill)
		perc += (ourskill - theirskill) * 15 	//skill is of the essence
		perc += (user.STAINT - L.STAINT) * 10	//but it's also mostly a mindgame
		perc += (user.STASPD - L.STASPD) * 5 	//yet a speedy feint is hard to counter
		perc += (user.STAPER - L.STAPER) * 5 	//a good eye helps
	if(!user.cmode)
		perc = 0
	if(L.has_status_effect(/datum/status_effect/debuff/feinted))
		perc = 0
	if(user.has_status_effect(/datum/status_effect/debuff/feintcd))
		perc -= rand(10,30)
	user.apply_status_effect(/datum/status_effect/debuff/feintcd)
	perc = CLAMP(perc, 0, 90) //no zero risk superfeinting
	if(prob(perc)) //feint intent increases the immobilize duration significantly
		if(istype(user.rmb_intent, /datum/rmb_intent/feint))
			L.apply_status_effect(/datum/status_effect/debuff/feinted)
			L.changeNext_move(10)
			L.Immobilize(15)
			to_chat(user, span_notice("[L] fell for my feint attack!"))
			to_chat(L, span_danger("I fall for [user]'s feint attack!"))
		else
			L.apply_status_effect(/datum/status_effect/debuff/feinted)
			L.changeNext_move(4)
			L.Immobilize(5)
			to_chat(user, span_notice("[L] fell for my feint attack!"))
			to_chat(L, span_danger("I fall for [user]'s feint attack!"))
	else
		if(user.client?.prefs.showrolls)
			to_chat(user, span_warning("[L] did not fall for my feint... [perc]%"))

/datum/rmb_intent/aimed
	name = "aimed"
	desc = "Your attacks are more precise but have a longer recovery time. Higher chance for certain critical hits. Reduced dodge bonus."
	icon_state = "rmbaimed"
	def_bonus = -20

/datum/rmb_intent/strong
	name = "strong"
	desc = "Your attacks have increased strength and have increased force but use more stamina. Higher chance for certain critical hits. Intentionally fails surgery steps. Reduced dodge bonus."
	icon_state = "rmbstrong"
	def_bonus = -20

/datum/rmb_intent/swift
	name = "swift"
	desc = "Your attacks have less recovery time but are less accurate and have reduced strength."
	icon_state = "rmbswift"

/datum/rmb_intent/special
	name = "special"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) A special attack that depends on the type of weapon you are using."
	icon_state = "rmbspecial"

/datum/rmb_intent/feint
	name = "feint"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) A deceptive half-attack with no follow-through, meant to force your opponent to open their guard. Useless against someone who is dodging."
	icon_state = "rmbfeint"
	def_bonus = 10

/datum/status_effect/debuff/feinted
	id = "nofeint"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/feinted
	duration = 50

/atom/movable/screen/alert/status_effect/debuff/feinted
	name = "Feinted"
	desc = span_boldwarning("I have been tricked, and cannot defend myself!") + "\n"
	icon_state = "muscles"

/datum/status_effect/debuff/feintcd
	id = "feintcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/feintcd
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/feintcd
	name = "Feint Cooldown"
	desc = span_warning("I have feinted recently, my opponents will be wary.") + "\n"

/datum/status_effect/debuff/riposted
	id = "riposted"
	duration = 30

/datum/rmb_intent/riposte
	name = "defend"
	desc = "No delay between dodge and parry rolls."
	icon_state = "rmbdef"
	def_bonus = 10

/datum/rmb_intent/guard
	name = "guarde"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) Raise your weapon, ready to attack any creature who moves onto the space you are guarding."
	icon_state = "rmbguard"

/datum/rmb_intent/weak
	name = "weak"
	desc = "Your attacks have halved strength and will never critically-hit. Surgery steps can only be done with this intent. Useful for longer punishments, play-fighting, and bloodletting."
	icon_state = "rmbweak"

/// Blood feed rmb intent used for simple mob blood drinkers
/datum/rmb_intent/simple/blood_leech
	name = "feed"
	desc = "RMB - Feed a target blood from yourself. Or, take a target's blood if you're in combat mode"
	icon_state = "special"
	/// how much blood we steal/give per do_after
	var/feed_amount = 10

/datum/rmb_intent/simple/blood_leech/special_attack(mob/living/user, atom/target)
	if(!isliving(target) || !isanimal(user) || user.doing())
		return
	if(user == target)
		return //freak.
	var/mob/living/simple_animal/A = user
	var/mob/living/L = target
	var/giving = !user.cmode

	if(!giving)
		var/noBlood = L.blood_volume == 0
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			if(NOBLOOD in C.dna?.species?.species_traits)
				noBlood = TRUE
		if(noBlood)
			to_chat(user, span_warning("They have no blood to drink."))
			return
		if(SEND_SIGNAL(user, COMSIG_MOB_RETURN_HUNGER) == 100)
			to_chat(user, span_warning("I'm full."))
			return

		user.visible_message(span_danger("[user] starts drinking the blood of [L]."), span_danger("I start drinking the blood of [L]."), null, COMBAT_MESSAGE_RANGE)
	else
		if(SEND_SIGNAL(user, COMSIG_MOB_RETURN_HUNGER) == 0)
			to_chat(user, span_warning("I have no blood to give."))
			return
		if(L.blood_volume >= BLOOD_VOLUME_NORMAL)
			to_chat(user, span_warning("They need no blood."))
			return
		user.visible_message(span_green("[user] starts feeding blood to [L]."), span_danger("I start feeding blood to [L]."), null, COMBAT_MESSAGE_RANGE)
	while(do_after(A, 1 SECONDS, extra_checks=CALLBACK(src, PROC_REF(can_feed), A, L, giving), display_over_user = TRUE, interaction_key = DOAFTER_SOURCE_LEECH_BLOOD))
		var/hunger = SEND_SIGNAL(user, COMSIG_MOB_RETURN_HUNGER) * A.food_max / 100
		var/blood = 0
		if(giving)
			blood = max(min(BLOOD_VOLUME_NORMAL - L.blood_volume, feed_amount, hunger), 0)
		else
			blood = -max(min(A.food_max - hunger, feed_amount, L.blood_volume), 0)
		L.blood_volume += blood
		SEND_SIGNAL(user, COMSIG_MOB_ADJUST_HUNGER, -blood)
		playsound(A, 'sound/misc/drink_blood.ogg', 50, FALSE, -4)


/datum/rmb_intent/simple/blood_leech/proc/can_feed(mob/living/user, mob/living/target, giving)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(C.dna?.species && (NOBLOOD in C.dna.species.species_traits)) // if for some god damn reason you weren't earlier but are now... maybe you're a skeleton?
			return FALSE
	var/hunger = SEND_SIGNAL(user, COMSIG_MOB_RETURN_HUNGER)
	if(hunger == null)
		return FALSE
	if(giving)
		return hunger > 0 && target.blood_volume < BLOOD_VOLUME_NORMAL
	else
		return hunger < 100 && target.blood_volume > 0

