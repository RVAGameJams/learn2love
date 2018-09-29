-- entities.lua

local boundary_bottom = require('entities/boundary-bottom')
local boundary_vertical = require('entities/boundary-vertical')
local boundary_top = require('entities/boundary-top')
local paddle = require('entities/paddle')
local game_over_text = require('entities/game-over-text')
local pause_text = require('entities/pause-text')
local stage_clear_text = require('entities/stage-clear-text')
local ball = require('entities/ball')
local brick = require('entities/brick')

local entities = {
  boundary_bottom(400, 606),
  boundary_vertical(-6, 300),
  boundary_vertical(806, 300),
  boundary_top(400, -6),
  paddle(300, 500),
  game_over_text(),
  pause_text(),
  stage_clear_text(),
  ball(200, 200)
}

local row_width = love.window.getMode() - 20
for number = 0, 38 do
  local brick_x = ((number * 60) % row_width) + 40
  local brick_y = (math.floor((number * 60) / row_width) * 40) + 80
  entities[#entities + 1] = brick(brick_x, brick_y)
end

return entities
