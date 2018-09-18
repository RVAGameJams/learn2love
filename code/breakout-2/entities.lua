-- entities.lua

local boundary_bottom = require('entities/boundary-bottom')
local boundary_left = require('entities/boundary-left')
local boundary_right = require('entities/boundary-right')
local boundary_top = require('entities/boundary-top')
local paddle = require('entities/paddle')
local ball = require('entities/ball')
local brick = require('entities/brick')

return {
  boundary_bottom(400, 606),
  boundary_left(-6, 300),
  boundary_right(806, 300),
  boundary_top(400, -6),
  paddle(300, 500),
  ball(200, 200),
  brick(100, 100),
  brick(200, 100),
  brick(300, 100)
}

