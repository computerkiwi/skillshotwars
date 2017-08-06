modifier_meat_hook_skill_followthrough = class({})

--------------------------------------------------------------------------------

function modifier_meat_hook_skill_followthrough:IsHidden()
	return true
end


--------------------------------------------------------------------------------

function modifier_meat_hook_skill_followthrough:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
