local M = {
	player_upgrades_base = {
		heal = 5,
		health = 10,
		damage = 0,
		missile = 0,  -- Track if missile shooting is unlocked
		spray = 0,  -- Track extra projectiles unlocked
		shoot_back = 0,  -- Track backward shooting upgrade
	},
	player_upgrades_increment = {
		heal = 10,
		health = 10,
		damage = 50
	},
	car_upgrades_base = {
		max_speed = 0,
		max_health = 0,
		heal = 50
	},
	car_upgrades_increment = {
		max_speed = 200,
		max_health = 50,
		heal = 10
	},
	upgrade_costs = { -- a max_purchase of -1 means can be bought infinitley 
		player = {
			heal = {cost = 50, max_purchases = 3},
			health = {cost = 100, max_purchases = -1},
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
	player_money = 500,  -- Starting currency
	player_purchase_counts = { player = {}, car = {} }
}

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
	elseif upgrade == "missile" then
		M.player_upgrades_base[upgrade] = 1  -- Unlock missile
		print("Missile Upgrade Applied!")
	elseif upgrade == "spray" then
		M.player_upgrades_base[upgrade] = 1  -- Unlock extra projectiles
		print("Extra Projectiles Upgrade Applied!")
	elseif upgrade == "shoot_back" then
		M.player_upgrades_base[upgrade] = 1  -- Unlock shoot-back functionality
		print("Shoot Back Upgrade Applied!")
	else
		print("Invalid Player Upgrade: ", upgrade)
	end
end

function M.apply_car_upgrade(upgrade)
	if M.car_upgrades_increment[upgrade] then
		M.car_upgrades_base[upgrade] = M.car_upgrades_increment[upgrade] + M.car_upgrades_base[upgrade]
		print("Car Upgrade Applied: ", upgrade, " -> ", M.car_upgrades_base[upgrade])
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
	local max_purchases = upgrade_data.max_purchases
	local current_purchases = M.player_purchase_counts[entity][upgrade] or 0

	if current_purchases >= max_purchases then
		print("Max purchases reached for upgrade: " .. upgrade)
		return false
	end
	
	if M.player_money < cost then
		print("Not enough money! Need: " .. cost .. ", Have: " .. M.player_money)
		return false
	end

	M.player_money = M.player_money - cost
	M.player_purchase_counts[entity][upgrade] = current_purchases + 1
	
	if entity == "player" then
		M.apply_player_upgrade(upgrade)
	elseif entity == "car" then
		M.apply_car_upgrade(upgrade)
	end

	print("Bought upgrade:", upgrade, "New Balance:", M.player_money)
	return true
end

return M
