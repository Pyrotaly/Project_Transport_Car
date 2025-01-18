-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local M = {}

M.GRID_ROWS = 5
M.GRID_COLS = 5
M.SCREEN_WIDTH = 1280
M.SCREEN_HEIGHT = 720

M.CELL_WIDTH = M.SCREEN_WIDTH / M.GRID_COLS
M.CELL_HEIGHT = M.SCREEN_HEIGHT / M.GRID_ROWS

function M.get_quadrant(position)
	local col = math.floor(position.x / M.CELL_WIDTH)
	local row = math.floor(position.y / M.CELL_HEIGHT)
	print(row * M.GRID_COLS + col + 1)
	return row * M.GRID_COLS + col + 1
end

function M.get_quadrant_position(quadrant)
	local row = math.floor((quadrant - 1) / M.GRID_COLS)
	local col = (quadrant - 1) % M.GRID_COLS

	print(vmath.vector3(
	(col * M.CELL_WIDTH) + (M.CELL_WIDTH / 2),
	(row * M.CELL_HEIGHT) + (M.CELL_HEIGHT / 2),
	0
))
	
	return vmath.vector3(
	(col * M.CELL_WIDTH) + (M.CELL_WIDTH / 2),
	(row * M.CELL_HEIGHT) + (M.CELL_HEIGHT / 2),
	0
)
end

function M.get_adjacent_quadrants(quadrant)
	local adjacent = {}

	-- Offsets based on a grid with M.GRID_COLS columns
	local offsets = {
		{ name = "Left", offset = -1 },
		{ name = "Right", offset = 1 },
		{ name = "Up", offset = M.GRID_COLS },
		{ name = "Down", offset = -M.GRID_COLS },
		{ name = "Top Right", offset = M.GRID_COLS + 1 },
		{ name = "Top Left", offset = M.GRID_COLS - 1 },
		{ name = "Bottom Right", offset = -M.GRID_COLS + 1 },
		{ name = "Bottom Left", offset = -M.GRID_COLS - 1 }
	}

	for _, dir in ipairs(offsets) do
		local neighbor = quadrant + dir.offset

		-- Ensure the neighbor stays within valid bounds
		if neighbor >= 1 and neighbor <= (M.GRID_COLS * M.GRID_ROWS) then
			table.insert(adjacent, neighbor)
		end
	end

	return adjacent
end


-- Function to draw the grid
function M.draw_grid()
	-- Draw vertical lines
	for i = 1, M.GRID_COLS - 1 do
		local x = i * M.CELL_WIDTH
		local from = vmath.vector3(x, 0, 0)
		local to = vmath.vector3(x, M.SCREEN_HEIGHT, 0)
		msg.post("@render:", "draw_line", { start_point = from, end_point = to, color = vmath.vector4(1, 0, 0, 1) }) -- Red lines
	end

	-- Draw horizontal lines
	for j = 1, M.GRID_ROWS - 1 do
		local y = j * M.CELL_HEIGHT
		local from = vmath.vector3(0, y, 0)
		local to = vmath.vector3(M.SCREEN_WIDTH, y, 0)
		msg.post("@render:", "draw_line", { start_point = from, end_point = to, color = vmath.vector4(1, 0, 0, 1) }) -- Red lines
	end
end

return M
