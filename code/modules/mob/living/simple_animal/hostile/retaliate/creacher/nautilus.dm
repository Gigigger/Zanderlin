/mob/living/simple_animal/hostile/retaliate/nautilus
	icon = 'icons/roguetown/mob/monster/nautilus.dmi'
	name = "nautilus"
	desc = ""
	icon_state = "nautilus"
	icon_living = "nautilus"
	icon_dead = "nautilus_dead"
	SET_BASE_PIXEL(-16, 0)

	faction = list(FACTION_SEA)
	speak_emote = list("gurgles", "bubbles")
	emote_see = list("writhes its tentacles")
	emote_hear = list("gurgles wetly", "makes bubbling sounds")
	see_in_dark = 9
	move_to_delay = 2
	vision_range = 9
	aggro_vision_range = 9

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/natural/fur/volf = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/natural/fur/volf = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/fur/volf = 3,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 2)
	head_butcher = /obj/item/natural/head/volf

	armor = 12
	health = 500
	maxHealth = 500
	food_type = list(/obj/item/reagent_containers/food/snacks/meat/mince,
					/obj/item/reagent_containers/food/snacks/fish,
					/obj/item/organ)

	base_intents = list(/datum/intent/simple/nautilus_lash)
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	melee_damage_lower = 20
	melee_damage_upper = 30

	base_constitution = 14
	base_strength = 12
	base_speed = 6
	force_threshold = 15

	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 15
	defdrain = 10
	del_on_deaggro = 999 SECONDS
	retreat_health = 0

	dodgetime = 50
	aggressive = 1
	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/nautilus
	body_eater = TRUE

	//buckle_lying = TRUE
	//max_buckled_mobs = 4

	ai_controller = /datum/ai_controller/nautilus
	dendor_taming_chance = DENDOR_TAME_PROB_NONE

	var/wrestling_bonus = SKILL_LEVEL_JOURNEYMAN

/mob/living/simple_animal/hostile/retaliate/nautilus/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

	gender = MALE
	if(prob(50))
		gender = FEMALE
	update_appearance(UPDATE_OVERLAYS)
	ADD_TRAIT(src, TRAIT_NOHANDGRABS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONG_GRABBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_GOOD_SWIM, TRAIT_GENERIC)


/mob/living/simple_animal/hostile/retaliate/nautilus/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/idle (3).ogg','sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/nautilus/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/nautilus/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "eyestalk"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "eyestalk"
		if(BODY_ZONE_PRECISE_NOSE)
			return "beak"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "beak"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "body"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "tentacles"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "tentacles"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "tentacles"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "tentacles"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "body"
		if(BODY_ZONE_PRECISE_GROIN)
			return "body"
		if(BODY_ZONE_HEAD)
			return "beak"
		if(BODY_ZONE_R_LEG)
			return "tentacles"
		if(BODY_ZONE_L_LEG)
			return "tentacles"
		if(BODY_ZONE_R_ARM)
			return "tentacles"
		if(BODY_ZONE_L_ARM)
			return "tentacles"
	return ..()

/mob/living/simple_animal/hostile/retaliate/nautilus/get_wrestling_bonuses()
	return wrestling_bonus

/datum/intent/simple/nautilus_lash
	name = "tendril lash"
	icon_state = "inlash"
	attack_verb = list("lashes", "whips")
	animname = "slash"
	blade_class = BCLASS_LASHING
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 5
	canparry = FALSE
	item_damage_type = "slash"


/obj/effect/decal/remains/nautilus
	icon_state = "nautilus_dead"
	icon = 'icons/roguetown/mob/monster/nautilus.dmi'
