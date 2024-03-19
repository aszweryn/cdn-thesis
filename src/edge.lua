local simulation = require "simulation"

local edge = {}

-- Simulate long-tail distribution on edge nodes
edge.simulate_load = function()
	simulation.simulateLongTail(simulation.profiles.edge)
end

return edge
