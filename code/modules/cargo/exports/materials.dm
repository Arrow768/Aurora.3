/datum/export/material
	cost = 5 // Cost per MINERAL_MATERIAL_AMOUNT, which is 2000cm3 as of April 2016.
	message = "cm3 of developer's tears. Please, report this on github"
	var/material_id = null
	export_types = list(/obj/item/stack/material/titanium)
// Yes, it's a base type containing export_types.
// But it has no material_id, so any applies_to check will return false, and these types reduce amount of copypasta a lot

/datum/export/material/get_amount(obj/O)
	if(!material_id)
		return 0
	var/obj/item/stack/material/M = O
	if(!M || M.material.name != material_id)
		return 0

	return M.amount

// Materials. Nothing but plasma is really worth selling. Better leave it all to RnD and sell some plasma instead.

/datum/export/material/diamond
	cost = 500
	material_id = "diamond"
	message = "diamond sheets"

/datum/export/material/phoron
	cost = 200
	k_elasticity = 0
	material_id = "phoron"
	message = "phoron sheets"

/datum/export/material/uranium
	cost = 100
	material_id = "uranium"
	message = "uranium sheets"

/datum/export/material/gold
	cost = 125
	material_id = "gold"
	message = "gold sheets"

/datum/export/material/silver
	cost = 50
	material_id = "silver"
	message = "silver sheets"

/datum/export/material/titanium
	cost = 125
	material_id = "titanium"
	message = "titanium sheets"

/datum/export/material/metal
	cost = 5
	message = "metal sheets"
	material_id = "metal"


/datum/export/material/glass
	cost = 5
	message = "glass sheets"
	material_id = "glass"

