math.randomseed(os.time())
local random = math.random

local popular_percentage = 96
local popular_items_count = 5
local max_items_count = 200

request = function()
  local is_popular = random(1, 100) <= popular_percentage
  local item = ""

  if is_popular then
    item = "item_" .. random(1, popular_items_count)
  else
    item = "item_" .. random(popular_items_count + 1, popular_items_count + max_items_count)
  end

  --local item = "item_" .. random(1, 100)
  local max_age=7 -- 10s as a default value

  return wrk.format(nil, "/" .. item .. ".ext?max_age=" .. max_age )
end