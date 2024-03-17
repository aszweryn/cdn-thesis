-- Initialize the random number generator
math.randomseed(os.time())
local randomNumber = math.random

-- Define the percentage of popular items and the count of popular and max items
local popular_percentage = 95
local popular_items_count = 5
local max_items_count = 200

-- Define the request function
request = function()
  -- Determine if the item is popular
  local is_popular = randomNumber(1, 100) <= popular_percentage
  local item = ""

  -- Generate the item name based on whether it's popular or not
  if is_popular then
    item = "item_" .. randomNumber(1, popular_items_count)
  else
    item = "item_" .. randomNumber(popular_items_count + 1, popular_items_count + max_items_count)
  end

  -- Define the max age of the item
  local max_age = 7 -- Max-alive time in seconds

  -- Return the formatted request
  return wrk.format(nil, "/" .. item .. ".ext?max_age=" .. max_age )
end