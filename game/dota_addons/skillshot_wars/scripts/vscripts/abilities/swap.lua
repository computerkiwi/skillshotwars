function swap_ability(keys)
	local caster = keys.caster
	local target = keys.target
	local casterPos = caster:GetAbsOrigin()
	local targetPos = target:GetAbsOrigin() 
	target:SetAbsOrigin(casterPos)
	caster:SetAbsOrigin(targetPos)
end