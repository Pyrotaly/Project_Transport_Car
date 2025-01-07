-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
-- visual_handler.lua
local M = {}

-- Function to flash red when damaged
function M.flash_red(entity)
	if not entity or not entity.spriteUrl then 
		return 
	end

	go.set(entity.spriteUrl, "tint", vmath.vector4(1, 0, 0, 1))

	timer.delay(0.01, false, function()
		go.set(entity.spriteUrl, "tint", vmath.vector4(1, 1, 1, 1)) -- Reset to normal
	end)
end

-- Function to shake the screen (optional)
function M.screen_shake(intensity, duration)
	msg.post("@render:", "shake", { intensity = intensity, duration = duration })
end

-- Function to trigger explosion effect on death
function M.spawn_explosion(entity)
	-- Assuming an explosion factory is used
	if entity and entity.position then
		local explosion = factory.create("#explosion_factory", entity.position)
	end
end

return M
