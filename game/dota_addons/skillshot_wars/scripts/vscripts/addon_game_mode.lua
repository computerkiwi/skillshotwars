-- Generated from template

require("abilities")
require('lib.statcollection')
require('lib.timers')

winKills = 50

statcollection.addStats({
	modID = 'cd3297faebbc8ddf3e80e3dd1515a264' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
})


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
		PrecacheUnitByNameSync("npc_dota_hero_tinker",context)
		PrecacheItemByNameSync( "item_blink_skill", context )
		PrecacheUnitByNameSync("npc_dota_hero_vengefulspirit",context)
		PrecacheUnitByNameSync("npc_dota_hero_techies",context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CSkillshotWarsGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CSkillshotWarsGameMode:SetReliableGold()
	for i = 0, 11, 1 do
		local unreliableGold = PlayerResource:GetUnreliableGold(i)
		local reliableGold = PlayerResource:GetReliableGold(i)
		PlayerResource:SetGold(i,0,false)
		PlayerResource:SetGold(i,unreliableGold+reliableGold,true)
	end
	return 1
end

function CSkillshotWarsGameMode:InitGameMode()
    local GameMode = GameRules:GetGameModeEntity()
	

	CSkillshotWarsGameMode.teamDeaths = {}
	CSkillshotWarsGameMode.teamDeaths[2] = 0
	CSkillshotWarsGameMode.teamDeaths[3] = 0
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetUseCustomHeroXPValues(true)
	GameRules:SetHeroSelectionTime(15)
	GameRules:SetPreGameTime(15)
	GameRules:SetRuneSpawnTime(30)
	GameRules:SetGoldPerTick(2)
    GameMode = GameRules:GetGameModeEntity()  
    GameMode:SetFountainPercentageHealthRegen(10)
    GameMode:SetBuybackEnabled(false) 
	GameMode:SetCustomHeroMaxLevel(1)	
	GameMode:SetLoseGoldOnDeath(false)
	--Set which runes are available
	GameMode:SetRuneEnabled( 0, true ) --Illusion
	GameMode:SetRuneEnabled( 1, true ) --Haste
	GameMode:SetRuneEnabled( 2, true ) --Double Damage
	GameMode:SetRuneEnabled( 3, false ) --Invis
	GameMode:SetRuneEnabled( 4, false ) --Regen
	GameMode:SetRuneEnabled( 5, false ) --Bounty
	
	
	
    GameMode:SetContextThink( "CSkillshotWarsGameMode:GameThink", function() return self:GameThink() end, 0.25 )
	--GameMode:SetContextThink("CSkillshotWarsGameMode:SetReliableGold",function() return self:SetReliableGold() end,0)
	
	
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( CSkillshotWarsGameMode, "OnHeroPicked" ), self )
	ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( CSkillshotWarsGameMode, "OnTeamKillCredit" ), self )
	print( "Skillshot Wars is loaded." )
end

playersAmount = 0


function CSkillshotWarsGameMode:OnHeroPicked(event)
	local spawnedUnit = EntIndexToHScript( event.heroindex )
	
	playersAmount = playersAmount + 1
	
	
	if spawnedUnit:IsRealHero() == true then --This line shouldn't be necessary anymore.
		if spawnedUnit:GetDeaths() == 0 then --If this is the first time spawning...
			spawnedUnit:SetAbilityPoints(0)
			
			--Get rid of default xp bounty
			spawnedUnit:SetCustomDeathXP(0)
			
			meat_hook_skill = Entities:FindByName(nil,"meat_hook_skill")
			arrow_skill = Entities:FindByName(nil,"arrow_skill")
			sun_strike = Entities:FindByName(nil,"sun_strike_skill")
			rattletrap_hookshot = Entities:FindByClassname(nil,"rattletrap_hookshot")
			spawnedUnit:UpgradeAbility(meat_hook_skill)
			spawnedUnit:UpgradeAbility(arrow_skill)
			spawnedUnit:UpgradeAbility(sun_strike)
			spawnedUnit:UpgradeAbility(rattletrap_hookshot)
			spawnedUnit:SetGold(0,false)
			spawnedUnit:SetGold(250,true)
		end
	end

end

function CSkillshotWarsGameMode:OnTeamKillCredit(event)
	local killer = PlayerResource:GetSelectedHeroEntity( event.killer_userid )
	local teamNumber = event.teamnumber
	if killer ~= nil then
		--Give killer extra bounty.
		killer:ModifyGold(25, true, DOTA_ModifyGold_HeroKill)
	end
	--Give killer's team bounty.
	local allHeroes = HeroList:GetAllHeroes()
	for index,hero in pairs(allHeroes) do
		if (hero:GetTeamNumber() == teamNumber) then
			hero:ModifyGold(20,true,DOTA_ModifyGold_HeroKill)
		end
	end
	if event.herokills >= winKills then --This number is how many points needed to win.
		GameRules:SetGameWinner(teamNumber)
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



function CSkillshotWarsGameMode:GameThink()
    -- Check to see if the game has finished
    if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		print("1")
        -- Send stats
        statcollection.sendStats()

        -- Delete the thinker
        return
    else
        -- Check again in 1 second
        return 1
    end
end