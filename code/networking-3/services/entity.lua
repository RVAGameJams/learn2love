-- entity.lua

local input_service = require('services/input')
local entity_service = {}

-- The entity that we control and emit updates for
entity_service.player_id = nil
-- All player entities
entity_service.entities = {}

entity_service.spawn = function(player_id, x_pos, y_pos)
  local colors = {
    {1, 0, 0, 1},
    {0, 1, 0, 1},
    {0, 0, 1, 1},
    {0, 1, 1, 1},
    {1, 0, 1, 1},
    {1, 1, 0, 1},
    {1, 1, 1, 1}
  }
  local shapes = {
    love.physics.newPolygonShape(25, 0, 50, 50, 0, 50),
    love.physics.newPolygonShape(0, 0, 50, 0, 50, 50, 0, 50),
    love.physics.newPolygonShape(12, 0, 36, 0, 49, 15, 49, 33, 36, 49, 12, 49, 0, 33, 0, 15)
  }
  return {
    -- Calling tonumber() to make player_id a number instead of a string so we can do math on it
    color = colors[(tonumber(player_id) % #colors) + 1],
    id = player_id,
    shape = shapes[(tonumber(player_id) % #shapes) + 1],
    x_pos = x_pos,
    y_pos = y_pos
  }
end

entity_service.draw = function(entity)
  love.graphics.setColor(entity.color)
  local points = { entity.shape:getPoints() }
  for idx, point in ipairs(points) do
    if idx % 2 == 1 then
      points[idx] = point + entity.x_pos
    else
      points[idx] = point + entity.y_pos
    end
  end
  love.graphics.polygon('line', points)
end

entity_service.move = function()
  local player = entity_service.entities[entity_service.player_id]

  -- Don't let the player press up and down at the same time
  if input_service.up and not input_service.down then
    player.y_pos = player.y_pos - 2
  elseif input_service.down and not input_service.up then
    player.y_pos = player.y_pos + 2
  end

  -- Don't let the player press left and right at the same time
  if input_service.left and not input_service.right then
    player.x_pos = player.x_pos - 2
  elseif input_service.right and not input_service.left then
    player.x_pos = player.x_pos + 2
  end
end

return entity_service
