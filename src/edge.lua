local simulation = require "simulation"
local edge = {}

edge.simulate_load = function ()
	simulation.for_work_longtail(simulation.profiles.edge)
end

return edge
