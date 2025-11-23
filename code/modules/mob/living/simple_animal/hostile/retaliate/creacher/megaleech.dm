/mob/living/simple_animal/hostile/retaliate/megaleech
	icon = 'icons/roguetown/mob/monster/megaleech.dmi'
	name = "dire leech"
	desc = ""
	icon_state = "megaleech"
	icon_living = "megaleech"
	icon_dead = "megaleech_dead"

	animal_species = /mob/living/simple_animal/hostile/retaliate/megaleech
	faction = list(FACTION_SEA) // not so different, you and I
	gender = FEMALE
	footstep_type = FOOTSTEP_MOB_SLIME
	emote_see = list("looks around.", "chews some leaves.")
	move_to_delay = 8

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/natural/hide = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 3,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 4,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 4,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	head_butcher = /obj/item/natural/head/saiga

	health = 120
	maxHealth = 120
	blood_gulp = 30

	food_max = BLOOD_VOLUME_OKAY // this is absurdly high compared to most mobs but it's used for bloodfeeding

	food_type = list(/obj/item/reagent_containers/food/snacks/produce/grain/wheat,
					/obj/item/reagent_containers/food/snacks/produce/grain/oat,
					/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry,
					/obj/item/reagent_containers/food/snacks/produce/fruit/apple)
	tame_chance = 25
	bonus_tame_chance = 15

	base_intents = list(/datum/intent/simple/bite/megaleech)
	possible_rmb_intents = list(/datum/rmb_intent/megaleech_feed)
	//attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	melee_damage_lower = 4
	melee_damage_upper = 10
	retreat_distance = 10
	minimum_distance = 10
	base_speed = 8
	base_constitution = 16
	base_strength = 9
	base_endurance = 12
	can_buckle = TRUE
	buckle_lying = FALSE
	can_saddle = TRUE
	aggressive = TRUE

	ai_controller = /datum/ai_controller/megaleech

	var/static/list/pet_commands = list(
		/datum/pet_command/fish,
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
		/datum/pet_command/attack/leech_blood,
		/datum/pet_command/attack/give_blood,
		/datum/pet_command/play_dead,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

/mob/living/simple_animal/hostile/retaliate/megaleech/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands // due to signal overridings from pet commands
	. = ..()
	RegisterSignal(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, PROC_REF(on_pre_attack))

	var/datum/component/generic_mob_hunger/hunger = GetComponent(/datum/component/generic_mob_hunger)
	if(hunger)
		hunger.hunger_drain = 1
	AddElement(/datum/element/ai_retaliate)

	ADD_TRAIT(src, TRAIT_GOOD_SWIM, ROUNDSTART_TRAIT)

/mob/living/simple_animal/hostile/retaliate/megaleech/Destroy()
	UnregisterSignal(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET)
	return ..()

//do our rmb intent out of combat. Scuffed? Absolutely. Alternatives? A pain in the ass.
/mob/living/simple_animal/hostile/retaliate/megaleech/proc/on_pre_attack(datum/source, atom/target)
	if(!cmode && rmb_intent)
		rmb_intent.special_attack(src, target)
		return COMPONENT_HOSTILE_NO_PREATTACK

/mob/living/simple_animal/hostile/retaliate/megaleech/AttackingTarget(mob/living/passed_target)
	. = ..()
	var/mob/living/L = target
	if(. && istype(target) && L.blood_volume > 0 && SEND_SIGNAL(src, COMSIG_MOB_RETURN_HUNGER) < 100)
		var/blood_taken = min(L.blood_volume, blood_gulp)
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			if(C.dna?.species && (NOBLOOD in C.dna.species.species_traits))
				return
			drinksomeblood(C, zone_selected)
		else
			L.blood_volume -= blood_taken
			L.handle_blood()
			playsound(loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)
		SEND_SIGNAL(src, COMSIG_MOB_ADJUST_HUNGER, blood_taken) // chance of minor overflow but it's negligible

/mob/living/simple_animal/hostile/retaliate/megaleech/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	if(ssaddle)
		var/mutable_appearance/saddlet = mutable_appearance(icon, "megaleech_saddle_above", 4.3)
		. += saddlet
		saddlet = mutable_appearance(icon, "megaleech_saddle")
		. += saddlet
	if(has_buckled_mobs())
		var/mutable_appearance/mounted = mutable_appearance(icon, "megaleech_mounted", 4.3)
		. += mounted

/mob/living/simple_animal/hostile/retaliate/megaleech/tamed(mob/user)
	. = ..()
	deaggroprob = 30
	if(can_buckle)
		AddComponent(/datum/component/riding/megaleech)

/mob/living/simple_animal/hostile/retaliate/megaleech/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "mouth"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "mouth"
		if(BODY_ZONE_PRECISE_EARS)
			return "mouth"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "belly"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "tail"
		if(BODY_ZONE_R_LEG)
			return "tail"
		if(BODY_ZONE_L_LEG)
			return "tail"

	return ..()

/mob/living/simple_animal/hostile/retaliate/megaleech/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/megaleech/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)


/datum/intent/simple/bite/megaleech
	penfactor = 50


/datum/rmb_intent/megaleech_feed
	name = "feed"
	desc = "RMB - Feed a target blood from yourself. Or, take a target's blood if you're in combat mode"
	icon_state = "special"
	/// how much blood we steal/give per do_after
	var/feed_amount = 10

/datum/rmb_intent/megaleech_feed/special_attack(mob/living/user, atom/target)
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
			if(C.dna?.species && (NOBLOOD in C.dna.species.species_traits))
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
			blood = min(BLOOD_VOLUME_NORMAL - L.blood_volume, feed_amount, hunger)
		else
			blood = -min(A.food_max - hunger, feed_amount, L.blood_volume)
		L.blood_volume += blood
		SEND_SIGNAL(user, COMSIG_MOB_ADJUST_HUNGER, -blood)
		playsound(A, 'sound/misc/drink_blood.ogg', 50, FALSE, -4)


/datum/rmb_intent/megaleech_feed/proc/can_feed(mob/living/user, mob/living/target, giving)
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
