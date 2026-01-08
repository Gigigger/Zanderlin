//! Once we have actual nations this should be snapped away in favor of SSmerchants.nations[nation_type]
//! This is legit just to show what stuff is like

/datum/trade_agreement/test_request
	name = "I am Pibble"
	desc = "Wash my belly"

	possible_items = list(/obj/item/soap)
	picked_item_count = 1
	mammon_reward = 100

/datum/trade/iron_basics
	name = "Iron Basics"
	desc = "Basic iron equipment trade"
	min_imports = 5
	max_imports = 8
	supply_packs = list(
		/datum/supply_pack/armor/light/skullcap,
		/datum/supply_pack/armor/light/poth,
		/datum/supply_pack/armor/light/imask,
		/datum/supply_pack/armor/light/chaincoif_iron,
		/datum/supply_pack/armor/light/light_armor_boots
	)
	acceptable_imports = list(
		/obj/item/clothing/head/helmet/skullcap,
		/obj/item/clothing/head/helmet/ironpot,
		/obj/item/clothing/face/facemask,
		/obj/item/clothing/neck/chaincoif/iron,
		/obj/item/clothing/shoes/boots/armor/light
	)

/datum/trade/leather_start
	name = "Leather Goods"
	desc = "Leather armor and accessories"
	min_imports = 5
	max_imports = 8
	supply_packs = list(
		/datum/supply_pack/armor/light/lightleather_armor,
		/datum/supply_pack/armor/light/leather_bracers,
		/datum/supply_pack/armor/light/heavy_gloves
	)
	acceptable_imports = list(
		/obj/item/clothing/armor/leather,
		/obj/item/clothing/wrists/bracers/leather,
		/obj/item/clothing/gloves/angle
	)

/datum/trade/iron_advanced
	name = "Advanced Iron"
	desc = "Higher quality iron equipment"
	min_imports = 8
	max_imports = 12
	required_trades = list(/datum/trade/iron_basics, /datum/trade/leather_start)
	supply_packs = list(
		/datum/supply_pack/armor/light/splint,
		/datum/supply_pack/armor/light/studleather,
		/datum/supply_pack/armor/light/icuirass,
		/datum/supply_pack/armor/light/ihalf_plate,
		/datum/supply_pack/armor/light/ifull_plate,
		/datum/supply_pack/armor/light/chainmail_iron,
		/datum/supply_pack/armor/light/haukberk
	)
	acceptable_imports = list(
		/obj/item/clothing/armor/leather/splint,
		/obj/item/clothing/armor/leather/advanced,
		/obj/item/clothing/armor/cuirass/iron,
		/obj/item/clothing/armor/plate/iron,
		/obj/item/clothing/armor/plate/full/iron,
		/obj/item/clothing/armor/chainmail/iron,
		/obj/item/clothing/armor/chainmail/hauberk/iron
	)

/datum/trade/steel_start
	name = "Steel Equipment"
	desc = "Basic steel armor and weapons"
	min_imports = 10
	max_imports = 15
	required_trades = list(/datum/trade/iron_advanced)
	supply_packs = list(
		/datum/supply_pack/armor/steel/nasalh,
		/datum/supply_pack/armor/steel/sallet,
		/datum/supply_pack/armor/steel/buckethelm,
		/datum/supply_pack/armor/steel/smask,
		/datum/supply_pack/armor/steel/chaincoif_steel,
		/datum/supply_pack/armor/steel/cuirass,
		/datum/supply_pack/armor/steel/chainmail,
		/datum/supply_pack/armor/steel/chainmail_hauberk,
		/datum/supply_pack/armor/steel/steel_boots
	)
	acceptable_imports = list(
		/obj/item/clothing/head/helmet/nasal,
		/obj/item/clothing/head/helmet/sallet,
		/obj/item/clothing/head/helmet/heavy/bucket,
		/obj/item/clothing/face/facemask/steel,
		/obj/item/clothing/neck/chaincoif,
		/obj/item/clothing/armor/cuirass,
		/obj/item/clothing/armor/chainmail,
		/obj/item/clothing/armor/chainmail/hauberk,
		/obj/item/clothing/shoes/boots/armor
	)

/datum/trade/steel_advanced
	name = "Elite Steel"
	desc = "Premium steel equipment and rare items"
	min_imports = 12
	max_imports = 20
	required_trades = list(/datum/trade/steel_start)
	supply_packs = list(
		/datum/supply_pack/armor/steel/hounskull,
		/datum/supply_pack/armor/steel/visorsallet,
		/datum/supply_pack/armor/steel/elvenhelm,
		/datum/supply_pack/armor/steel/brigandine,
		/datum/supply_pack/armor/steel/coatofplates,
		/datum/supply_pack/armor/steel/half_plate,
		/datum/supply_pack/armor/steel/elvenplate,
		/datum/supply_pack/armor/steel/plate_gloves
	)
	acceptable_imports = list(
		/obj/item/clothing/head/helmet/visored/hounskull,
		/obj/item/clothing/head/helmet/visored/sallet,
		/obj/item/clothing/head/helmet/sallet/elven,
		/obj/item/clothing/armor/brigandine,
		/obj/item/clothing/armor/brigandine/coatplates,
		/obj/item/clothing/armor/plate,
		/obj/item/clothing/armor/cuirass/rare/elven,
		/obj/item/clothing/gloves/plate
	)

/datum/nation/debug_showcase
	nodes = list(
		/datum/trade/iron_basics,
		/datum/trade/leather_start,
		/datum/trade/iron_advanced,
		/datum/trade/steel_start,
		/datum/trade/steel_advanced
	)

	possible_trade_requests = list(/datum/trade_agreement/test_request)

/mob/proc/show_trade_showcase()
	var/datum/nation/debug_showcase/nation = new()
	nation.open_trade_ui(src)
