local simulation = require "simulation"
local backend = {}

backend.generate_traffic = function()
  simulation.for_work_longtail(simulation.profiles.backend)

  ngx.header['Content-Type'] = 'application/json'
  ngx.header['Cache-Control'] = 'public, max-age=' .. (ngx.var.arg_max_age or 10)

  ngx.say('{"service": "api", "value": 123, "request": "' .. ngx.var.uri .. '"}')
end

return backend
