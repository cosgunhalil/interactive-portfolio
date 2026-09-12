--- Pure movement math shared by every input source (keyboard now, virtual joystick later).
-- No engine calls in here so it stays trivially testable and reusable.
local M = {}

--- Player speed in pixels per second.
M.SPEED = 260

--- Build a direction vector from four boolean axes.
-- @return vector3 unit-length or zero
function M.direction(up, down, left, right)
	local x = (right and 1 or 0) - (left and 1 or 0)
	local y = (up and 1 or 0) - (down and 1 or 0)
	local dir = vmath.vector3(x, y, 0)
	if x ~= 0 and y ~= 0 then
		dir = vmath.normalize(dir)
	end
	return dir
end

--- Advance a position along a direction for one frame.
-- @param position vector3 current position
-- @param dir vector3 direction, unit length or zero
-- @param dt number seconds since last frame
-- @param speed number optional pixels per second, defaults to M.SPEED
-- @return vector3 new position
function M.step(position, dir, dt, speed)
	return position + dir * ((speed or M.SPEED) * dt)
end

return M
