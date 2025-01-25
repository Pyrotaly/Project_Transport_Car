local M = {
	player_upgrades_base = {
		-- heal = 5,
		-- health = 10,
		bigger_mag = 5,
		reduce_spread = 0,
		damage = 0,
		missile = 0,  -- Track if missile shooting is unlocked
		spray = 0,  -- Track extra projectiles unlocked
		shoot_back = 0,  -- Track backward shooting upgrade
	},
	player_upgrades_increment = {
		-- heal = 10,
		-- health = 10,
		bigger_mag = 5,
		reduce_spread = 3,
		damage = 5,
		missile = 1,
		spray = 1,  -- Track extra projectiles unlocked
		shoot_back = 1,  -- Track backward shooting upgrade
	},
	car_upgrades_base = {
		max_speed = 0,
		max_health = 0,
		heal = 50
	},
	car_upgrades_increment = {
		max_speed = 200,
		max_health = 50,
		heal = 0
	},
	upgrade_costs = { -- a max_purchase of -1 means can be bought infinitley 
		player = {
			-- heal = {cost = 50, max_purchases = 3},
			-- health = {cost = 100, max_purchases = -1},
			bigger_mag = {cost = 50, max_purchases = 3},
			reduce_spread = {cost = 50, max_purchases = 3},
			damage = {cost = 75, max_purchases = -1},
			missile = {cost = 200, max_purchases = 1},
			spray = {cost = 150, max_purchases = 1},
			shoot_back = {cost = 100, max_purchases = 1},
		},
		car = {
			max_speed = {cost = 200, max_purchases = 5},
			max_health = {cost = 150, max_purchases = 5},
			heal = 100
		}
	},
	player_purchase_counts = { player = {}, car = {} }
}

local pers_data = require("main._scripts.modules.persistant_data_module")

function M.reset_heal_purchase_count()
	M.purchase_counts.player["heal"] = 0
	M.purchase_counts.car["heal"] = 0
end

function M.get_upgrade_value(entity, upgrade)
	if entity == "player" then
		return (M.player_upgrades_base[upgrade] or 0)
	elseif entity == "car" then
		return (M.car_upgrades_base[upgrade] or 0)
	end
end

function M.apply_player_upgrade(upgrade)
	if M.player_upgrades_increment[upgrade] then
		M.player_upgrades_base[upgrade] = M.player_upgrades_increment[upgrade] + M.player_upgrades_base[upgrade]
		print("Player Upgrade Applied: ", upgrade, " -> ", M.player_upgrades_base[upgrade])
		
		-- Upgrades should only be possible in the upgrade level so the player will always be in proxy collection 4
		msg.post("4_upgrade_area:/player/player#player_controller", "upgradeOccured")
	else
		print("Invalid Player Upgrade: ", upgrade)
	end
end

function M.apply_car_upgrade(upgrade)
	if M.car_upgrades_increment[upgrade] then
		M.car_upgrades_base[upgrade] = M.car_upgrades_increment[upgrade] + M.car_upgrades_base[upgrade]
		print("Car Upgrade Applied: ", upgrade, " -> ", M.car_upgrades_base[upgrade])

		-- Upgrades should only be possible in the upgrade level so the player will always be in proxy collection 4
		msg.post("4_upgrade_area:/player/player#player_controller", "upgradeOccured")

		if upgrade == "max_health" then
			msg.post("gui_player_menu:/go#main_game", "updateHealth", { healthAdjust = - M.car_upgrades_increment[upgrade] })
		end
	else
		print("Invalid Car Upgrade: ", upgrade)
	end
end

function M.buy_upgrade(entity, upgrade)
	local upgrade_data = M.upgrade_costs[entity] and M.upgrade_costs[entity][upgrade]

	if not upgrade_data then
		print("Invalid upgrade: " .. upgrade)
		return false
	end

	local cost = upgrade_data.cost
	local player_currency = pers_data.get_currency()
	local max_purchases = upgrade_data.max_purchases
	local current_purchases = M.player_purchase_counts[entity][upgrade] or 0

	if current_purchases >= max_purchases then
		print("Max purchases reached for upgrade: " .. upgrade)
		return false
	end
	
	if player_currency < cost then
		print("Not enough money! Need: " .. cost .. ", Have: " .. pers_data.get_currency())
		return false
	end

	-- M.player_money = M.player_money - cost
	pers_data.adjust_currency(-cost)
	M.player_purchase_counts[entity][upgrade] = current_purchases + 1
	
	if entity == "player" then
		M.apply_player_upgrade(upgrade)
	elseif entity == "car" then
		M.apply_car_upgrade(upgrade)
	end

	print("Bought upgrade:", upgrade, "New Balance:", pers_data.get_currency())
	return true
end

return M
