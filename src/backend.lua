local simulation = require "simulation"
local cjson = require "cjson.safe"

local backend = {}

-- Generate traffic with a long-tail distribution
backend.generate_traffic = function()
  simulation.simulateLongTail(simulation.profiles.backend)
end

return backend
