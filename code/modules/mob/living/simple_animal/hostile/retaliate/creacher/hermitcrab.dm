/mob/living/simple_animal/hostile/retaliate/hermitcrab
	icon = 'icons/roguetown/mob/monster/hermitcrab.dmi'
	name = "hermit crab"
	desc = ""
	icon_state = "hermitcrab"
	icon_living = "hermitcrab"
	icon_dead = "hermitcrab_dead"

	faction = list(FACTION_SEA)
	emote_hear = list("chortles.")
	emote_see = list("scrounges for food.")
	move_to_delay = 5
	vision_range = 2
	aggro_vision_range = 2

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1,
						/obj/item/natural/fur/rous = 1,/obj/item/alch/bone = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/natural/fur/rous = 1, /obj/item/alch/bone = 4)
	head_butcher = /obj/item/natural/head/rous

	health = 30
	maxHealth = 30

	base_intents = list(/datum/intent/simple/crabpincer)
	attack_sound = 'sound/combat/wooshes/punch/punchwoosh (2).ogg'
	melee_damage_lower = 12
	melee_damage_upper = 14
	accurate = TRUE
	dextrous = TRUE
	held_items = list(null, null)
	can_be_held = TRUE

	base_constitution = 3
	base_strength = 3
	base_speed = 6

	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 40
	defdrain = 5
	retreat_health = 0.3
	aggressive = TRUE
	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/hermitcrab
	density = FALSE

	ai_controller = /datum/ai_controller/hermitcrab
	//todo
	food_type = list(
		/obj/item/reagent_containers/food/snacks/cheddarslice,
		/obj/item/reagent_containers/food/snacks/cheese_wedge,
		/obj/item/reagent_containers/food/snacks/cheddar,
		/obj/item/reagent_containers/food/snacks/cheese,
	)
	tame_chance = 25
	bonus_tame_chance = 15

	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
		/datum/pet_command/fetch,
		/datum/pet_command/play_dead,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

	var/hiding = FALSE

/obj/effect/decal/remains/hermitcrab
	name = "remains"
	gender = PLURAL
	icon_state = "hermitcrab_dead"
	icon = 'icons/roguetown/mob/monster/hermitcrab.dmi'


/mob/living/simple_animal/hostile/retaliate/hermitcrab/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands
	. = ..()
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_appearance(UPDATE_OVERLAYS)
	ADD_TRAIT(src, TRAIT_GOOD_SWIM, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CHUNKYFINGERS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TINY, TRAIT_GENERIC)
	transform = transform.Scale(0.75, 0.75)
	update_transform()
	//all this shit just to avoid making a subtype mobholder...
	RegisterSignal(src, COMSIG_MOB_HOLDER_DEPOSIT, PROC_REF(mob_holder_deposit))
	RegisterSignal(src, COMSIG_MOB_HOLDER_RELEASE, PROC_REF(mob_holder_release))
	RegisterSignal(src, COMSIG_MOB_HOLDER_EMBEDDED, PROC_REF(mob_holder_embedded))

/mob/living/simple_animal/hostile/retaliate/hermitcrab/Destroy()
	UnregisterSignal(src, list(COMSIG_MOB_HOLDER_DEPOSIT, COMSIG_MOB_HOLDER_RELEASE, COMSIG_MOB_HOLDER_EMBEDDED))
	. = ..()

/mob/living/simple_animal/hostile/retaliate/hermitcrab/proc/mob_holder_deposit(me, obj/item/clothing/head/mob_holder/m_holder)
	if(!istype(m_holder))
		return
	m_holder.grid_width = 64
	m_holder.grid_height = 64
	m_holder.sellprice = 15
	m_holder.embedding = list(
		"embed_chance" = 100,
		"embedded_pain_chance" = 25, // low pain chance for less chat spam
		"embedded_impact_pain_multiplier" = 12,
		"embedded_pain_multiplier" = 6,
		"embedded_unsafe_removal_time" = 3 SECONDS,
		"embedded_unsafe_removal_pain_multiplier" = 15, // whatever it's attached to is coming off with it
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,
		)
	m_holder.embedding = getEmbeddingBehavior(arglist(m_holder.embedding))
	if(istype(ai_controller))
		ai_controller.set_ai_status(AI_STATUS_OFF)

/mob/living/simple_animal/hostile/retaliate/hermitcrab/proc/mob_holder_release(me, obj/item/clothing/head/mob_holder/m_holder)
	if(!istype(m_holder))
		return
	if(istype(ai_controller))
		ai_controller.set_ai_status(ai_controller.get_expected_ai_status())

/mob/living/simple_animal/hostile/retaliate/hermitcrab/proc/mob_holder_embedded(me, obj/item/clothing/head/mob_holder/m_holder, mob/living/victim, obj/item/bodypart/bodypart)
	if(!istype(m_holder))
		return

	if((BODY_ZONE_PRECISE_GROIN in bodypart.subtargets) && prob(25 - victim.STALUC) && bodypart.try_crit("cbt", 250, src, zone_selected, crit_message = TRUE)) // should be about a 50% chance for the average individual on top of the previous chance
		if(!HAS_TRAIT(victim, TRAIT_NOPAIN))
			to_chat(victim, span_userdanger("MY GROIN!"))


/mob/living/simple_animal/hostile/retaliate/hermitcrab/death(gibbed)
	..()
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/hermitcrab/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	. += emissive_appearance(icon, "hermitcrab_eyes")

/mob/living/simple_animal/hostile/retaliate/hermitcrab/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/hermitcrab/AttackingTarget(mob/living/passed_target)
	. = ..()
	if(. && target && isturf(loc) && !get_active_held_item()) // if we're already a mob holder (somehow) don't do this
		var/obj/item/clothing/head/mob_holder/m_holder = new(get_turf(src), src)
		var/mob/living/L = target
		var/mob/living/carbon/C = target
		if(istype(C))
			C.get_bodypart(zone_selected)?.add_embedded_object(m_holder)
		else if(istype(L))
			L.simple_add_embedded_object(m_holder)
		if(!m_holder.is_embedded)
			m_holder.release(TRUE, TRUE)

/mob/living/simple_animal/hostile/retaliate/hermitcrab/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/obj/item/clothing/head/mob_holder/m_holder
	if(throwingdatum && isliving(hit_atom) && isturf(loc))
		m_holder = new(get_turf(src), src)
		throwingdatum.thrownthing = m_holder
	. = ..()
	if(m_holder && !m_holder.is_embedded)
		m_holder.release(TRUE, TRUE)

/mob/living/simple_animal/hostile/retaliate/hermitcrab/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/datum/intent/simple/crabpincer
	name = "pincer"
	icon_state = "instrike"
	attack_verb = list("crushes", "claws")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = "genchop"
	chargetime = 0
	penfactor = 10
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "slash"
	miss_text = "snaps at nothing!"
	miss_sound = PUNCHWOOSH
