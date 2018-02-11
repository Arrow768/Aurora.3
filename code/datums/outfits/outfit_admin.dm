// Used for 'select equipment'
// code/modules/admin/verbs/debug.dm 566

/proc/apply_to_card(obj/item/weapon/card/id/I, mob/living/carbon/human/H, list/access = list(), rank, special_icon)
    if(!istype(I) || !istype(H))
        return 0

    I.access = access
    I.registered_name = H.real_name
    I.rank = rank
    I.assignment = rank
    I.sex = capitalize(H.gender)
    I.age = H.age
    I.name = "[I.registered_name]'s ID Card ([I.assignment])"

    if(special_icon)
        I.icon_state = special_icon

/datum/outfit/admin
/datum/outfit/admin/spacegear
    name = "Standard Space Gear"

    uniform = /obj/item/clothing/under/color/grey
    suit = /obj/item/clothing/suit/space
    back = /obj/item/weapon/tank/jetpack/oxygen
    shoes = /obj/item/clothing/shoes/black
    head = /obj/item/clothing/head/helmet/space
    mask = /obj/item/clothing/mask/breath
    l_ear = /obj/item/device/radio/headset
    id = /obj/item/weapon/card/id

/datum/outfit/admin/spacegear/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    if(istype(H.back, /obj/item/weapon/tank/jetpack))
        var/obj/item/weapon/tank/jetpack/J = H.back
        J.toggle()

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_all_accesses(), "Space Explorer")

/datum/outfit/admin/tournament
    suit = /obj/item/clothing/suit/armor/vest
    shoes = /obj/item/clothing/shoes/black
    head = /obj/item/clothing/head/helmet/thunderdome
    r_pocket = /obj/item/weapon/grenade/smokebomb
    l_hand = /obj/item/weapon/material/knife
    r_hand = /obj/item/weapon/gun/energy/rifle/pulse/destroyer

/datum/outfit/admin/tournament/red
    name = "Tournament Standard Red"
    uniform = /obj/item/clothing/under/color/red

/datum/outfit/admin/tournament/green
    name = "Tournament Standard Green"
    uniform = /obj/item/clothing/under/color/green

/datum/outfit/admin/tournament_gangster //gangster are supposed to fight each other. --rastaf0
    name = "Tournament Gangster"

    uniform = /obj/item/clothing/under/det
    suit = /obj/item/clothing/under/det
    shoes = /obj/item/clothing/shoes/black
    head = /obj/item/clothing/head/det
    glasses = /obj/item/clothing/glasses/thermal/plain/monocle
    l_pocket = /obj/item/ammo_magazine/a357
    r_hand = /obj/item/weapon/gun/projectile/revolver

/datum/outfit/admin/tournament_chef //Steven Seagal FTW
    name = "Tournament Chef"

    uniform = /obj/item/clothing/under/rank/chef
    suit = /obj/item/clothing/suit/chef
    shoes = /obj/item/clothing/shoes/black
    head = /obj/item/clothing/head/chefhat
    l_pocket = /obj/item/weapon/material/knife
    r_pocket = /obj/item/weapon/material/knife
    l_hand = /obj/item/weapon/material/knife
    r_hand = /obj/item/weapon/material/kitchen/rollingpin

/datum/outfit/admin/tournament_janitor
    name = "Tournament Janitor"

    uniform = /obj/item/clothing/under/rank/janitor
    back = /obj/item/weapon/storage/backpack
    shoes = /obj/item/clothing/shoes/black
    l_hand = /obj/item/weapon/reagent_containers/glass/bucket
    r_hand = /obj/item/weapon/mop
    l_pocket = /obj/item/weapon/grenade/chem_grenade/cleaner
    r_pocket = /obj/item/weapon/grenade/chem_grenade/cleaner
    backpack_contents = list(
        /obj/item/weapon/grenade/chem_grenade/cleaner = 2,
        /obj/item/stack/tile/floor = 7
    )

/datum/outfit/admin/tournament_janitor/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/reagent_containers/R = H.l_hand
    if(istype(R))
        R.reagents.add_reagent("water", 70)



/datum/outfit/admin/pirate
    name = "Pirate"

    uniform = /obj/item/clothing/under/pirate
    back = /obj/item/weapon/storage/backpack/satchel
    shoes = /obj/item/clothing/shoes/brown
    head = /obj/item/clothing/head/bandana
    glasses = /obj/item/clothing/glasses/eyepatch
    id = /obj/item/weapon/card/id
    r_hand = /obj/item/weapon/melee/energy/sword/pirate
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1
    )

/datum/outfit/admin/pirate/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, list(access_maint_tunnels), "Pirate")

/datum/outfit/admin/pirate/space
    name = "Space Pirate"

    suit = /obj/item/clothing/suit/space/pirate
    head = /obj/item/clothing/head/helmet/space/pirate

/datum/outfit/admin/pirate/space/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..(H, TRUE)
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, list(access_maint_tunnels), "Space Pirate")



/datum/outfit/admin/tunnel_clown
    name = "Tunnel Clown"

    uniform = /obj/item/clothing/under/rank/clown
    suit = /obj/item/clothing/suit/chaplain_hoodie
    back = /obj/item/weapon/storage/backpack
    belt = /obj/item/weapon/storage/belt/utility/full
    gloves = /obj/item/clothing/gloves/black
    shoes = /obj/item/clothing/shoes/clown_shoes
    mask = /obj/item/clothing/mask/gas/clown_hat
    l_ear = /obj/item/device/radio/headset
    glasses = /obj/item/clothing/glasses/thermal/plain/monocle
    id = /obj/item/weapon/card/id
    l_pocket = /obj/item/weapon/reagent_containers/food/snacks/grown/banana
    r_pocket = /obj/item/weapon/bikehorn
    r_hand = /obj/item/weapon/material/twohanded/fireaxe
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1,
        /obj/item/device/flashlight = 1
    )

/datum/outfit/admin/tunnel_clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, list(access_maint_tunnels), "Tunnel Clown")

/datum/outfit/admin/survivor
    name = "Survivor"

    uniform = /obj/item/clothing/under/overalls
    back = /obj/item/weapon/storage/backpack
    gloves = /obj/item/clothing/gloves/latex
    shoes = /obj/item/clothing/shoes/white
    l_ear = /obj/item/device/radio/headset
    id = /obj/item/weapon/card/id
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1
    )

/datum/outfit/admin/survivor/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()

    for(var/obj/item/I in H.contents)
        if(!istype(I, /obj/item/weapon/implant))
            I.add_blood(H)

    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, list(access_maint_tunnels), "Survivor")



/datum/outfit/admin/greytide
    name = "Greytide"

    uniform = /obj/item/clothing/under/color/grey
    back = /obj/item/weapon/storage/backpack
    shoes = /obj/item/clothing/shoes/brown
    mask = /obj/item/clothing/mask/gas
    l_ear = /obj/item/device/radio/headset
    id = /obj/item/weapon/card/id
    l_hand = /obj/item/weapon/storage/toolbox/mechanical
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1,
        /obj/item/device/flashlight = 1
    )

/datum/outfit/admin/greytide/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, list(access_maint_tunnels), "Greytide")

/datum/outfit/admin/greytide/leader
    name = "Greytide Leader"

    belt = /obj/item/weapon/storage/belt/utility/full
    gloves = /obj/item/clothing/gloves/yellow

    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1,
        /obj/item/clothing/head/welding = 1,
        /obj/item/device/flashlight = 1
    )

/datum/outfit/admin/greytide/leader/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..(H, TRUE)
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, list(access_maint_tunnels), "Greytide Leader")

/datum/outfit/admin/greytide/xeno
    name = "Greytide Xeno"

    uniform = /obj/item/clothing/under/color/black
    suit = /obj/item/clothing/suit/xenos
    back = /obj/item/weapon/storage/backpack/satchel
    belt = /obj/item/weapon/storage/belt/utility/full
    gloves = /obj/item/clothing/gloves/yellow
    shoes = /obj/item/clothing/shoes/black
    head = /obj/item/clothing/head/xenos
    glasses = /obj/item/clothing/glasses/thermal
    l_pocket = /obj/item/weapon/tank/emergency_oxygen/double
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1,
        /obj/item/clothing/head/welding = 1,
        /obj/item/device/flashlight = 1
    )

/datum/outfit/admin/greytide/xeno/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..(H, TRUE)
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, list(access_maint_tunnels), "Legit Xenomorph")



/datum/outfit/admin/masked_killer
    name = "Masked Killer"

    uniform = /obj/item/clothing/under/overalls
    suit = /obj/item/clothing/suit/apron
    back = /obj/item/weapon/storage/backpack
    gloves = /obj/item/clothing/gloves/latex
    shoes = /obj/item/clothing/shoes/white
    head = /obj/item/clothing/head/welding
    mask = /obj/item/clothing/mask/surgical
    l_ear = /obj/item/device/radio/headset
    glasses = /obj/item/clothing/glasses/thermal/plain/monocle
    id = /obj/item/weapon/card/id/syndicate
    l_pocket = /obj/item/weapon/material/knife
    r_pocket = /obj/item/weapon/scalpel
    r_hand = /obj/item/weapon/material/twohanded/fireaxe
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1,
        /obj/item/device/flashlight = 1
    )

/datum/outfit/admin/masked_killer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()

    for(var/obj/item/I in H.contents)
        if(!istype(I, /obj/item/weapon/implant))
            I.add_blood(H)

    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, list(access_maint_tunnels), "Masked Killer", "syndie")



/datum/outfit/admin/dark_lord
    name = "Dark Lord"

    uniform = /obj/item/clothing/under/color/black
    suit = /obj/item/clothing/head/chaplain_hood
    back = /obj/item/weapon/storage/backpack
    gloves = /obj/item/clothing/gloves/black
    shoes = /obj/item/clothing/shoes/black
    l_ear = /obj/item/device/radio/headset/syndicate
    id = /obj/item/weapon/card/id/syndicate
    l_hand = /obj/item/weapon/melee/energy/sword
    r_hand = /obj/item/weapon/melee/energy/sword
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1,
        /obj/item/device/flashlight = 1,
    )

/datum/outfit/admin/dark_lord/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/clothing/head/chaplain_hood/C = H.wear_suit
    if(istype(C))
        C.name = "dark lord robes"

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_all_accesses(), "Dark Lord", "syndie")



/datum/outfit/admin/assassin
    name = "Assassin"

    uniform = /obj/item/clothing/under/suit_jacket
    suit = /obj/item/clothing/suit/wcoat
    back = /obj/item/weapon/storage/backpack
    gloves = /obj/item/clothing/gloves/black
    shoes = /obj/item/clothing/shoes/black
    l_ear = /obj/item/device/radio/headset/syndicate
    glasses = /obj/item/clothing/glasses/sunglasses
    id = /obj/item/weapon/card/id/syndicate
    l_pocket = /obj/item/weapon/melee/energy/sword
    r_pocket = /obj/item/device/pda/heads
    l_hand = /obj/item/weapon/storage/secure/briefcase
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1,
        /obj/item/device/flashlight = 1
    )

    var/briefcase_contents = list(
        /obj/item/weapon/spacecash/c1000 = 3,
        /obj/item/weapon/gun/energy/crossbow = 1,
        /obj/item/weapon/gun/projectile/revolver/mateba = 1,
        /obj/item/ammo_magazine/a357 = 1,
        /obj/item/weapon/plastique = 1
    )

/datum/outfit/admin/assassin/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/storage/secure/briefcase/B = H.l_hand
    if(istype(B))
        for(var/obj/item/I in B)
            qdel(I)
        for(var/path in briefcase_contents)
            var/number = backpack_contents[path]
            for(var/i = 0, i < number, i++)
                B.handle_item_insertion(new path(B), 1)

    //var/obj/item/weapon/implant/dust/D = new /obj/item/weapon/implant/dust(H)
   // D.implant(H)

    var/obj/item/device/pda/PDA = H.get_equipped_item(slot_r_store)
    if(istype(PDA))
        PDA.owner = H.real_name
        PDA.ownjob = "Reaper"
        PDA.name = "PDA-[H.real_name] ([PDA.ownjob])"

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_all_station_access(), "Reaper", "syndie")



/datum/outfit/admin/spy
    name = "Spy"

    uniform = /obj/item/clothing/under/suit_jacket/really_black
    back = /obj/item/weapon/storage/backpack
    gloves = /obj/item/clothing/gloves/combat
    shoes = /obj/item/clothing/shoes/black
    l_ear = /obj/item/device/radio/headset/syndicate
    glasses = /obj/item/clothing/glasses/sunglasses
    id = /obj/item/weapon/card/id/syndicate
    l_pocket = /obj/item/weapon/melee/energy/sword
    r_pocket = /obj/item/device/pda/heads
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1,
        /obj/item/weapon/storage/box/syndie_kit/g9mm = 1,
        /obj/item/weapon/card/emag = 1,
        /obj/item/device/flashlight = 1,
        /obj/item/weapon/pen/reagent/paralysis = 1
    )

/datum/outfit/admin/spy/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/clothing/gloves/combat/G = H.gloves
    if(istype(G))
        G.name = "black gloves"

    //var/obj/item/weapon/implant/dust/D = new /obj/item/weapon/implant/dust(H)
    //D.implant(H)

    var/obj/item/device/pda/PDA = H.get_equipped_item(slot_r_store)
    if(istype(PDA))
        PDA.owner = H.real_name
        PDA.ownjob = "Spy"
        PDA.name = "PDA-[H.real_name] ([PDA.ownjob])"

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, list(access_maint_tunnels), "Spy", "syndie")


/datum/outfit/admin/death_commando
    name = "Death Commando"

/datum/outfit/admin/death_commando/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    return deathsquad.equip(H)


/datum/outfit/admin/syndicate
    name = "Syndicate Agent"

    uniform = /obj/item/clothing/under/syndicate
    back = /obj/item/weapon/storage/backpack
    belt = /obj/item/weapon/storage/belt/utility/full
    gloves = /obj/item/clothing/gloves/combat
    shoes = /obj/item/clothing/shoes/combat
    l_ear = /obj/item/device/radio/headset/syndicate
    id = /obj/item/weapon/card/id/syndicate
    r_pocket = /obj/item/device/radio/uplink
    backpack_contents = list(
        /obj/item/weapon/storage/box/engineer = 1,
        /obj/item/device/flashlight = 1,
        /obj/item/weapon/card/emag = 1
    )

    var/id_icon = "syndie"
    var/uplink_uses = 20

/datum/outfit/admin/syndicate/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_all_station_access(), name, id_icon)

    var/obj/item/device/radio/uplink/U = H.r_store
    if(istype(U))
        U.hidden_uplink.uplink_owner = "[H.key]"
        U.hidden_uplink.uses = uplink_uses

    var/obj/item/device/radio/R = H.l_ear
    if(istype(R))
        R.set_frequency(SYND_FREQ)

/datum/outfit/admin/syndicate_strike_team
    name = "Syndicate Strike Team"

/datum/outfit/admin/syndicate_strike_team/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    commandos.equip(H)


/datum/outfit/admin/nt_vip
    name = "NT VIP Guest"

    uniform = /obj/item/clothing/under/suit_jacket/really_black
    back = /obj/item/weapon/storage/backpack/satchel
    gloves = /obj/item/clothing/gloves/black
    shoes = /obj/item/clothing/shoes/black
    head = /obj/item/clothing/head/that
    l_ear = /obj/item/device/radio/headset/ert
    id = /obj/item/weapon/card/id/centcom
    r_pocket = /obj/item/device/pda
    backpack_contents = list(
        /obj/item/weapon/storage/box/engineer = 1
    )

/datum/outfit/admin/nt_vip/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_centcom_access("VIP Guest"), "VIP Guest")

/datum/outfit/admin/nt_navy_officer
    name = "NT Navy Officer"

    uniform = /obj/item/clothing/under/rank/centcom_officer
    back = /obj/item/weapon/storage/backpack/satchel
    belt = /obj/item/weapon/gun/energy/pulse/pistol
    gloves = /obj/item/clothing/gloves/white
    shoes = /obj/item/clothing/shoes/laceup
    head = /obj/item/clothing/head/beret/centcom/officer
    l_ear = /obj/item/device/radio/headset/heads/captain
    glasses = /obj/item/clothing/glasses/sunglasses
    id = /obj/item/weapon/card/id/centcom
    r_pocket = /obj/item/device/pda/heads
    backpack_contents = list(
        /obj/item/weapon/storage/box/engineer = 1
    )

/datum/outfit/admin/nt_navy_officer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Officer"), "Nanotrasen Navy Officer")

    var/obj/item/weapon/implant/L = new /obj/item/weapon/implant/loyalty(H)
    L.imp_in = H
    L.implanted = 1

/datum/outfit/admin/nt_navy_captain
    name = "NT Navy Captain"

    uniform = /obj/item/clothing/under/rank/centcom_captain
    back = /obj/item/weapon/storage/backpack/satchel
    belt = /obj/item/weapon/gun/energy/pistol
    gloves = /obj/item/clothing/gloves/white
    shoes = /obj/item/clothing/shoes/laceup
    head = /obj/item/clothing/head/beret/centcom/captain
    l_ear = /obj/item/device/radio/headset/heads/captain
    glasses = /obj/item/clothing/glasses/sunglasses
    id = /obj/item/weapon/card/id/centcom
    r_pocket = /obj/item/device/pda/heads
    backpack_contents = list(
        /obj/item/weapon/storage/box/engineer = 1
    )

/datum/outfit/admin/nt_navy_captain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_centcom_access("Nanotrasen Navy Captain"), "Nanotrasen Navy Captain")

    var/obj/item/weapon/implant/L = new /obj/item/weapon/implant/loyalty(H)
    L.imp_in = H
    L.implanted = 1

/datum/outfit/admin/nt_special_ops_officer
    name = "NT Special Ops Officer"

    uniform = /obj/item/clothing/under/syndicate/combat
    suit = /obj/item/clothing/suit/armor/swat/officer
    back = /obj/item/weapon/storage/backpack/satchel
    belt = /obj/item/weapon/gun/energy/pulse/pistol
    gloves = /obj/item/clothing/gloves/combat
    shoes = /obj/item/clothing/shoes/combat
    head = /obj/item/clothing/head/helmet/space/deathsquad/beret
    mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
    l_ear = /obj/item/device/radio/headset/heads/captain
    glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
    id = /obj/item/weapon/card/id/centcom
    l_pocket = /obj/item/weapon/storage/box/matches
    r_pocket = /obj/item/device/pda/heads
    backpack_contents = list(
        /obj/item/weapon/storage/box/engineer = 1,
        /obj/item/weapon/tank/emergency_oxygen/double = 1,
        /obj/item/clothing/mask/gas/swat = 1,
        /obj/item/weapon/melee/energy/sword = 1,
        /obj/item/weapon/pinpointer/advpinpointer = 1,
        /obj/item/weapon/storage/box/flashbangs = 1,
        /obj/item/weapon/storage/box/zipties = 1,
        /obj/item/clothing/shoes/magboots = 1,
        /obj/item/weapon/implanter/loyalty = 1,
    )

/datum/outfit/admin/nt_special_ops_officer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_centcom_access("Special Operations Officer"), "Special Operations Officer")



/datum/outfit/admin/nt_special_ops_formal
    name = "NT Special Ops Formal"

    uniform = /obj/item/clothing/under/syndicate/combat
    back = /obj/item/weapon/storage/backpack/satchel
    belt = /obj/item/weapon/gun/energy/pulse/pistol
    gloves = /obj/item/clothing/gloves/combat
    shoes = /obj/item/clothing/shoes/combat
    head = /obj/item/clothing/head/helmet/space/deathsquad/beret
    mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
    l_ear = /obj/item/device/radio/headset/heads/captain
    glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
    id = /obj/item/weapon/card/id/centcom
    l_pocket = /obj/item/weapon/storage/box/matches
    r_pocket = /obj/item/device/pda/heads
    backpack_contents = list(
        /obj/item/weapon/storage/box/engineer = 1,
        ///obj/item/weapon/melee/classic_baton/telescopic = 1,
        ///obj/item/weapon/implanter/dust = 1,
        ///obj/item/weapon/implanter/death_alarm = 1
    )

/datum/outfit/admin/nt_special_ops_formal/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/device/pda/PDA = H.get_equipped_item(slot_r_store)
    if(istype(PDA))
        PDA.owner = H.real_name
        PDA.ownjob = "Special Operations Officer"
        PDA.icon_state = "pda-syndi"
        PDA.name = "PDA-[H.real_name] ([PDA.ownjob])"
        PDA.desc = "A portable microcomputer by Thinktronic Systems, LTD. This is model is a special edition designed for military field work."

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_centcom_access("Special Operations Officer"), "Special Operations Officer")


/datum/outfit/admin/wizard
    uniform = /obj/item/clothing/under/lightpurple
    suit = /obj/item/clothing/suit/wizrobe
    back = /obj/item/weapon/storage/backpack
    shoes = /obj/item/clothing/shoes/sandal
    head = /obj/item/clothing/head/wizard
    l_ear = /obj/item/device/radio/headset
    id = /obj/item/weapon/card/id
    r_pocket = /obj/item/weapon/teleportation_scroll
    l_hand = /obj/item/weapon/staff
    r_hand = /obj/item/weapon/spellbook
    backpack_contents = list(
        /obj/item/weapon/storage/box/engineer = 1
    )

/datum/outfit/admin/wizard/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_all_accesses(), "Wizard")

/datum/outfit/admin/wizard/blue
    name = "Blue Wizard"
    // the default wizard clothes are blue

/datum/outfit/admin/wizard/red
    name = "Red Wizard"

    suit = /obj/item/clothing/suit/wizrobe/red
    head = /obj/item/clothing/head/wizard/red

/datum/outfit/admin/wizard/marisa
    name = "Marisa Wizard"

    suit = /obj/item/clothing/suit/wizrobe/marisa
    shoes = /obj/item/clothing/shoes/sandal/marisa
    head = /obj/item/clothing/head/wizard/marisa



/datum/outfit/admin/soviet
    uniform = /obj/item/clothing/under/soviet
    back = /obj/item/weapon/storage/backpack/satchel
    head = /obj/item/clothing/head/ushanka
    id = /obj/item/weapon/card/id


/datum/outfit/admin/soviet/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    . = ..()
    if(visualsOnly)
        return

    var/obj/item/weapon/card/id/I = H.wear_id
    if(istype(I))
        apply_to_card(I, H, get_all_accesses(), name)

/datum/outfit/admin/soviet/tourist
    name = "Soviet Tourist"

    gloves = /obj/item/clothing/gloves/black
    shoes = /obj/item/clothing/shoes/black
    l_ear = /obj/item/device/radio/headset
    backpack_contents = list(
        /obj/item/weapon/storage/box/survival = 1
    )

/datum/outfit/admin/soviet/soldier
    name = "Soviet Soldier"

    gloves = /obj/item/clothing/gloves/combat
    shoes = /obj/item/clothing/shoes/combat
    l_ear = /obj/item/device/radio/headset/syndicate
    glasses = /obj/item/clothing/glasses/sunglasses

    backpack_contents = list(
        /obj/item/weapon/storage/box/engineer = 1,
        /obj/item/weapon/card/emag = 1,
        /obj/item/device/flashlight = 1,
        /obj/item/weapon/plastique = 2,
        /obj/item/weapon/gun/projectile/revolver/mateba = 1,
        /obj/item/ammo_magazine/a357 = 3
    )

/datum/outfit/admin/soviet/admiral
    name = "Soviet Admiral"

    suit = /obj/item/clothing/suit/hgpirate
    belt = null
    gloves = /obj/item/clothing/gloves/combat
    shoes = /obj/item/clothing/shoes/combat
    head = /obj/item/clothing/head/hgpiratecap
    mask = null
    l_ear = /obj/item/device/radio/headset/syndicate
    r_ear = null
    glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
    id = null
    l_pocket = null
    r_pocket = null
    suit_store = null
    l_hand = null
    r_hand = null

    backpack_contents = list(
        /obj/item/weapon/storage/box/engineer = 1,
        /obj/item/weapon/gun/projectile/revolver/mateba = 1,
        /obj/item/ammo_magazine/a357 = 3
    )