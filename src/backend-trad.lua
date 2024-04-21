local simulation = require "simulation"

local backend = {}

-- Generate traffic with a long-tail distribution and send a JSON response
backend.generate_traffic = function()
  simulation.simulateLongTail(simulation.profiles.backend_trad)
end

return backend
