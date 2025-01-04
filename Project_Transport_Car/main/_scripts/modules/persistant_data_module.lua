-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local M = {
	selected_nodes = {},
	day_number = 1,
	player_currency = 500
}

function M.mark_selected(node_name)
	M.selected_nodes[node_name] = true
end

function M.is_selected(node_name)
	return M.selected_nodes[node_name] or false
end

function M.get_currency()
	return M.player_currency
end

function M.adjust_currency(adjust_amount)
	M.player_currency = M.player_currency + adjust_amount
end

function M.get_day_number()
	return M.day_number
end

function M.add_day()
	M.day_number = M.day_number + 1
end

return M
