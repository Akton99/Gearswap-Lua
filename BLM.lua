
-- This lua is based off of the Kinematics template and uses Motenten globals. --
	--Authors of this file--
		--Byrne (Asura)--
		--Gamergiving (Asura)--
		--Verbannt (Asura)--
		--Lygre(Odin)[Made what this is based off of]--
		
--Important note: In order for this lua to work optimally, you should have another copy lua
	--that runs in conjuction with this one named "BLM2.lua". In that lua you will define the correct
	--Max MP tables for player.mp functions while in Reisenjima and Escha areas. The MP value tables
	--in each lua must be fixed to match your Max MP value in the set you are in, in the proper situation
	--BLM (this one) should reflect your values outside Escha/Reisenjima and BLM2 should reflect those
	--values when you are inside with vorseals. The MP values to be considered are: Idle(for death),
	--Max MP while in refresh gear, Max MP while in fastest fast cast set, and Max MP when in diminished
	--fast cast set. 

--In addition to this, you will need a copy of this file renamed to BLM2.lua and you
	--will need to replace the following argument on the SECOND BLM lua. 
	--(around line 690~720 depending on your edits)

	--function job_buff_change(buff, gain)
	--if buff == "Vorseal" then
	--send_command('gs l blm2.lua')
	--end
	--if buff == "Visitant" then
	--send_command('gs l blm3.lua')
	--end
    --if buff == "Mana Wall" and not gain then
    --    enable('feet','back')
    --    handle_equipping_gear(player.status)
    --end
    --if buff == "Commitment" and not gain then
    --    equip({ring2="Capacity Ring"})
    --    if player.equipment.right_ring == "Capacity Ring" then
    --        disable("ring2")
    --   else
    --        enable("ring2")
    --    end
    --end
	--end
	
	
	
--Highlight that section (line 691) and replace it with this: (Dont forget to remove the -- on each line)
	
	--function job_buff_change(buff, gain)
	--if buff == "Vorseal" and not gain then
	--send_command('gs l blm.lua')
	--end
    --if buff == "Mana Wall" and not gain then
    --    enable('feet','back')
    --    handle_equipping_gear(player.status)
    --end
    --if buff == "Commitment" and not gain then
    --    equip({ring2="Capacity Ring"})
    --    if player.equipment.right_ring == "Capacity Ring" then
    --        disable("ring2")
    --    else
    --        enable("ring2")
    --    end
	--    end
	--end

	
	
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
 
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
     
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
 
end
 
 
-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
 
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
 
-- Setup vars that are user-dependent.  Setup which sets you want to contain which sets of gear. 
-- By default my sets are: Normal is bursting gear, Occult_Acumen is Conserve MP/MP return body, FreeNuke_Effect self explanatory.
-- If you're new to all this gearswap jazz, the F9~12 keys and CTRL keys in combination is how you activate this stuff.

function job_setup()
    state.OffenseMode:options('None', 'Locked')
    state.CastingMode:options('Normal', 'Occult_Acumen', 'FreeNuke_Effect')
    state.IdleMode:options('Normal', 'PDT')
    state.Moving  = M(false, "moving")
   
    MagicBurstIndex = 0
    state.MagicBurst = M(false, 'Magic Burst')
    state.ConsMP = M(false, 'AF Body')
    element_table = L{'Earth','Wind','Ice','Fire','Water','Lightning'}
    state.AOE = M(false, 'AOE')
 
 
    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
        'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
        'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
        'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga',
        'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II'}
 
    degrade_array = {
        ['Fire'] = {'Fire','Fire II','Fire III','Fire IV','Fire V','Fire VI'},
        ['Firega'] = {'Firaga','Firaga II','Firaga III','Firaja'},
        ['Ice'] = {'Blizzard','Blizzard II','Blizzard III','Blizzard IV','Blizzard V','Blizzard VI'},
        ['Icega'] = {'Blizzaga','Blizzaga II','Blizzaga III','Blizzaja'},
        ['Wind'] = {'Aero','Aero II','Aero III','Aero IV','Aero V','Aero VI'},
        ['Windga'] = {'Aeroga','Aeroga II','Aeroga III','Aeroja'},
        ['Earth'] = {'Stone','Stone II','Stone III','Stone IV','Stone V','Stone VI'},
        ['Earthga'] = {'Stonega','Stonega II','Stonega III','Stoneja'},
        ['Lightning'] = {'Thunder','Thunder II','Thunder III','Thunder IV','Thunder V','Thunder VI'},
        ['Lightningga'] = {'Thundaga','Thundaga II','Thundaga III','Thundaja'},
        ['Water'] = {'Water', 'Water II','Water III', 'Water IV','Water V','Water VI'},
        ['Waterga'] = {'Waterga','Waterga II','Waterga III','Waterja'},
        ['Aspirs'] = {'Aspir','Aspir II','Aspir III'},
        ['Sleepgas'] = {'Sleepga','Sleepga II'}
    }

 
    organizer_items = {aeonic="Khatvanga"}
    select_default_macro_book()
end
 
-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind @`')
end
 
 
-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
     
    ---- Precast Sets ----
     
    -- Precast sets to enhance JAs
	
    sets.precast.JA['Mana Wall'] = {back="Taranus's cape",feet="Wicce Sabots +1"}
 
    sets.precast.JA.Manafont = {body="Sorcerer's Coat +2"}
     
    -- Can put HP/MP set here for convert
	
    sets.precast.JA.Convert = {}
 
 
    -- Base precast Fast Cast set, this set will have to show up many times in the function section of the lua
	-- So dont forget to do that.
 
    sets.precast.FC = {main="Marin Staff",ammo="Incantor Stone",
        head="Nahtirah hat",neck="Orunmila's Torque",ear2="Loquacious Earring",
        body="Anhur Robe",hands="Helios gloves",ring1="Prolix Ring",ring2="Weatherspoon Ring",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},waist="Witful Belt",legs="Psycloth Lappas",feet="Regal pumps +1"}
		
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    sets.precast.FC['Enfeebling Magic'] = sets.precast.FC
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {ear1="Barkarole earring"})
    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {body="Heka's Kalasiris",legs="Doyen pants", back="Pahtli Cape"})
 
    -- Midcast set for Death, Might as well only have one set, unless you plan on free-nuking death for some unexplainable reason.

    sets.midcast['Death'] = {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body="Amalric Doublet",
    hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','Magic burst mdg.+10%','Mag. Acc.+10','"Mag.Atk.Bns."+14',}},
    feet="Merlinic Crackows",
    neck="Mizukage-no-Kubikazari",
    waist="Eschan Stone",
    left_ear="Barkaro. Earring",
    right_ear="Static Earring",
    left_ring="Archon Ring",
    right_ring="Mujin Band",
    back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
 
    -- Sets for WS, Feel free to add one for Vidohunir if you have Laevateinn

    sets.precast.WS['Myrkr'] = {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    hands="Amalric Gages",
    legs={ name="Amalric Slops", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    feet="Psycloth Boots",
    neck="Sanctity Necklace",
    waist="Yamabuki-no-Obi",
    left_ear="Evans Earring",
    right_ear="Moonshade Earring",
    left_ring="Bifrost Ring",
    right_ring="Sangoma Ring",
    back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
 
    ---- Midcast Sets ----
    sets.midcast.FastRecast = {}
 
    sets.midcast['Healing Magic'] = {}

    sets.midcast['Enhancing Magic'] = {}
 
	-- I personally do not have gear to alter these abilities as of the time of disseminating this file, but 
	-- definitely add them here if you have them.
 
    sets.midcast.Refresh = {}
    sets.midcast.Haste = {}
    sets.midcast.Phalanx = {}
    sets.midcast.Aquaveil = {}
    sets.midcast.Stoneskin = {}
 
    sets.midcast['Enfeebling Magic'] = {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst mdg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
    body="Merlinic Jubbah",
    hands="Jhakri Cuffs +1",
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
    feet="Jhakri Pigaches +1",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Barkaro. Earring",
    right_ear="Dignitary's Earring",
    left_ring="Stikini Ring",
    right_ring="Stikini Ring",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}   

    sets.midcast['Enfeebling Magic'].FreeNuke_Effect = set_combine(sets.midcast['Enfeebling Magic'],{main="Grioavolr",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst mdg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
    body="Vanya Robe",
    hands="Lurid Mitts",
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Medium's Sabots", augments={'MP+50','MND+8','"Conserve MP"+6','"Cure" potency +3%',}},
    neck="Henic Torque",
    waist="Eschan Stone",
    left_ear="Barkaro. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring",
    right_ring="Stikini Ring",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}})

	sets.midcast['Enfeebling Magic'].Occult_Acumen = set_combine(sets.midcast['Enfeebling Magic'],{main="Grioavolr",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst mdg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
    body="Vanya Robe",
    hands="Lurid Mitts",
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Medium's Sabots", augments={'MP+50','MND+8','"Conserve MP"+6','"Cure" potency +3%',}},
    neck="Henic Torque",
    waist="Eschan Stone",
    left_ear="Barkaro. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring",
    right_ring="Stikini Ring",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}})
	
	sets.midcast.ElementalEnfeeble = sets.midcast['Enfeebling Magic']
 
    sets.midcast['Dark Magic'] = {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst mdg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
    body="Merlinic Jubbah",
    hands="Jhakri cuffs +1",
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
    feet="Merlinic Crackows",
    neck="Sanctity Necklace",
    waist="Fucho-no-Obi",
    left_ear="Barkaro. Earring",
    right_ear="Dignitary's Earring",
    left_ring="Evanescence Ring",
    right_ring="Sangoma Ring",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
 
    -- Elemental Magic sets
     
    sets.midcast['Elemental Magic'] = {
	main="Grioavolr",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst mdg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
    body="Merlinic Jubbah",
    hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
    feet="Merlinic Crackows",
    neck="Mizu. Kubikazari",
    waist="Eschan Stone",
    left_ear="Static Earring",
    right_ear="Barkaro. Earring",
    left_ring="Mujin Band",
    right_ring="Locus Ring",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast['Elemental Magic'].FreeNuke_Effect = set_combine(sets.midcast['Elemental Magic'], {main="Grioavolr",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst mdg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
    body="Merlinic Jubbah",
    hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
    feet="Merlinic Crackows",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Friomisi Earring",
    right_ear="Barkaro. Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}})
    sets.midcast['Elemental Magic'].Occult_Acumen = set_combine(sets.midcast['Elemental Magic'], {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Seraphic Ampulla",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24','"Occult Acumen"+10','INT+9',}},
    body="Seidr Cotehardie",
    hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+20','"Occult Acumen"+11',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','"Occult Acumen"+9','INT+10','"Mag.Atk.Bns."+8',}},
    feet="Merlinic Crackows",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Barkaro. Earring",
    right_ear="Gwati Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}})
    sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {})
    sets.midcast['Elemental Magic'].HighTierNuke.FreeNuke_Effect = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {main="Grioavolr",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst mdg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
    body="Merlinic Jubbah",
    hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
    feet="Merlinic Crackows",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Friomisi Earring",
    right_ear="Barkaro. Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}})
    sets.midcast['Elemental Magic'].HighTierNuke.Occult_Acumen = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Seraphic Ampulla",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24','"Occult Acumen"+10','INT+9',}},
    body="Seidr Cotehardie",
    hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+20','"Occult Acumen"+11',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','"Occult Acumen"+9','INT+10','"Mag.Atk.Bns."+8',}},
    feet="Merlinic Crackows",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Barkaro. Earring",
    right_ear="Gwati Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}})
 
    sets.midcast.Impact = {head=empty,body="Twilight Cloak",hands="Jhakri cuffs +1",
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
    feet="Merlinic Crackows",
    neck="Sanctity Necklace",
    waist="Hachirin-no-Obi",
    left_ear="Dignitary's Earring",
    right_ear="Barkaro. Earring",
    left_ring="Stikini Ring",
    right_ring="Stikini Ring",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
	
	sets.midcast['Comet'] = set_combine(sets.midcast['Elemental Magic'], {{ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Seraphic Ampulla",
    head="Pixie Hairpin +1",
    body="Merlinic Jubbah",
    hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','Magic burst mdg.+10%','Mag. Acc.+10','"Mag.Atk.Bns."+14',}},
    feet="Merlinic Crackows",
    neck="Mizu. Kubikazari",
    waist="Eschan Stone",
    left_ear="Static Earring",
    right_ear="Barkaro. Earring",
    left_ring="Archon Ring",
    right_ring="Mujin Band",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}})
 
	sets.midcast['Comet'].FreeNuke_Effect = set_combine(sets.midcast['Elemental Magic'], {{ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Seraphic Ampulla",
    head="Pixie Hairpin +1",
    body="Merlinic Jubbah",
    hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','Magic burst mdg.+10%','Mag. Acc.+10','"Mag.Atk.Bns."+14',}},
    feet="Merlinic Crackows",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Friomisi Earring",
    right_ear="Barkaro. Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}})
 
    --Set to be equipped when Day/Weather match current spell element

    sets.Obi = {waist='Hachirin-no-Obi'}
	
	-- I actually have two references to equip this item, just in case your globals are out of date.
 
    -- Resting sets
	
    sets.resting = {}
 
    -- Idle sets: Make general idle set a max MP set, later hooks will handle the rest of your refresh sets, but
	-- remember to alter the latent_refresh sets (Ctrl+F to find them)

    sets.idle = {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    hands="Amalric Gages",
    legs={ name="Amalric Slops", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    feet="Psycloth boots",
    neck="Sanctity Necklace",
    waist="Yamabuki-no-Obi",
    left_ear="Evans Earring",
    right_ear="Loquac. Earring",
    left_ring="Bifrost Ring",
    right_ring="Sangoma Ring",
    back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
 
    -- Idle mode that keeps PDT gear on, but doesn't prevent normal gear swaps for precast/etc.
    sets.idle.PDT = {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    hands="Amalric Gages",
    legs={ name="Amalric Slops", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    feet="Psycloth Boots",
    feet="Psycloth boots",
    neck="Sanctity Necklace",
    waist="Yamabuki-no-Obi",
    left_ear="Evans Earring",
    right_ear="Loquac. Earring",
    left_ring="Bifrost Ring",
    right_ring="Sangoma Ring",
    back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
     
    sets.Adoulin = {
        body="Councilor's Garb",
    }

    sets.MoveSpeed = {
        feet = "Herald's Gaiters",
    }
    
             
    sets.TreasureHunter = {waist="Chaac Belt"}
 
    -- Set for Conserve MP toggle, convert damage to MP body.
	
    sets.ConsMP = {body="Seidr Cotehardie"}
 
    --- PDT set is designed to be used for MP total set, MDT can be used for whatever you like but in MDT mode
	--- the player.mp arguments will likely stop working properly
	
    sets.defense.PDT = {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    hands="Amalric Gages",
    legs={ name="Amalric Slops", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    feet="Psycloth Boots",
    neck="Sanctity Necklace",
    waist="Yamabuki-no-Obi",
    feet="Psycloth boots",
    left_ear="Evans Earring",
    right_ear="Loquac. Earring",
    left_ring="Bifrost Ring",
    right_ring="Sangoma Ring",
    back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
 
    sets.defense.MDT = {main="Grioavolr",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst mdg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
    body="Merlinic Jubbah",
    hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
    feet="Merlinic Crackows",
    neck="Mizu. Kubikazari",
    waist="Hachirin-no-Obi",
    left_ear="Static Earring",
    right_ear="Barkaro. Earring",
    left_ring="Mujin Band",
    right_ring="Locus Ring",
    back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
 
    sets.Kiting = {feet="Herald's Gaiters"}
	
	sets.latent_refresh2 = {waist="Fucho-no-Obi"}
    sets.latent_refresh = {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    hands="Serpentes Cuffs",
    legs="Assid. Pants +1",
    feet="Serpentes Sabots",
    neck="Sanctity Necklace",
    waist="Yamabuki-no-Obi",
    left_ear="Evans Earring",
    right_ear="Loquac. Earring",
    left_ring="Bifrost Ring",
    right_ring="Sangoma Ring",
    back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
 
    -- Mana Wall idle set

    sets.buff['Mana Wall'] = {main="Terra's Staff",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Kaabnax Hat",
    body="Merlinic Jubbah",
    hands="Hagondes Cuffs +1",
    legs={ name="Hagondes Pants +1", augments={'Phys. dmg. taken -4%',}},
    feet="Wicce Sabots +1",
    neck="Loricate Torque +1",
    waist="Slipor Sash",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Phys. dmg. taken -6%','Magic dmg. taken -4%',}},
    right_ring={ name="Dark Ring", augments={'Enemy crit. hit rate -2','Phys. dmg. taken -5%','Magic dmg. taken -5%',}},
    back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
 
    -- Engaged sets
 
    -- Set is designed for engaging a monster before pop to ensure you are at maximum MP value when Geas Fete triggers an MP refill.
	
	sets.engaged = {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    hands="Amalric Gages",
    legs={ name="Amalric Slops", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    feet="Psycloth Boots",
    neck="Sanctity Necklace",
    feet="Psycloth boots",
    waist="Yamabuki-no-Obi",
    left_ear="Evans Earring",
    right_ear="Loquac. Earring",
    left_ring="Bifrost Ring",
    right_ring="Sangoma Ring",
    back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
end
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
 
--- Define MP and buff specific Fast Cast and Midcast sets for conservation of MP for death sets, most will be
--- handled on thier own. What you need to change is the player.mp value to match slightly under what your max
--- MP is in your standard fast cast set. The set is designed to Dynamically switch fast cast sets to sets that
--- preserve your MP total if you are above the amount at which equiping your standard set would decrease your
--- maximum MP. You also must put respective fast cast sets as a brute force equip like I have them listed below
--- or this function will not work properly. Same goes for the Aspir sets.
 
function job_precast(spell, action, spellMap, eventArgs)
    enable('feet','back')
	if player.mp > 1650 then
	sets.precast.FC = set_combine(sets.precast.FC, {main="Lathi",ammo="Pemphredo Tathlum",
        head="Nahtirah hat",neck="Orunmila's Torque",ear2="Loquacious Earring",ear1="Evans Earring",
        body="Helios Jacket",hands="Helios gloves",ring1="Sangoma Ring",ring2="Bifrost Ring",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},waist="Hachirin-no-Obi",legs="Psycloth Lappas",feet="Regal pumps +1"})
		elseif player.mp < 1650 then
		sets.precast.FC = set_combine(sets.precast.FC, {main="Marin Staff",ammo="Pemphredo Tathlum",
        head="Nahtirah hat",neck="Orunmila's Torque",ear2="Loquacious Earring",
        body="Anhur Robe",hands="Helios gloves",ring1="Prolix Ring",
        back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},waist="Witful Belt",legs="Psycloth Lappas",feet="Regal pumps +1"})
		end
	end

function job_post_precast(spell, action, spellMap, eventArgs)
if spell.english == "Impact" then
        equip({head=empty,body="Twilight Cloak"})
    elseif spellMap == 'Cure' or spellMap == 'Curaga' then
        gear.default.obi_waist = "Hachirin-no-obi"
    end
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

-- This section is for you to define at what value your Aspir sets will change. This is to let your aspirs
-- get you into your death idle and higher MP values. This number should be around 100 MP lower than the
-- Fast cast argument above this to prevent looping. As said before you must put in your gear here as well
-- just like I have it listed or else this argument will not work.

    if spell.action_type == 'Magic' then
			if spell.element == world.weather_element or spell.element == world.day_element then
            equip(set_combine(sets.midcast['Elemental Magic'], {waist="Hachirin-no-Obi",}))
        end
            if spell.english == 'Death' then
                equip(sets.midcast['Death'])
			end
	end
	if spell.action_type == 'Magic' then
	if player.mp < 1640 then
		sets.midcast['Dark Magic'] = set_combine(sets.midcast['Dark Magic'], {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
		sub="Niobid Strap",
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst mdg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
		body="Merlinic Jubbah",
		hands="Jhakri Cuffs +1",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
		feet="Merlinic Crackows",
		neck="Sanctity Necklace",
		waist="Fucho-no-Obi",
		left_ear="Barkaro. Earring",
		right_ear="Gwati Earring",
		left_ring="Evanescence Ring",
		right_ring="Sangoma Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},})
	elseif spell.english == 'Aspir' or spell.english == 'Aspir II' or spell.english == 'Aspir III' and player.mp > 1640 then
		sets.midcast['Dark Magic'] = set_combine(sets.midcast['Dark Magic'], {main={ name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}},
		sub="Niobid Strap",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
		hands="Amalric Gages",
		legs={ name="Amalric Slops", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		feet="Psycloth Boots",
		neck="Sanctity Necklace",
		waist="Yamabuki-no-Obi",
		left_ear="Barkarole Earring",
		right_ear="Evans Earring",
		left_ring="Bifrost Ring",
		right_ring="Sangoma Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},})
		end
	end
 end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.element == world.day_element or spell.element == world.weather_element then
        if string.find(spell.english,'helix') then
            equip(sets.midcast.Helix)
        else 
            equip(sets.Obi)
        end
    end
	if spell.skill == 'Elemental Magic' and player.mp < 520 then
		equip(sets.ConsMP)
		end
	if spell.skill == 'Enfeebling Magic' and state.HybridMode ~= 'Resist' then
	equip(sets.midcast['Enfeebling Magic'].Effect)
	end
end
 
 --	if buffactive['Elemental Seal'] and spell.skill == 'Elemental Magic' and state.HybridMode ~= 'Resist' then
 --	equip(sets.midcast['Enfeebling Magic'].Effect)
 --	end
 
 --	if spell.skill == 'Enfeebling Magic' and state.HybridMode ~= 'Resist' then
 --	equip(sets.midcast['Enfeebling Magic'])
 
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Lock feet after using Mana Wall.
    if buffactive['Mana Wall'] then
        enable('feet','back')
        equip(sets.buff['Mana Wall'])
        disable('feet','back')
    end
    if not spell.interrupted then
        if spell.english == "Sleep II" or spell.english == "Sleepga II" then -- Sleep II Countdown --
            send_command('wait 60;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('wait 30;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Break" or spell.english == "Breakga" then -- Break Countdown --
            send_command('wait 25;input /echo Break Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Paralyze" then -- Paralyze Countdown --
             send_command('wait 115;input /echo Paralyze Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Slow" then -- Slow Countdown --
            send_command('wait 115;input /echo Slow Effect: [WEARING OFF IN 5 SEC.]')        
        end
    end
 
end
 
function nuke(spell, action, spellMap, eventArgs)
    if player.target.type == 'MONSTER' then
        if state.AOE.value then
            send_command('input /ma "'..degrade_array[element_table:append('ga')][#degrade_array[element_table:append('ga')]]..'" '..tostring(player.target.name))
        else
            send_command('input /ma "'..degrade_array[element_table][#degrade_array[element_table]]..'" '..tostring(player.target.name))
        end
    else 
        add_to_chat(5,'A Monster is not targetted.')
    end
end
 
function job_self_command(commandArgs, eventArgs)
    if commandArgs[1] == 'element' then
        if commandArgs[2] then
            if element_table:contains(commandArgs[2]) then
                element_table = commandArgs[2]
                add_to_chat(5, 'Current Nuke element ['..element_table..']')
            else
                add_to_chat(5,'Incorrect Element value')
                return
            end
        else
            add_to_chat(5,'No element specified')
        end
    elseif commandArgs[1] == 'nuke' then
        nuke()
    end
end
 
 
function refine_various_spells(spell, action, spellMap, eventArgs)
    local aspirs = S{'Aspir','Aspir II','Aspir III'}
    local sleeps = S{'Sleep','Sleep II'}
    local sleepgas = S{'Sleepga','Sleepga II'}
 
    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'
 
    local spell_index
 
    if spell_recasts[spell.recast_id] > 0 then
        if spell.skill == 'Elemental Magic' then
            local ele = tostring(spell.element):append('ga')
            --local ele2 = string.sub(ele,1,-2)
            if table.find(degrade_array[ele],spell.name) then
                spell_index = table.find(degrade_array[ele],spell.name)
                if spell_index > 1 then
                    newSpell = degrade_array[ele][spell_index - 1]
                    add_to_chat(8,spell.name..' Canceled: ['..player.mp..'/'..player.max_mp..'MP::'..player.mpp..'%] Casting '..newSpell..' instead.')
                    send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                    eventArgs.cancel = true
                end
            else 
                spell_index = table.find(degrade_array[spell.element],spell.name)
                if spell_index > 1 then
                    newSpell = degrade_array[spell.element][spell_index - 1]
                    add_to_chat(8,spell.name..' Canceled: ['..player.mp..'/'..player.max_mp..'MP::'..player.mpp..'%] Casting '..newSpell..' instead.')
                    send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                    eventArgs.cancel = true
                end
            end
        elseif aspirs:contains(spell.name) then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                add_to_chat(8,spell.name..' Canceled: ['..player.mp..'/'..player.max_mp..'MP::'..player.mpp..'%] Casting '..newSpell..' instead.')
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        elseif sleepgas:contains(spell.name) then
            spell_index = table.find(degrade_array['Sleepgas'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Sleepgas'][spell_index - 1]
                add_to_chat(8,spell.name..' Canceled: ['..player.mp..'/'..player.max_mp..'MP::'..player.mpp..'%] Casting '..newSpell..' instead.')
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
    end
end

mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
    mov.x = windower.ffxi.get_mob_by_index(player.index).x
    mov.y = windower.ffxi.get_mob_by_index(player.index).y
    mov.z = windower.ffxi.get_mob_by_index(player.index).z
end

mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
    mov.x = windower.ffxi.get_mob_by_index(player.index).x
    mov.y = windower.ffxi.get_mob_by_index(player.index).y
    mov.z = windower.ffxi.get_mob_by_index(player.index).z
end


moving = false
windower.raw_register_event('prerender',function()
    mov.counter = mov.counter + 1;
    if mov.counter>15 then
        local pl = windower.ffxi.get_mob_by_index(player.index)
        if pl and pl.x and mov.x then
            dist = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 )
            if dist > 1 and not moving then
                state.Moving.value = true
                send_command('gs c update')
                send_command('gs equip sets.MoveSpeed')
                if world.area:contains("Adoulin") then
                    send_command('gs equip sets.Adoulin')
                end

                moving = true

            elseif dist < 1 and moving then
                state.Moving.value = false
                send_command('gs c update')
                moving = false
            end
        end
        if pl and pl.x then
            mov.x = pl.x
            mov.y = pl.y
            mov.z = pl.z
        end
        mov.counter = 0
    end
end)
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
 
 
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if buff == "Vorseal" then
	send_command('gs l blm2.lua')
	end
	if buff == "Visitant" then
	send_command('gs l blm3.lua')
	end
    -- Unlock feet when Mana Wall buff is lost.
    if buff == "Mana Wall" and not gain then
        enable('feet','back')
        handle_equipping_gear(player.status)
    end
    if buff == "Commitment" and not gain then
        equip({ring2="Capacity Ring"})
        if player.equipment.right_ring == "Capacity Ring" then
            disable("ring2")
        else
            enable("ring2")
        end
    end
end
 
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Locked' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
    if stateField == 'Death Mode' then
        if newValue == true then
            state.OffenseMode:set('Locked')
            predeathcastmode = state.CastingMode.value
            --[[Insert 'equip(<set consisting of Death weapon and sub, to have them automatically lock when changing into Death mode>)']]
        elseif newValue == false then
            state.CastingMode:set(predeathcastmode)
        end
    end            
end
 
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
--[[function job_update(cmdParams, eventArgs)
    job_display_current_state(eventArgs)
    eventArgs.handled = true
end]]
 
function display_current_job_state(eventArgs)
    eventArgs.handled = true
    local msg = ''
     
    if state.OffenseMode.value ~= 'None' then
        msg = msg .. 'Combat ['..state.OffenseMode.value..']'
 
        if state.CombatForm.has_value then
            msg = msg .. ' (' .. state.CombatForm.value .. ')'
        end
        msg = msg .. ', '
    end
    --[[if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end]]
 
    msg = msg .. 'Casting ['..state.CastingMode.value..'], Idle ['..state.IdleMode.value..']'
 
    if state.MagicBurst.value then
        msg = msg .. ', MB [ON]'
    else
        msg = msg .. ', MB [OFF]'
    end
    if state.ConsMP.value then
        msg = msg .. ', AF Body [ON]'
    else
        msg = msg .. ', AF Body [OFF]'
    end
    if state.DeatCast.value then
        msg = msg .. ', Death Mode [ON]'
    else 
        msg = msg .. ', Death Mode [OFF]'
    end
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
     
    if state.Kiting.value then
        msg = msg .. ', Kiting [ON]'
    end
 
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end
 
    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
 
    add_to_chat(122, msg)
end
 
-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        if lowTierNukes:contains(spell.english) then
            return 'LowTierNuke'
        else
            return 'HighTierNuke'
        end
    end
end
 
-- Modify the default idle set after it was constructed.
--- This is where I handle Death Mode Idle set construction, rather than weave it into the Idle state var
function customize_idle_set(idleSet)
	if player.mpp < 51 then
		idleSet = set_combine(sets.latent_refresh, sets.latent_refresh2)
		elseif player.mp < 1650 then
			idleSet = set_combine(idleSet, sets.latent_refresh)	
	end
    if buffactive['Mana Wall'] then
        idleSet = sets.buff['Mana Wall']
    end
    return idleSet
end
--- This is where I handle Death Mode Melee set modifications
function customize_melee_set(meleeSet)
    if buffactive['Mana Wall'] then
        meleeSet = set_combine(meleeSet, sets.buff['Mana Wall'])
    end
    return meleeSet
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
 
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(9, 4)
end
