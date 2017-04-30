require('win_condition')

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  DebugPrint('[BAREBONES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local killerHero   = PlayerResource:GetSelectedHeroEntity( keys.killer_userid )
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber

  -- Give the killer some gold.
  if killer ~= nil then
    --Give killer extra bounty.
    killer:ModifyGold(25, true, DOTA_ModifyGold_HeroKill)
  end

  --Give killer's team bounty.
  local allHeroes = HeroList:GetAllHeroes()
  for index,hero in pairs(allHeroes) do
    if (hero:GetTeamNumber() == killerTeamNumber) then
      hero:ModifyGold(20,true,DOTA_ModifyGold_HeroKill)
    end
  end

  CheckWin(killerTeamNumber, numKills)
end