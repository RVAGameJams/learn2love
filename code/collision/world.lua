local world = love.physics.newWorld(0, 1000)

local begin_contact_callback = function(fixture_a, fixture_b, contact)
  local entity_a = fixture_a:getUserData()
  local entity_b = fixture_b:getUserData()
  if entity_a.begin_contact then entity_a:begin_contact(entity_b, contact) end
  if entity_b.begin_contact then entity_b:begin_contact(entity_a, contact) end
end

local end_contact_callback = function(fixture_a, fixture_b, contact)
  local entity_a = fixture_a:getUserData()
  local entity_b = fixture_b:getUserData()
  if entity_a.end_contact then entity_a:end_contact(entity_b, contact) end
  if entity_b.end_contact then entity_b:end_contact(entity_a, contact) end
end

world:setCallbacks(begin_contact_callback, end_contact_callback, nil, nil)

return world
