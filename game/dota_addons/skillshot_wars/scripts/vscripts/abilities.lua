function DummyAbility(keys)
	caster = keys.caster
	print (caster:GetUnitName())
	for i=0,6 do
		local item = caster:GetItemInSlot(i)
		if item ~= nil and item:GetAbilityName() == "item_dummy" then
			caster:RemoveItem(item)
		end
		item = nil
	end

end