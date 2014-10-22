-- Generated from template

require("abilities")

if CSkillshotWarsGameMode == nil then
	CSkillshotWarsGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
    	PrecacheResource( "soundfile", "*.vsndevts", context )
		PrecacheUnitByNameSync("npc_dota_hero_pudge",context)
		PrecacheUnitByNameSync("npc_dota_hero_mirana",context)
		PrecacheUnitByNameSync("npc_dota_hero_rattletrap",context)
		PrecacheUnitByNameSync("npc_dota_hero_invoker",context)
		PrecacheItemByNameSync( "item_blink_skill", context )
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CSkillshotWarsGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CSkillshotWarsGameMode:InitGameMode()
	CSkillshotWarsGameMode.teamDeaths = {}
	CSkillshotWarsGameMode.teamDeaths[2] = 0
	CSkillshotWarsGameMode.teamDeaths[3] = 0
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetUseCustomHeroXPValues(true)
	GameRules:SetHeroSelectionTime(15)
	GameRules:SetPreGameTime(15)
	GameRules:SetRuneSpawnTime(30)
    GameMode = GameRules:GetGameModeEntity()  
    GameMode:SetBuybackEnabled(false) 
	
	
	
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CSkillshotWarsGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CSkillshotWarsGameMode, "OnEntDeath" ), self )
	print( "Skillshot Wars is loaded." )
end

function CSkillshotWarsGameMode:OnNPCSpawned(event)
	local spawnedUnit = EntIndexToHScript( event.entindex )
	
	if spawnedUnit:IsRealHero() == true then
		if spawnedUnit:GetDeaths() == 0 then
			spawnedUnit:SetAbilityPoints(0)
			spawnedUnit:SetCustomDeathXP(0)
		
			pudge_meat_hook = Entities:FindByClassname(nil,"pudge_meat_hook")
			mirana_arrow = Entities:FindByName(nil,"mirana_arrow")
			sun_strike = Entities:FindByName(nil,"sun_strike_skill")
			rattletrap_hookshot = Entities:FindByClassname(nil,"rattletrap_hookshot")
			spawnedUnit:UpgradeAbility(pudge_meat_hook)
			spawnedUnit:UpgradeAbility(mirana_arrow)
			spawnedUnit:UpgradeAbility(sun_strike)
			spawnedUnit:UpgradeAbility(rattletrap_hookshot)
			spawnedUnit:SetGold(0,false)
			spawnedUnit:SetGold(150,true)
		end
	end

end

function CSkillshotWarsGameMode:OnEntDeath(event)
	local deadUnit = EntIndexToHScript( event.entindex_killed )
	teamNumber = deadUnit:GetTeamNumber()
	CSkillshotWarsGameMode.teamDeaths[teamNumber] = CSkillshotWarsGameMode.teamDeaths[teamNumber] + 1
	if CSkillshotWarsGameMode.teamDeaths[teamNumber] >= 50 then
		GameRules:MakeTeamLose(teamNumber)
	end
end

-- Evaluate the state of the game
function CSkillshotWarsGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end