-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
-- health_manager.lua
local M = {}

local pers_data = require("main._scripts.modules.persistant_data_module")
local playerUpgrade = require("main._scripts.modules.upgrades_module")
local enemyScaling = require("main._scripts.modules.enemy_scaling_module")
local visualHandler = require("main._scripts.modules.entity_visual_module")

function M.init(entity)
	entity.health_type = hash(entity.health_type) or hash("player")

	-- if entity.health_type == hash("player") then
	-- 	entity.health = entity.max_health + playerUpgrade.player_upgrades_base.health

	
	-- RN car is the player cause player driving their car
	if entity.health_type == hash("player") then
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
	
	visualHandler.flash_red(entity)

	entity.health = entity.health - damage

	if entity.health <= 0 then
		M.on_death(entity, damage)
	else
		M.on_damage(entity, damage)
	end
end

-- Event triggered when the entity takes damage
function M.on_damage(entity, damage)
	-- Add your own damage logic or animations here

	-- Set different time-steps based on the entity type
	if entity.health_type == hash("player") then
		timer.delay(0.25, false, function()
			print(damage)
			msg.post("gui_player_menu:/go#main_game", "updateHealth", { healthAdjust = damage })

			-- TODO : make the set time step update to loaded proxy so
			msg.post("0_game_managers:/proxy_loader#proxy_level_2", "set_time_step", {factor = 1, mode = 1})
		end)
	else
		timer.delay(0.005, false, function()
			-- TODO : make the set time step update to loaded proxy so
			msg.post("0_game_managers:/proxy_loader#proxy_level_2", "set_time_step", {factor = 1, mode = 1})
		end)
	end
end

-- Event triggered when the entity dies
function M.on_death(entity, damage)
	print("has died!")
	-- Add your own death logic here, like playing an animation or removing the entity

	-- Set different time-steps based on the entity type
	if entity.health_type == hash("player") then
		timer.delay(0.025, false, function()
			-- TODO : make the set time step update to loaded proxy so
			msg.post("0_game_managers:/proxy_loader#proxy_level_2", "set_time_step", {factor = 1, mode = 1})
			msg.post("gui_player_menu:/go#main_game", "updateHealth", { healthAdjust = damage })
			-- TODO: game over screen
			msg.post("0_game_managers:/proxy_loader#proxy_level_2", "set_time_step", {factor = 0, mode = 1})
			msg.post("0_game_managers:/game_manager_go#game_manager", "gameOver")
			go.delete()
		end)
	else
		timer.delay(0.005, false, function()
			-- TODO : make the set time step update to loaded proxy so
			msg.post("0_game_managers:/proxy_loader#proxy_level_2", "set_time_step", {factor = 1, mode = 1})

			if entity.health_type == hash("enemy") then
				pers_data.adjust_currency(40)
			end

			go.delete()
		end)
	end
end

return M
