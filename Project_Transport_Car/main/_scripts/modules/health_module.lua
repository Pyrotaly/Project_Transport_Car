-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
-- health_manager.lua
local M = {}

local pers_data = require("main._scripts.modules.persistant_data_module")
local playerUpgrade = require("main._scripts.modules.upgrades_module")
local enemyScaling = require("main._scripts.modules.enemy_scaling_module")

function M.init(entity)
	entity.health_type = hash(entity.health_type) or hash("player")

	if entity.health_type == hash("player") then
		entity.health = entity.max_health + playerUpgrade.player_upgrades_base.health
	elseif entity.health_type == hash("car") then
		entity.health = entity.max_health + playerUpgrade.car_upgrades_base.max_health
	else
		entity.health = entity.max_health + enemyScaling.upgraded_health
	end
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
	-- TODO: add currency
	-- TODO: explsoion 
	
	if entity.health_type == hash("enemy") then
		pers_data.adjust_currency(40)
	end
	
	go.delete()
end

return M
