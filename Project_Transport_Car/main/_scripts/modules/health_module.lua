-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
-- health_manager.lua
local M = {}

function M.init(entity)
	entity.health = entity.max_health or 100
end

function M.apply_damage(entity, damage)
	if entity.health <= 0 then
		print("Entity is already dead")
		return
	end

	entity.health = entity.health - damage
	print("Entity health updated to:", entity.health)

	if entity.health <= 0 then
		M.on_death(entity)
	else
		M.on_damage(entity, damage)
	end
end

-- Event triggered when the entity takes damage
function M.on_damage(entity, damage)
	print(" took " .. damage .. " damage!")
	-- Add your own damage logic or animations here
end

-- Event triggered when the entity dies
function M.on_death(entity)
	print("has died!")
	-- Add your own death logic here, like playing an animation or removing the entity
	go.delete()
end

return M
