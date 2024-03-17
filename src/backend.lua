local simulation = require "simulation"
local cjson = require "cjson.safe"

local backend = {}

-- Generate traffic with a long-tail distribution and send a JSON response
backend.generate_traffic = function()
  simulation.simulateLongTail(simulation.profiles.backend)

  -- Set the response headers
  ngx.header['Content-Type'] = 'application/json'
  ngx.header['Cache-Control'] = 'public, max-age=' .. (ngx.var.arg_max_age or 10)

  -- Prepare the response body
  local response_body = {
    service = "api",
    value = 200,
    request = ngx.var.uri
  }

  -- Encode the response as JSON and send it
  local json_response, err = cjson.encode(response_body)
  if not json_response then
    ngx.log(ngx.ERR, "Failed to encode the response body: ", err)
    return
  end

  ngx.say(json_response)
end

return backend
