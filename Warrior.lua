--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- HeroDBC
local DBC = HeroDBC.DBC
-- HeroLib
local HL         = HeroLib
local Cache      = HeroCache
local Unit       = HL.Unit
local Player     = Unit.Player
local Target     = Unit.Target
local Pet        = Unit.Pet
local Spell      = HL.Spell
local MultiSpell = HL.MultiSpell
local Item       = HL.Item
-- HeroRotation
local HR         = HeroRotation

--- ============================ CONTENT ============================

-- Spell
if not Spell.Warrior then Spell.Warrior = {} end

Spell.Warrior.Fury = {
  -- Racials
  -- Abilities

  -- Talents

  -- Covenant Abilities

  -- Legendary Effects

  -- Conduits

  -- Item Buffs/Debuffs

  RazorCoralDebuff                      = Spell(303568),
  -- Azerite Traits (BfA)

  -- Essences (BfA)
  BloodoftheEnemy                       = Spell(297108),
  ConcentratedFlame                     = Spell(295373),
  ConcentratedFlameBurn                 = Spell(295368),
  FocusedAzeriteBeam                    = Spell(295258),
  GuardianofAzeroth                     = Spell(295840),
  LifebloodBuff                         = MultiSpell(295137, 305694),
  MemoryofLucidDreams                   = Spell(298357),
  PurifyingBlast                        = Spell(295337),
  ReapingFlames                         = Spell(310690),
  RecklessForceBuff                     = Spell(302932),
  RecklessForceCounter                  = MultiSpell(298409, 302917),
  RippleInSpace                         = Spell(302731),
  TheUnboundForce                       = Spell(298452),
  WorldveinResonance                    = Spell(295186)
}

Spell.Warrior.Arms = {
  -- Racials
  -- Abilities

  -- Talents

  -- Covenant Abilities

  -- Legendary Effects

  -- Conduits

  -- Item Buffs/Debuffs

  RazorCoralDebuff                      = Spell(303568),
  -- Azerite Traits (BfA)

  -- Essences (BfA)
  BloodoftheEnemy                       = Spell(297108),
  ConcentratedFlame                     = Spell(295373),
  ConcentratedFlameBurn                 = Spell(295368),
  FocusedAzeriteBeam                    = Spell(295258),
  GuardianofAzeroth                     = Spell(295840),
  LifebloodBuff                         = MultiSpell(295137, 305694),
  MemoryofLucidDreams                   = Spell(298357),
  PurifyingBlast                        = Spell(295337),
  ReapingFlames                         = Spell(310690),
  RecklessForceBuff                     = Spell(302932),
  RecklessForceCounter                  = MultiSpell(298409, 302917),
  RippleInSpace                         = Spell(302731),
  TheUnboundForce                       = Spell(298452),
  WorldveinResonance                    = Spell(295186)
}

Spell.Warrior.Protection = {
  -- Racials
  -- Abilities

  -- Talents

  -- Covenant Abilities

  -- Legendary Effects

  -- Conduits

  -- Item Buffs/Debuffs

  RazorCoralDebuff                      = Spell(303568),
  -- Azerite Traits (BfA)

  -- Essences (BfA)
  BloodoftheEnemy                       = Spell(297108),
  ConcentratedFlame                     = Spell(295373),
  ConcentratedFlameBurn                 = Spell(295368),
  FocusedAzeriteBeam                    = Spell(295258),
  GuardianofAzeroth                     = Spell(295840),
  LifebloodBuff                         = MultiSpell(295137, 305694),
  MemoryofLucidDreams                   = Spell(298357),
  PurifyingBlast                        = Spell(295337),
  ReapingFlames                         = Spell(310690),
  RecklessForceBuff                     = Spell(302932),
  RecklessForceCounter                  = MultiSpell(298409, 302917),
  RippleInSpace                         = Spell(302731),
  TheUnboundForce                       = Spell(298452),
  WorldveinResonance                    = Spell(295186)
}

-- Items
if not Item.Warrior then Item.Warrior = {} end
Item.Warrior.Fury = {
  PotionofUnbridledFury            = Item(169299),
  PocketsizedComputationDevice     = Item(167555, {13, 14}),
  AshvanesRazorCoral               = Item(169311, {13, 14}),
  AzsharasFontofPower              = Item(169314, {13, 14}),
}

Item.Warrior.Arms = {
  PotionofUnbridledFury            = Item(169299),
  PocketsizedComputationDevice     = Item(167555, {13, 14}),
  AshvanesRazorCoral               = Item(169311, {13, 14}),
  AzsharasFontofPower              = Item(169314, {13, 14}),
}

Item.Warrior.Protection = {
  PotionofUnbridledFury            = Item(169299),
  PocketsizedComputationDevice     = Item(167555, {13, 14}),
  AshvanesRazorCoral               = Item(169311, {13, 14}),
  AzsharasFontofPower              = Item(169314, {13, 14})
}
