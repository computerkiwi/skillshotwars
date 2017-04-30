-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Not sure what this is for.
  PrecacheResource( "soundfile", "*.vsndevts", context )

  -- Precache the heroes we use abilities of.
  PrecacheUnitByNameSync("npc_dota_hero_pudge",context)
  PrecacheUnitByNameSync("npc_dota_hero_mirana",context)
  PrecacheUnitByNameSync("npc_dota_hero_rattletrap",context)
  PrecacheUnitByNameSync("npc_dota_hero_invoker",context)

  -- Needed for scout bot.
  PrecacheUnitByNameSync("npc_dota_hero_tinker",context)

  -- Precache blink dagger.
  PrecacheItemByNameSync( "item_blink_skill", context )

  -- Needed for gem of vengance.
  PrecacheUnitByNameSync("npc_dota_hero_vengefulspirit",context)

  -- Not sure why techies is needed.
  PrecacheUnitByNameSync("npc_dota_hero_techies",context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end
