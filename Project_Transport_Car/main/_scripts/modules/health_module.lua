-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
-- health_manager.lua
local M = {}

local camera = require "orthographic.camera"

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
	
	sound.play(entity.onHit, { delay = 0, gain = 2, pan = 0, speed = 1 })
	-- Set different time-steps based on the entity type
	if entity.health_type == hash("player") then
		msg.post("0_game_managers:/proxy_loader#proxy_level_2", "set_time_step", { factor = 0.7, mode = 1 })
		camera.shake(hash("/camera"), 0.009, 0.1, hash("both"))
		
		timer.delay(0.25, false, function()
			msg.post("2_combat_zone:/2_gui_player_menu/go#main_game", "updateHealth", { healthAdjust = damage })

			-- TODO : make the set time step update to loaded proxy so
			msg.post("0_game_managers:/proxy_loader#proxy_level_2", "set_time_step", {factor = 1, mode = 1})
		end)
	end
end

-- Event triggered when the entity dies
function M.on_death(entity, damage)
	particlefx.play(entity.explosionPfx)
	sound.play(entity.explosionSound, { delay = 0, gain = 1, pan = 0, speed = 1 })
	if entity.health_type == hash("player") then
		msg.post("0_game_managers:/proxy_loader#proxy_level_2", "set_time_step", { factor = 1, mode = 1 })
		msg.post("2_combat_zone:/2_gui_player_menu/go#main_game", "updateHealth", { healthAdjust = damage })
		msg.post("2_combat_zone:/game_over_ui#restart_menu", "playerDied")
		
	else
		msg.post("2_combat_zone:/game_over_ui#restart_menu", "finishCombatZone")
		if entity.health_type == hash("enemy") then
			pers_data.adjust_currency(98)
		end
		
	end

	timer.delay(0.2, false, function()
		go.delete(entity.id)  -- Ensure you're deleting the correct entity
	end)
end

return M
