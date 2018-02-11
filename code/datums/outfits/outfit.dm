/datum/outfit
    var/name = "Naked"
    var/collect_not_del = FALSE

    var/uniform = null
    var/suit = null
    var/back = null
    var/belt = null
    var/gloves = null
    var/shoes = null
    var/head = null
    var/mask = null
    var/l_ear = null
    var/r_ear = null
    var/glasses = null
    var/id = null
    var/l_pocket = null
    var/r_pocket = null
    var/suit_store = null
    var/l_hand = null
    var/r_hand = null
    var/internals_slot = null //ID of slot containing a gas tank
    var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format


/datum/outfit/proc/pre_equip(mob/living/carbon/human/H)
    //to be overriden for customization depending on client prefs,species etc
    return

// Used to equip an item to the mob. Mainly to prevent copypasta for collect_not_del.
/datum/outfit/proc/equip_item(mob/living/carbon/human/H, path, slot)
    var/obj/item/I = new path(H)
    if(collect_not_del)
        H.equip_or_collect(I, slot)
    else
        H.equip_to_slot_or_del(I, slot)

//to be overriden for toggling internals, id binding, access etc
/datum/outfit/proc/post_equip(mob/living/carbon/human/H)
    return

/datum/outfit/proc/equip(mob/living/carbon/human/H)
    pre_equip(H)

    //Start with uniform,suit,backpack for additional slots
    if(uniform)
        equip_item(H, uniform, slot_w_uniform)
    if(suit)
        equip_item(H, suit, slot_wear_suit)
    if(back)
        equip_item(H, back, slot_back)
    if(belt)
        equip_item(H, belt, slot_belt)
    if(gloves)
        equip_item(H, gloves, slot_gloves)
    if(shoes)
        equip_item(H, shoes, slot_shoes)
    if(head)
        equip_item(H, head, slot_head)
    if(mask)
        equip_item(H, mask, slot_wear_mask)
    if(l_ear)
        equip_item(H, l_ear, slot_l_ear)
    if(r_ear)
        equip_item(H, r_ear, slot_r_ear)
    if(glasses)
        equip_item(H, glasses, slot_glasses)
    if(suit_store)
        equip_item(H, suit_store, slot_s_store)
    if(l_hand)
        H.put_in_l_hand(new l_hand(H))
    if(r_hand)
        H.put_in_r_hand(new r_hand(H))

    if(id)
        equip_item(H, id, slot_wear_id)
        

    if(l_pocket)
        equip_item(H, l_pocket, slot_l_store)
    if(r_pocket)
        equip_item(H, r_pocket, slot_r_store)

    for(var/path in backpack_contents)
        var/number = backpack_contents[path]
        for(var/i = 0, i < number, i++)
            equip_item(H, path, slot_in_backpack)

    post_equip(H)
    apply_fingerprints(H)
    H.update_body()
    return 1

/datum/outfit/proc/apply_fingerprints(mob/living/carbon/human/H)
    if(!istype(H))
        return
    if(H.back)
        H.back.add_fingerprint(H, 1)	//The 1 sets a flag to ignore gloves
        for(var/obj/item/I in H.back.contents)
            I.add_fingerprint(H, 1)
    if(H.wear_id)
        H.wear_id.add_fingerprint(H, 1)
    if(H.w_uniform)
        H.w_uniform.add_fingerprint(H, 1)
    if(H.wear_suit)
        H.wear_suit.add_fingerprint(H, 1)
    if(H.wear_mask)
        H.wear_mask.add_fingerprint(H, 1)
    if(H.head)
        H.head.add_fingerprint(H, 1)
    if(H.shoes)
        H.shoes.add_fingerprint(H, 1)
    if(H.gloves)
        H.gloves.add_fingerprint(H, 1)
    if(H.l_ear)
        H.l_ear.add_fingerprint(H, 1)
    if(H.r_ear)
        H.r_ear.add_fingerprint(H, 1)
    if(H.glasses)
        H.glasses.add_fingerprint(H, 1)
    if(H.belt)
        H.belt.add_fingerprint(H, 1)
        for(var/obj/item/I in H.belt.contents)
            I.add_fingerprint(H, 1)
    if(H.s_store)
        H.s_store.add_fingerprint(H, 1)
    if(H.l_store)
        H.l_store.add_fingerprint(H, 1)
    if(H.r_store)
        H.r_store.add_fingerprint(H, 1)
    return 1


/datum/outfit/job
    name = "Standard Gear"
    collect_not_del = TRUE // we don't want anyone to lose their job shit

    var/allow_loadout = TRUE
    var/allow_backbag_choice = TRUE
    var/jobtype = null

    uniform = /obj/item/clothing/under/color/grey
    id = /obj/item/weapon/card/id
    l_ear = /obj/item/device/radio/headset
    back = /obj/item/weapon/storage/backpack
    shoes = /obj/item/clothing/shoes/black

    var/list/implants = null

    var/backpack = /obj/item/weapon/storage/backpack
    var/satchel = /obj/item/weapon/storage/backpack/satchel_norm
    var/dufflebag = /obj/item/weapon/storage/backpack/duffel
    var/box = /obj/item/weapon/storage/box/survival

    var/tmp/list/gear_leftovers = list()

/datum/outfit/job/pre_equip(mob/living/carbon/human/H)
//Not needed until we actually move all the jobs to the datumized loadouts
    /*
    if(allow_backbag_choice)
        switch(H.backbag)
            if(GBACKPACK)
                back = /obj/item/weapon/storage/backpack //Grey backpack
            if(GSATCHEL)
                back = /obj/item/weapon/storage/backpack/satchel_norm //Grey satchel
            if(GDUFFLEBAG)
                back = /obj/item/weapon/storage/backpack/duffel //Grey Dufflebag
            if(LSATCHEL)
                back = /obj/item/weapon/storage/backpack/satchel //Leather Satchel
            if(DSATCHEL)
                back = satchel //Department satchel
            if(DDUFFLEBAG)
                back = dufflebag //Department dufflebag
            else
                back = backpack //Department backpack
*/
    if(box)
        backpack_contents.Insert(1, box) // Box always takes a first slot in backpack
        backpack_contents[box] = 1
//Not needed until we actually move all the jobs to the datumized loadouts
    /*
    if(allow_loadout && H.client && (H.client.prefs.gear && H.client.prefs.gear.len))
        for(var/gear in H.client.prefs.gear)
            var/datum/gear/G = gear_datums[gear]
            if(G)
                var/permitted = FALSE

                if(G.allowed_roles)
                    if(name in G.allowed_roles)
                        permitted = TRUE
                else
                    permitted = TRUE

                if(G.whitelisted && (G.whitelisted != H.species.name || !is_alien_whitelisted(H, G.whitelisted)))
                    permitted = FALSE

                if(!permitted)
                    to_chat(H, "<span class='warning'>Your current job or whitelist status does not permit you to spawn with [gear]!</span>")
                    continue

                if(G.slot)
                    if(H.equip_to_slot_or_del(G.spawn_item(H), G.slot))
                        to_chat(H, "<span class='notice'>Equipping you with [gear]!</span>")
                    else
                        gear_leftovers += G
                else
                    gear_leftovers += G
    */

/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
    if(visualsOnly)
        return

    imprint_idcard(H)

    imprint_pda(H)

    if(implants)
        for(var/implant_type in implants)
            var/obj/item/weapon/implant/I = new implant_type(H)
            I.implant(H)

    if(gear_leftovers.len)
        for(var/datum/gear/G in gear_leftovers)
            var/atom/placed_in = H.equip_or_collect(G.spawn_item(null, H.client.prefs.gear[G.display_name]))
            if(istype(placed_in))
                if(isturf(placed_in))
                    to_chat(H, "<span class='notice'>Placing [G.display_name] on [placed_in]!</span>")
                else
                    to_chat(H, "<span class='noticed'>Placing [G.display_name] in [placed_in.name]")
                continue
            if(H.equip_to_appropriate_slot(G))
                to_chat(H, "<span class='notice'>Placing [G.display_name] in your inventory!</span>")
                continue
            if(H.put_in_hands(G))
                to_chat(H, "<span class='notice'>Placing [G.display_name] in your hands!</span>")
                continue
            to_chat(H, "<span class='danger'>Failed to locate a storage object on your mob, either you spawned with no hands free and no backpack or this is a bug.</span>")
            qdel(G)

        qdel(gear_leftovers)

    return 1

/datum/outfit/job/proc/imprint_idcard(mob/living/carbon/human/H)
    //TODO-ERT: Reenable this
    /*
    var/datum/job/J = job_master.GetJobType(jobtype)
    if(!J)
        J = job_master.GetJob(H.job)

    var/alt_title
    if(H.mind)
        alt_title = H.mind.role_alt_title

    var/obj/item/weapon/card/id/C = H.wear_id
    if(istype(C))
        C.access = J.get_access()
        C.registered_name = H.real_name
        C.rank = J.title
        C.assignment = alt_title ? alt_title : J.title
        C.sex = capitalize(H.gender)
        C.age = H.age
        C.name = "[C.registered_name]'s ID Card ([C.assignment])"

        if(H.mind && H.mind.initial_account)
            C.associated_account_number = H.mind.initial_account.account_number
    */
    return

/datum/outfit/job/proc/imprint_pda(mob/living/carbon/human/H)
    //TODO-ERT: Reenable this
    /*
    var/obj/item/device/pda/PDA = H.get_equipped_item(slot_belt) //Ugly hack since we dont have a pda slot
    var/obj/item/weapon/card/id/C = H.wear_id
    if(istype(PDA) && istype(C))
        PDA.owner = H.real_name
        PDA.ownjob = C.assignment
        PDA.ownrank = C.rank
        PDA.name = "PDA-[H.real_name] ([PDA.ownjob])"
    */