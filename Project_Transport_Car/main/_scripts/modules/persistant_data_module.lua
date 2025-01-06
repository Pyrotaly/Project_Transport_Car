-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local M = {
	selected_nodes = {},
	day_number = 1,
	latest_selected = nil,
	player_currency = 500
}

function M.mark_selected(node_name, x, y, level)
	M.selected_nodes[node_name] = {x = x, y = y, level = level}
	M.latest_selected = node_name
end

function M.get_latest_selected()
	-- Return full data of the latest selection (coordinates & level)
	if M.latest_selected then
		return M.selected_nodes[M.latest_selected]
	end
	return { x = 0, y = 5, level = 0 }
end

function M.is_selected(node_name)
	return M.selected_nodes[node_name] or false
end

function M.get_currency()
	return M.player_currency
end

function M.adjust_currency(adjust_amount)
	M.player_currency = M.player_currency + adjust_amount
	msg.post("gui_player_menu:/go#main_game", "updateCurrency", { newCurrencyTotal = M.player_currency })
end

function M.get_day_number()
	return M.day_number
end

function M.add_day()
	M.day_number = M.day_number + 1
end

return M
