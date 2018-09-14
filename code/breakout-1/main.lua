-- main.lua

local boundary_bottom = require('entities/boundary-bottom')
local boundary_left = require('entities/boundary-left')
local boundary_right = require('entities/boundary-right')
local boundary_top = require('entities/boundary-top')
local paddle = require('entities/paddle')
local ball = require('entities/ball')
local world = require('world')

-- Boolean to keep track of whether our game is paused or not
local paused = false

local key_map = {
  escape = function()
    love.event.quit()
  end,
  space = function()
    paused = not paused
  end
}

love.draw = function()
  love.graphics.polygon('line', boundary_bottom.body:getWorldPoints(boundary_bottom.shape:getPoints()))
  love.graphics.polygon('line', boundary_left.body:getWorldPoints(boundary_left.shape:getPoints()))
  love.graphics.polygon('line', boundary_right.body:getWorldPoints(boundary_right.shape:getPoints()))
  love.graphics.polygon('line', boundary_top.body:getWorldPoints(boundary_top.shape:getPoints()))
  local ball_x, ball_y = ball.body:getWorldCenter()
  love.graphics.circle('fill', ball_x, ball_y, ball.shape:getRadius())
  love.graphics.polygon('line', paddle.body:getWorldPoints(paddle.shape:getPoints()))
end

love.focus = function(focused)
  if not focused then
    paused = true
  end
end

love.keypressed = function(pressed_key)
  -- Check in the key map if there is a function
  -- that matches this pressed key's name
  if key_map[pressed_key] then
    key_map[pressed_key]()
  end
end

love.update = function(dt)
  if not paused then
    world:update(dt)
  end
end


