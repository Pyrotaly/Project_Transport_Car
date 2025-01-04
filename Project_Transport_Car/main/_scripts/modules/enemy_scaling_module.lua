-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local pers_data = require("main._scripts.modules.persistant_data_module")

local M = {
	upgraded_health = 0,
	upgraded_damage = 0
}

-- Function to scale enemy stats
function M.scale_enemy_stats()
	-- For every day, increase health and damage
	local days = pers_data.get_day_number()
	
	M.upgraded_health = (100 * days)
	M.upgraded_damage = (50 * days)

	-- Apply scaled stats to enemies
	-- Assuming you have access to your enemies, apply the health and damage here
	-- e.g., for each enemy:
	-- enemy.health = health
	-- enemy.damage = damage
end

return M
