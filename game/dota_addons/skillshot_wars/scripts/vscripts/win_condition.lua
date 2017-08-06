-- Handles the win condition.

WIN_CONDITION_KILLCOUNT = 50

-- Takes a team id and a killcount and ends the game if it's passed the win condition.
function CheckWin(team, killCount)
  if killCount >= WIN_CONDITION_KILLCOUNT then --This number is how many points needed to win.
    GameRules:SetGameWinner(team)
  end
end
