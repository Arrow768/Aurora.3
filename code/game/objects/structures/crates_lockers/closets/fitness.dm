/obj/structure/closet/athletic_mixed
	name = "athletic wardrobe"
	desc = "It's a storage unit for athletic wear."
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/athletic_mixed/fill()
	new /obj/item/towel/random(src)
	new /obj/item/towel/random(src)
	new /obj/item/clothing/under/shorts/grey(src)
	new /obj/item/clothing/under/shorts/black(src)
	new /obj/item/clothing/under/shorts/red(src)
	new /obj/item/clothing/under/shorts/blue(src)
	new /obj/item/clothing/under/shorts/green(src)
	new /obj/item/clothing/under/swimsuit/red(src)
	new /obj/item/clothing/under/swimsuit/black(src)
	new /obj/item/clothing/under/swimsuit/blue(src)
	new /obj/item/clothing/under/swimsuit/green(src)
	new /obj/item/clothing/under/swimsuit/purple(src)
	new /obj/item/clothing/mask/snorkel(src)
	new /obj/item/clothing/mask/snorkel(src)
	new /obj/item/clothing/shoes/swimmingfins(src)
	new /obj/item/clothing/shoes/swimmingfins(src)



/obj/structure/closet/boxinggloves
	name = "boxing gloves"
	desc = "It's a storage unit for gloves for use in the boxing ring."

/obj/structure/closet/boxinggloves/fill()
	new /obj/item/clothing/gloves/boxing/blue(src)
	new /obj/item/clothing/gloves/boxing/green(src)
	new /obj/item/clothing/gloves/boxing/yellow(src)
	new /obj/item/clothing/gloves/boxing(src)


/obj/structure/closet/masks
	name = "mask closet"
	desc = "IT'S A STORAGE UNIT FOR FIGHTER MASKS OLE!"

/obj/structure/closet/masks/fill()
	new /obj/item/clothing/mask/luchador(src)
	new /obj/item/clothing/mask/luchador/rudos(src)
	new /obj/item/clothing/mask/luchador/tecnicos(src)


/obj/structure/closet/lasertag/red
	name = "red laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/lasertag/red/fill()
	new /obj/item/gun/energy/lasertag/red(src)
	new /obj/item/gun/energy/lasertag/red(src)
	new /obj/item/clothing/suit/redtag(src)
	new /obj/item/clothing/suit/redtag(src)


/obj/structure/closet/lasertag/blue
	name = "blue laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/lasertag/blue/fill()
	new /obj/item/gun/energy/lasertag/blue(src)
	new /obj/item/gun/energy/lasertag/blue(src)
	new /obj/item/clothing/suit/bluetag(src)
	new /obj/item/clothing/suit/bluetag(src)
