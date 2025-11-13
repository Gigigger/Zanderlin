/mob/living/simple_animal/hostile/retaliate/hermitcrab
	icon = 'icons/roguetown/mob/monster/hermitcrab.dmi'
	name = "hermit crab"
	desc = ""
	icon_state = "hermitcrab"
	icon_living = "hermitcrab"
	icon_dead = "hermitcrab_dead"

	faction = list(FACTION_SEA)
	emote_hear = list("bubbles.")
	emote_see = list("filter-feeds.")
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
	transform = transform.Scale(0.75, 0.75)
	update_transform()
	RegisterSignal(src, COMSIG_LIVING_MOB_HOLDER_DEPOSIT, PROC_REF(mob_holder_deposit))
	RegisterSignal(src, COMSIG_LIVING_MOB_HOLDER_RELEASE, PROC_REF(mob_holder_release))

/mob/living/simple_animal/hostile/retaliate/hermitcrab/Destroy()
	UnregisterSignal(src, list(COMSIG_LIVING_MOB_HOLDER_DEPOSIT, COMSIG_LIVING_MOB_HOLDER_RELEASE))
	. = ..()

/mob/living/simple_animal/hostile/retaliate/hermitcrab/proc/mob_holder_deposit(mob/living/me, obj/item/clothing/head/mob_holder/m_holder)
	if(!istype(m_holder))
		return
	//ambush()
	m_holder.grid_width = 64
	m_holder.grid_height = 64
	m_holder.sellprice = 15
	m_holder.embedding = list(
		"embed_chance" = 100,
		"embedded_pain_chance" = 30,
		"embedded_pain_multiplier" = 6, //ouch!
		"embedded_unsafe_removal_time" = 3 SECONDS,
		"embedded_unsafe_removal_pain_multiplier" = 12, // iron grip
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,
		"clamp_limbs" = TRUE, // why not
	)
	m_holder.embedding = getEmbeddingBehavior(arglist(m_holder.embedding))
	if(istype(ai_controller))
		ai_controller.set_ai_status(AI_STATUS_OFF)

/mob/living/simple_animal/hostile/retaliate/hermitcrab/proc/mob_holder_release(mob/living/me, obj/item/clothing/head/mob_holder/m_holder)
	if(!istype(m_holder))
		return
	if(istype(ai_controller))
		ai_controller.set_ai_status(ai_controller.get_expected_ai_status())

/*
/mob/living/simple_animal/hostile/retaliate/hermitcrab/hide()
	if(!hiding)
		hiding = TRUE
		density = FALSE
		//icon_state = ""

/mob/living/simple_animal/hostile/retaliate/hermitcrab/ambush()
	if(hiding)
		hiding = FALSE
		density = TRUE
		//icon_state = icon_living
*/

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
	if(.)
	// note you can't latch if you're being held.
		if(iscarbon(target) && isturf(loc) && !get_active_held_item())
			var/mob/living/carbon/C = target
			var/obj/item/bodypart/BP = C.get_bodypart(zone_selected)
			var/obj/item/clothing/head/mob_holder/m_holder = new(get_turf(src), src)
			if(BP && !BP.is_object_embedded(m_holder) && BP.add_embedded_object(m_holder, TRUE))
				visible_message(span_danger("[src] latches onto [C]'s [zone_selected]!"))
			else
				// waste of processing power to make this for nothing, but this should only happen to things with godmode or pierce immunity
				qdel(m_holder)
	return .

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
