/*
Alright boys, Firing pins. hopefully with minimal shitcode.
"pin_auth(mob/living/user)" is the check to see if it fires, put the snowflake code here. return one to fire, zero to flop. ezpz

Firing pins as a rule can't be removed without replacing them, blame a really shitty mechanism for it by NT or something idk, this is to stop people from just taking pins from like a capgun or something.
*/

/obj/item/device/firing_pin
	name = "electronic firing pin"
	desc = "A small authentication device, to be inserted into a firearm receiver to allow operation. NT safety regulations require all new designs to incorporate one."
	icon = 'icons/obj/firingpins.dmi'
	icon_state = "firing_pin"
	item_state = "pen"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	flags = CONDUCT
	w_class = 1
	attack_verb = list("poked")
	var/emagged = FALSE
	var/fail_message = "<span class='warning'>INVALID USER.</span>"
	var/selfdestruct = 0 // Explode when user check is failed.
	var/force_replace = 0 // Can forcefully replace other pins.
	var/pin_replaceable = 0 // Can be replaced by any pin.
	var/durable = FALSE //is destroyed when it's pried out with a screwdriver, see gun.dm
	var/obj/item/gun/gun
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

/obj/item/device/firing_pin/Initialize(mapload)
	.=..()
	if(istype(loc, /obj/item/gun))
		gun = loc

/obj/item/device/firing_pin/afterattack(atom/target, mob/user, proximity_flag)
	if(proximity_flag)
		if(istype(target, /obj/item/gun))
			var/obj/item/gun/G = target
			if(G.pin && (force_replace || G.pin.pin_replaceable))
				G.pin.forceMove(get_turf(G))
				G.pin.gun_remove(user)
				to_chat(user, "<span class ='notice'>You remove [G]'s old pin.</span>")

			if(!G.pin)
				gun_insert(user, G)
				to_chat(user, "<span class ='notice'>You insert [src] into [G].</span>")
			else
				to_chat(user, "<span class ='notice'>This firearm already has a firing pin installed.</span>")

/obj/item/device/firing_pin/emag_act(mob/user)
	if(!emagged)
		emagged = TRUE
		to_chat(user, "<span class='notice'>You override the authentication mechanism.</span>")

/obj/item/device/firing_pin/proc/gun_insert(mob/living/user, obj/item/gun/G)
	gun = G
	user.drop_from_inventory(src,gun)
	gun.pin = src
	return

/obj/item/device/firing_pin/proc/gun_remove(mob/living/user)
	gun.pin = null
	gun = null
	qdel(src)
	return

/obj/item/device/firing_pin/proc/pin_auth(mob/living/user)
	return 1

/obj/item/device/firing_pin/proc/auth_fail(mob/living/carbon/human/user)
	user.show_message(fail_message, 1)
	if(selfdestruct)//sound stolen from the lawgiver. todo, remove this from the lawgiver. there can only be one.
		user.show_message("<span class='danger'>SELF-DESTRUCTING...</span><br>", 1)
		visible_message("<span class='danger'>\The [gun] explodes!</span>")
		playsound(user, 'sound/weapons/lawgiver_idfail.ogg', 40, 1)
		var/obj/item/organ/external/E = user.organs_by_name[user.hand ? BP_L_HAND : BP_R_HAND]
		E.droplimb(0,DROPLIMB_BLUNT)
		explosion(get_turf(gun), -1, 0, 2, 3)
		if(gun)
			qdel(gun)

/*
Pins Below.
*/

//only used in wizard staffs/wands.
/obj/item/device/firing_pin/magic
	name = "magic crystal shard"
	desc = "A small enchanted shard which allows magical weapons to fire."
	icon_state = "firing_pin_wizwoz"

// Test pin, works only near firing ranges.
/obj/item/device/firing_pin/test_range
	name = "test-range firing pin"
	desc = "This safety firing pin allows weapons to be fired within proximity to a firing range."
	fail_message = "<span class='warning'>TEST RANGE CHECK FAILED.</span>"
	pin_replaceable = 1
	durable = TRUE
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)

/obj/item/device/firing_pin/test_range/pin_auth(mob/living/user)
	var/area/A = get_area(src)
	if (A && (A.flags & FIRING_RANGE))
		return 1
	else
		return 0

// Implant pin, checks for implant
/obj/item/device/firing_pin/implant
	name = "implant-keyed firing pin"
	desc = "This is a implant-locked firing pin which only authorizes users who are implanted with a certain device."
	fail_message = "<span class='warning'>IMPLANT CHECK FAILED.</span>"
	var/req_implant

/obj/item/device/firing_pin/implant/pin_auth(mob/living/user)
	if (locate(req_implant) in user)
		return 1
	else
		return 0

/obj/item/device/firing_pin/implant/loyalty
	name = "mind shield firing pin"
	desc = "This implant-locked firing pin authorizes the weapon for only mind shielded users."
	icon_state = "firing_pin_loyalty"
	req_implant = /obj/item/implant/mindshield

// Honk pin, clown joke item.
// Can replace other pins. Replace a pin in cap's laser for extra fun! This is generally adminbus only unless someone thinks of a use for it.
/obj/item/device/firing_pin/clown
	name = "hilarious firing pin"
	desc = "Advanced clowntech that can convert any firearm into a far more useful object."
	color = "#FFFF00"
	fail_message = "<span class='warning'>HONK!</span>"
	force_replace = 1

/obj/item/device/firing_pin/clown/pin_auth(mob/living/user)
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
	return 0

// DNA-keyed pin.
// When you want to keep your toys for youself.
/obj/item/device/firing_pin/dna
	name = "DNA-keyed firing pin"
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link."
	icon_state = "firing_pin_dna"
	fail_message = "<span class='warning'>DNA CHECK FAILED.</span>"
	var/unique_enzymes = null

/obj/item/device/firing_pin/dna/afterattack(atom/target, mob/user, proximity_flag)
	..()
	if(proximity_flag && iscarbon(target))
		var/mob/living/carbon/M = target
		if(M.dna && M.dna.unique_enzymes)
			unique_enzymes = M.dna.unique_enzymes
			to_chat(user, "<span class='notice'>DNA-LOCK SET.</span>")

/obj/item/device/firing_pin/dna/pin_auth(mob/living/carbon/user)
	if(istype(user) && user.dna && user.dna.unique_enzymes)
		if(user.dna.unique_enzymes == unique_enzymes)
			return 1

	return 0

/obj/item/device/firing_pin/dna/auth_fail(mob/living/carbon/user)
	if(!unique_enzymes)
		if(istype(user) && user.dna && user.dna.unique_enzymes)
			unique_enzymes = user.dna.unique_enzymes
			to_chat(user, "<span class='notice'>DNA-LOCK SET.</span>")
	else
		..()

/obj/item/device/firing_pin/dna/dredd
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link. It has a small explosive charge on it."
	selfdestruct = 1


// Laser tag pins
/obj/item/device/firing_pin/tag
	name = "laser tag firing pin"
	desc = "A recreational firing pin, used in laser tag units to ensure users have their vests on."
	fail_message = "<span class='warning'>SUIT CHECK FAILED.</span>"
	var/obj/item/clothing/suit/suit_requirement = null
	var/tagcolor = ""

/obj/item/device/firing_pin/tag/pin_auth(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/M = user
		if(istype(M.wear_suit, suit_requirement))
			return 1
	to_chat(user, "<span class='warning'>You need to be wearing [tagcolor] laser tag armor!</span>")
	return 0

/obj/item/device/firing_pin/tag/red
	name = "red laser tag firing pin"
	icon_state = "firing_pin_red"
	suit_requirement = /obj/item/clothing/suit/redtag
	tagcolor = "red"

/obj/item/device/firing_pin/tag/blue
	name = "blue laser tag firing pin"
	icon_state = "firing_pin_blue"
	suit_requirement = /obj/item/clothing/suit/bluetag
	tagcolor = "blue"

/obj/item/device/firing_pin/Destroy()
	if(gun)
		gun.pin = null
	return ..()

//this firing pin checks for access
/obj/item/device/firing_pin/access
	name = "access-keyed firing pin"
	desc = "This access locked firing pin allows weapons to be fired only when the user has the required access."
	fail_message = "<span class='warning'>ACCESS CHECK FAILED.</span>"
	req_access = list(access_weapons)

/obj/item/device/firing_pin/access/pin_auth(mob/living/user)
	return !allowed(user)

/obj/item/device/firing_pin/away_site
	name = "away site firing pin"
	desc = "This access locked firing pin allows weapons to be fired only when the user is not on-station."
	fail_message = "<span class='warning'>USER ON STATION LEVEL.</span>"

/obj/item/device/firing_pin/away_site/pin_auth(mob/living/user)
	var/turf/T = get_turf(src)
	return !isStationLevel(T.z)

var/list/wireless_firing_pins = list() //A list of all initialized wireless firing pins. Used in the firearm tracking console in guntracker.dm

/obj/item/device/firing_pin/wireless
	name = "security level firing pin"
	desc = "This security level locked firing pin allows weapons to be fired only when the security level is elevated."
	fail_message = "<span class='warning'>SECURITY LEVEL INSUFFICIENT.</span>"
	var/registered_user = "Unregistered"
	var/lockstatus = WIRELESS_PIN_AUTOMATIC

/obj/item/device/firing_pin/wireless/Initialize() //Adds wireless pins to the list of initialized wireless firing pins.
	wireless_firing_pins += src
	return ..()

/obj/item/device/firing_pin/wireless/Destroy() //Removes the wireless pins from the list of initialized wireless firing pins.
	wireless_firing_pins -= src
	return ..()

/obj/item/device/firing_pin/wireless/pin_auth(mob/living/user)
	if(lockstatus != WIRELESS_PIN_DISABLED) // If it's disabled it's disabled. No shooting on any mode.
		if(istype(gun, /obj/item/gun/energy)) //Only energy weapons can be fired on stun.
			var/obj/item/gun/energy/thegun = gun
			var/obj/item/projectile/energy/P = new thegun.projectile_type
			if(P?.taser_effect) // We've already checked whether it's disabled, and no other lockstatus excludes stun.
				return TRUE
			if(security_level != SEC_LEVEL_GREEN && security_level != SEC_LEVEL_BLUE && lockstatus == WIRELESS_PIN_STUN) // We're on elevated alert, but the gun has been manually set to only allow stun.
				if(!P?.taser_effect) // Check if we're not shooting a stun effect.
					return FALSE

		if(security_level != SEC_LEVEL_GREEN && security_level != SEC_LEVEL_BLUE && lockstatus != WIRELESS_PIN_STUN) // If there's an elevated alert and the lockstatus isn't on stun.
			return TRUE
	return FALSE

/obj/item/device/firing_pin/wireless/proc/register_user(obj/item/card/id/C, mob/living/user)//Registers users as the owner of the wireless pin.
	if(C.registered_name == registered_user)
		to_chat(user, SPAN_NOTICE("You press your ID against the RFID reader and it deregisters your identity."))
		registered_user = "Unregistered"
		return
	to_chat(user, SPAN_NOTICE("You press your ID against the RFID reader and it chimes as it registers your identity."))
	registered_user = C.registered_name
	return

/obj/item/device/firing_pin/wireless/proc/unlock(var/i) // Changes the current allowed firestates of the weapon.
	var/mob/living/user
	if(ismob(loc.loc))
		user = loc.loc // pin -> gun -> user
	else
		user = loc.loc.loc // pin -> gun -> holster/bag/etc -> user

	if(i == lockstatus)
		return

	if(i == WIRELESS_PIN_AUTOMATIC)
		playsound(user, 'sound/weapons/laser_safetyon.ogg')
		to_chat(user, SPAN_NOTICE("<b>\The [gun]'s wireless firing pin is now set to automatic.</b>"))
		lockstatus = WIRELESS_PIN_AUTOMATIC

	if(i == WIRELESS_PIN_DISABLED)
		playsound(user, 'sound/weapons/laser_safetyoff.ogg')
		to_chat(user, SPAN_NOTICE("<b>\The [gun]'s wireless firing pin deactivates.</b>"))
		lockstatus = WIRELESS_PIN_DISABLED

	if(i == WIRELESS_PIN_STUN)
		playsound(user, 'sound/weapons/laser_safetyon.ogg')
		to_chat(user, SPAN_NOTICE("<b>\The [gun]'s wireless firing pin is now set to stun only.</b>"))
		lockstatus = WIRELESS_PIN_STUN

	if(i == WIRELESS_PIN_LETHAL)
		playsound(user, 'sound/weapons/laser_safetyon.ogg')
		to_chat(user, SPAN_NOTICE("<b>\The [gun]'s wireless firing pin is now unrestricted.</b>"))
		lockstatus = WIRELESS_PIN_LETHAL
	return

/obj/item/device/firing_pin/wireless/attackby(obj/item/C as obj, mob/user as mob) //Lets people register their IDs to the pin.
	if(istype(C, /obj/item/card/id))
		register_user(C, user)
		return
	return . = ..()