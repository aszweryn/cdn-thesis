math.randomseed(os.time())
local random = math.random

request = function()
  local item = "item_" .. random(1, 100)
  local max_age=10 -- 10s as a default value

  return wrk.format(nil, "/" .. item .. ".ext?max_age=" .. max_age )
end
