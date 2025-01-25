-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local M = {}

M.GRID_ROWS = 6
M.GRID_COLS = 20
M.SCREEN_WIDTH = 1280 * 2.5
M.SCREEN_HEIGHT = 720 * 1.5

M.CELL_WIDTH = M.SCREEN_WIDTH / M.GRID_COLS
M.CELL_HEIGHT = M.SCREEN_HEIGHT / M.GRID_ROWS

M.occupied_quadarnts = {}

for i = 1, (M.GRID_ROWS * M.GRID_COLS) do
	M.occupied_quadarnts[i] = false
end

function M.get_quadrant(position)
	local col = math.floor(position.x / M.CELL_WIDTH)
	local row = math.floor(position.y / M.CELL_HEIGHT)
	return row * M.GRID_COLS + col + 1
end

function M.get_quadrant_position(quadrant)
	local row = math.floor((quadrant - 1) / M.GRID_COLS)
	local col = (quadrant - 1) % M.GRID_COLS

	-- print(vmath.vector3(
	-- (col * M.CELL_WIDTH) + (M.CELL_WIDTH / 2),
	-- (row * M.CELL_HEIGHT) + (M.CELL_HEIGHT / 2),
	-- 0

	
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

function M.get_random_nearby_quadrant(current_quadrant, range)
	local nearby_quadrants = {}

	-- Calculate the current row and column
	local current_row = math.ceil(current_quadrant / M.GRID_COLS)
	local current_col = (current_quadrant) % M.GRID_COLS

	-- Loop through all possible quadrants within the range
	for row_offset = -range, range do
		for col_offset = -range, range do
			local new_row = current_row + row_offset
			local new_col = current_col + col_offset

			-- Ensure the move does not cross rows inappropriately
			if math.abs(row_offset) + math.abs(col_offset) <= range then
				-- Check if the new position is valid
				if new_row >= 1 and new_row <= M.GRID_ROWS and new_col >= 1 and new_col <= M.GRID_COLS then
					-- Calculate the new quadrant number
					local new_quadrant = (new_row - 1) * M.GRID_COLS + new_col

					-- Ensure the new quadrant is on the correct row for left/right moves
					local valid_horizontal_move = true
					if col_offset ~= 0 then
						local target_row = math.ceil(new_quadrant / M.GRID_COLS)
						valid_horizontal_move = target_row == new_row
					end

					if valid_horizontal_move then
						table.insert(nearby_quadrants, new_quadrant)
					end
				end
			end
		end
	end

	-- Pick a random quadrant from the list of valid nearby quadrants
	if #nearby_quadrants > 0 then
		return nearby_quadrants[math.random(#nearby_quadrants)]
	else
		return nil -- No valid nearby quadrants
	end

	-- -- Pick a random quadrant from the list of valid nearby quadrants
	-- if #nearby_quadrants > 0 then
	-- 	return nearby_quadrants[math.random(#nearby_quadrants)]
	-- else
	-- 	return nil -- No valid nearby quadrants
	-- end
end


-- function M.get_random_nearby_quadrant(current_quadrant, range)
-- 	local nearby_quadrants = {}
-- 
-- 	-- Iterate over the range (-range to +range) for both rows and columns
-- 	for row_offset = -range, range do
-- 		for col_offset = -range, range do
-- 			-- Calculate the potential neighbor quadrant
-- 			local row = math.floor((current_quadrant - 1) / M.GRID_COLS) + row_offset
-- 			local col = ((current_quadrant - 1) % M.GRID_COLS) + col_offset
-- 
-- 			-- Ensure the row and column are within valid bounds
-- 			if row >= 0 and row < M.GRID_ROWS and col >= 0 and col < M.GRID_COLS then
-- 				local neighbor = (row * M.GRID_COLS) + col + 1
-- 
-- 				-- Check if the neighbor is not occupied
-- 				if not M.is_occupied(neighbor) then
-- 					table.insert(nearby_quadrants, neighbor)
-- 				end
-- 			end
-- 		end
-- 	end
-- 
-- 	-- Select a random quadrant from the valid nearby quadrants
-- 	if #nearby_quadrants > 0 then
-- 		return nearby_quadrants[math.random(#nearby_quadrants)]
-- 	else
-- 		return nil -- No available quadrants within range
-- 	end
-- end

function M.get_available_quadrants()
	local available_quadrants = {}
	for index, value in pairs(M.occupied_quadarnts) do
		if value == false then
			table.insert(available_quadrants, index)
		end
	end
	return available_quadrants
end

function M.is_occupied(quadrant)
	return M.occupied_quadarnts[quadrant] == true
end

function M.set_occupied(quadrant, occupied)
	M.occupied_quadarnts[quadrant] = occupied
end

-- ------------------------------------
-- Movement
-- ------------------------------------

-- TODO implement movement into quadrants instead of enemy ai necessarily
function M.move_to_quadrant(self, quadrant)
	if not M.is_occupied(quadrant) then
		local target_pos = M.get_quadrant_position(quadrant)

		go.animate(".", "position.x", go.PLAYBACK_ONCE_FORWARD, target_pos.x, go.EASING_LINEAR, 1.5)
		go.animate(".", "position.y", go.PLAYBACK_ONCE_FORWARD, target_pos.y, go.EASING_LINEAR, 1.5)

		-- Set the current quadrant as unoccupied
		if self.current_quadrant then
			M.set_occupied(self.current_quadrant, false)
		end

		-- Move to the new quadrant and mark it as occupied
		self.current_quadrant = quadrant
		M.set_occupied(quadrant, true)
	else
		print("Quadrant " .. quadrant .. " is already occupied!")
	end
end



-- ------------------------------------
-- DEBUGGING
-- ------------------------------------

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
