local simulation = {}

-- Define utility functions and constants
local random = math.random
local sleep = ngx.sleep
local second = 0.001
local MIN_WAIT_MS = 10
local MAX_WAIT_MS = 1000

-- Seed the random number generator
math.randomseed(ngx.time() + ngx.worker.pid())

-- Define a function to simulate work with a long-tail distribution
simulation.simulateLongTail = function(percentiles)
  -- Initialize the min and max wait times
  local min_wait_ms = MIN_WAIT_MS
  local max_wait_ms = MAX_WAIT_MS

  -- Sort the percentiles in ascending order
  table.sort(percentiles, function(a,b) return  a.p < b.p end)

  -- Get a random percentage
  local current_percentage = random(1, 100)

  -- Find the appropriate percentile for the current percentage
  for _, percentile in pairs(percentiles) do
    if current_percentage <= percentile.p then
      min_wait_ms = percentile.min
      max_wait_ms = percentile.max
      break
    end
  end

  -- Calculate the sleep time in seconds
  local sleep_seconds = random(min_wait_ms, max_wait_ms) * second

  -- Append the latency header
  ngx.header["X-Latency"] = "simulated=" .. sleep_seconds .. "s, min=" .. min_wait_ms .. ", max=" .. max_wait_ms .. ", profile=" .. (ngx.var.arg_profile or "empty")

  -- Sleep for the calculated time
  sleep(sleep_seconds)
end

-- Define the simulation profiles
simulation.profiles = {
  edge={
    {p=60, min=2, max=30,}, {p=85, min=31, max=60,}, {p=95, min=61, max=200,}, {p=99, min=201, max=600,},
  },
  backend={
    {p=60, min=150, max=500,}, {p=85, min=501, max=600,}, {p=95, min=601, max=2000,}, {p=99, min=2001, max=4000,},
  },
  backend_trad={
    {p=60, min=(2+150), max=(30+500),}, {p=85, min=(31+501), max=(60+600),}, {p=95, min=(61+601), max=(200+2000),}, {p=99, min=(201+2001), max=(600+4000),},
  },
}

return simulation