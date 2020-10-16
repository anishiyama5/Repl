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
local Item       = HL.Item
-- HeroRotation
local HR         = HeroRotation
local AoEON      = HR.AoEON
local CDsON      = HR.CDsON

-- Azerite Essence Setup
local AE         = DBC.AzeriteEssences
local AESpellIDs = DBC.AzeriteEssenceSpellIDs
local AEMajor    = HL.Spell:MajorEssence()

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Define S/I for spell and item arrays
local S = Spell.Warrior.Fury
local I = Item.Warrior.Fury
if AEMajor ~= nil then
  S.HeartEssence                          = Spell(AESpellIDs[AEMajor.ID])
end

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
  I.AshvanesRazorCoral:ID(),
  I.AzsharasFontofPower:ID(),
}

-- Rotation Var
local ShouldReturn -- Used to get the return string
local Enemies8y, Enemies20y
local EnemiesCount8, EnemiesCount20

-- GUI Settings
local Everyone = HR.Commons.Everyone
local Settings = {
  General = HR.GUISettings.General,
  Commons = HR.GUISettings.APL.Warrior.Commons,
  Fury = HR.GUISettings.APL.Warrior.Fury
}

-- Interrupts List
local StunInterrupts = {
  {S.StormBolt, "Cast Storm Bolt (Interrupt)", function () return true; end},
  {S.IntimidatingShout, "Cast Intimidating Shout (Interrupt)", function () return true; end},
}

HL:RegisterForEvent(function()
  S.ConcentratedFlame:RegisterInFlight()
end, "AZERITE_ESSENCE_ACTIVATED")
S.ConcentratedFlame:RegisterInFlight()

-- Variables
--local VarPoolingForMeta = false


HL:RegisterForEvent(function()
  --VarPoolingForMeta = false
end, "PLAYER_REGEN_ENABLED")

local function num(val)
  if val then return 1 else return 0 end
end

local function bool(val)
  return val ~= 0
end

local function Precombat()
  --# Executed before combat begins. Accepts non-harmful actions only.
  --actions.precombat=flask
  --actions.precombat+=/food
  --actions.precombat+=/augmentation
  --# Snapshot raid buffed stats before combat begins and pre-potting is done.
  --actions.precombat+=/snapshot_stats
  --actions.precombat+=/use_item,name=azsharas_font_of_power
  --actions.precombat+=/worldvein_resonance
  --actions.precombat+=/memory_of_lucid_dreams
  --actions.precombat+=/guardian_of_azeroth
  --actions.precombat+=/recklessness
  --actions.precombat+=/potion
end

local function Movement()
  --actions.movement=heroic_leap
end

local function SingleTarget()
  --actions.single_target=siegebreaker
  --actions.single_target+=/rampage,if=(buff.recklessness.up|buff.memory_of_lucid_dreams.up)|(buff.enrage.remains<gcd|rage>90)
  --actions.single_target+=/execute
  --actions.single_target+=/bladestorm,if=prev_gcd.1.rampage
  --actions.single_target+=/bloodthirst,if=buff.enrage.down|azerite.cold_steel_hot_blood.rank>1
  --actions.single_target+=/onslaught
  --actions.single_target+=/dragon_roar,if=buff.enrage.up
  --actions.single_target+=/raging_blow,if=charges=2
  --actions.single_target+=/bloodthirst
  --actions.single_target+=/raging_blow
  --actions.single_target+=/whirlwind
end

---- Action List ----

local function APL()
  UpdateRanges()
  Everyone.AoEToggleEnemiesUpdate()
  --UpdateExecuteID()

  -- call precombat
  if not Player:AffectingCombat() then
    local ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
  end
  if Everyone.TargetIsValid() then
    --# Executed every time the actor is available.
    --actions=auto_attack
    --actions+=/charge
    if S.Charge:IsReady() and S.Charge:ChargesP() >= 1 then
      if HR.Cast(S.Charge, Settings.Fury.GCDasOffGCD.Charge) then return "charge"; end
    end
    --# This is mostly to prevent cooldowns from being accidentally used during movement.
    --actions+=/run_action_list,name=movement,if=movement.distance>5
    --actions+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)
    --actions+=/rampage,if=cooldown.recklessness.remains<3&talent.reckless_abandon.enabled
    --actions+=/blood_of_the_enemy,if=(buff.recklessness.up|cooldown.recklessness.remains<1)&(rage>80&(buff.meat_cleaver.up&buff.enrage.up|spell_targets.whirlwind=1)|dot.noxious_venom.remains)
    --actions+=/purifying_blast,if=!buff.recklessness.up&!buff.siegebreaker.up
    --actions+=/ripple_in_space,if=!buff.recklessness.up&!buff.siegebreaker.up
    --actions+=/worldvein_resonance,if=!buff.recklessness.up&!buff.siegebreaker.up
    --actions+=/focused_azerite_beam,if=!buff.recklessness.up&!buff.siegebreaker.up
    --actions+=/reaping_flames,if=!buff.recklessness.up&!buff.siegebreaker.up
    --actions+=/concentrated_flame,if=!buff.recklessness.up&!buff.siegebreaker.up&dot.concentrated_flame_burn.remains=0
    --actions+=/the_unbound_force,if=buff.reckless_force.up
    --actions+=/guardian_of_azeroth,if=!buff.recklessness.up&(target.time_to_die>195|target.health.pct<20)
    --actions+=/memory_of_lucid_dreams,if=!buff.recklessness.up
    --actions+=/recklessness,if=gcd.remains=0&(!essence.condensed_lifeforce.major&!essence.blood_of_the_enemy.major|cooldown.guardian_of_azeroth.remains>1|buff.guardian_of_azeroth.up|buff.blood_of_the_enemy.up)
    --actions+=/whirlwind,if=spell_targets.whirlwind>1&!buff.meat_cleaver.up
    --actions+=/use_item,name=ashvanes_razor_coral,if=target.time_to_die<20|!debuff.razor_coral_debuff.up|(target.health.pct<30.1&debuff.conductive_ink_debuff.up)|(!debuff.conductive_ink_debuff.up&buff.memory_of_lucid_dreams.up|prev_gcd.2.guardian_of_azeroth|prev_gcd.2.recklessness&(!essence.memory_of_lucid_dreams.major&!essence.condensed_lifeforce.major))
    if (HR.CDsON()) then
      --actions+=/blood_fury,if=buff.recklessness.up
      --actions+=/berserking,if=buff.recklessness.up
      --actions+=/lights_judgment,if=buff.recklessness.down&debuff.siegebreaker.down
      --actions+=/fireblood,if=buff.recklessness.up
      --actions+=/ancestral_call,if=buff.recklessness.up
      --actions+=/bag_of_tricks,if=buff.recklessness.down&debuff.siegebreaker.down&buff.enrage.up
    end
    --actions+=/run_action_list,name=single_target
    if (true) then
      return SingleTarget();
    end
  end

end

local function Init()

end

HR.SetAPL(72, APL, Init)
--- SIMC APL----
--# Executed before combat begins. Accepts non-harmful actions only.
--actions.precombat=flask
--actions.precombat+=/food
--actions.precombat+=/augmentation
--# Snapshot raid buffed stats before combat begins and pre-potting is done.
--actions.precombat+=/snapshot_stats
--actions.precombat+=/use_item,name=azsharas_font_of_power
--actions.precombat+=/worldvein_resonance
--actions.precombat+=/memory_of_lucid_dreams
--actions.precombat+=/guardian_of_azeroth
--actions.precombat+=/recklessness
--actions.precombat+=/potion

--# Executed every time the actor is available.
--actions=auto_attack
--actions+=/charge
--# This is mostly to prevent cooldowns from being accidentally used during movement.
--actions+=/run_action_list,name=movement,if=movement.distance>5
--actions+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)
--actions+=/rampage,if=cooldown.recklessness.remains<3&talent.reckless_abandon.enabled
--actions+=/blood_of_the_enemy,if=(buff.recklessness.up|cooldown.recklessness.remains<1)&(rage>80&(buff.meat_cleaver.up&buff.enrage.up|spell_targets.whirlwind=1)|dot.noxious_venom.remains)
--actions+=/purifying_blast,if=!buff.recklessness.up&!buff.siegebreaker.up
--actions+=/ripple_in_space,if=!buff.recklessness.up&!buff.siegebreaker.up
--actions+=/worldvein_resonance,if=!buff.recklessness.up&!buff.siegebreaker.up
--actions+=/focused_azerite_beam,if=!buff.recklessness.up&!buff.siegebreaker.up
--actions+=/reaping_flames,if=!buff.recklessness.up&!buff.siegebreaker.up
--actions+=/concentrated_flame,if=!buff.recklessness.up&!buff.siegebreaker.up&dot.concentrated_flame_burn.remains=0
--actions+=/the_unbound_force,if=buff.reckless_force.up
--actions+=/guardian_of_azeroth,if=!buff.recklessness.up&(target.time_to_die>195|target.health.pct<20)
--actions+=/memory_of_lucid_dreams,if=!buff.recklessness.up
--actions+=/recklessness,if=gcd.remains=0&(!essence.condensed_lifeforce.major&!essence.blood_of_the_enemy.major|cooldown.guardian_of_azeroth.remains>1|buff.guardian_of_azeroth.up|buff.blood_of_the_enemy.up)
--actions+=/whirlwind,if=spell_targets.whirlwind>1&!buff.meat_cleaver.up
--actions+=/use_item,name=ashvanes_razor_coral,if=target.time_to_die<20|!debuff.razor_coral_debuff.up|(target.health.pct<30.1&debuff.conductive_ink_debuff.up)|(!debuff.conductive_ink_debuff.up&buff.memory_of_lucid_dreams.up|prev_gcd.2.guardian_of_azeroth|prev_gcd.2.recklessness&(!essence.memory_of_lucid_dreams.major&!essence.condensed_lifeforce.major))
--actions+=/blood_fury,if=buff.recklessness.up
--actions+=/berserking,if=buff.recklessness.up
--actions+=/lights_judgment,if=buff.recklessness.down&debuff.siegebreaker.down
--actions+=/fireblood,if=buff.recklessness.up
--actions+=/ancestral_call,if=buff.recklessness.up
--actions+=/bag_of_tricks,if=buff.recklessness.down&debuff.siegebreaker.down&buff.enrage.up
--actions+=/run_action_list,name=single_target

--actions.movement=heroic_leap

--actions.single_target=siegebreaker
--actions.single_target+=/rampage,if=(buff.recklessness.up|buff.memory_of_lucid_dreams.up)|(buff.enrage.remains<gcd|rage>90)
--actions.single_target+=/execute
--actions.single_target+=/bladestorm,if=prev_gcd.1.rampage
--actions.single_target+=/bloodthirst,if=buff.enrage.down|azerite.cold_steel_hot_blood.rank>1
--actions.single_target+=/onslaught
--actions.single_target+=/dragon_roar,if=buff.enrage.up
--actions.single_target+=/raging_blow,if=charges=2
--actions.single_target+=/bloodthirst
--actions.single_target+=/raging_blow
--actions.single_target+=/whirlwind
