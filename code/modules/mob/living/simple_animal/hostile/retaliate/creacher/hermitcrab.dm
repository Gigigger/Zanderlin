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

	health = 50
	maxHealth = 50

	base_intents = list(/datum/intent/simple/crabpincer)
	attack_sound = 'sound/combat/wooshes/punch/punchwoosh (2).ogg'
	melee_damage_lower = 12
	melee_damage_upper = 14

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

	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_appearance(UPDATE_OVERLAYS)

	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)


/mob/living/simple_animal/hostile/retaliate/hermitcrab/hide()
	if(!hiding)
		hiding = TRUE
		density = FALSE
		icon_state = ""

/mob/living/simple_animal/hostile/retaliate/hermitcrab/ambush()
	if(hiding)
		hiding = FALSE
		density = TRUE
		icon_state = icon_living

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
	attack_verb = list("crushes", "pinces")
	animname = "smash"
	blade_class = BCLASS_SMASH
	hitsound = "punch_hard"
	chargetime = 0
	penfactor = 10
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "blunt"
	miss_text = "snaps at nothing!"
	miss_sound = PUNCHWOOSH
