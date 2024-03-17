local resty_chash = require "resty.chash"
local ngx_balancer = require "ngx.balancer"
local resty_resolver = require "resty.dns.resolver"

local load_balancer = {}

-- Setup the server list for the consistent hashing ring
load_balancer.setup_server_list = function()
  local server_list = {
    ["edge1"] = 1,
    ["edge2"] = 1,
    ["edge3"] = 1,
    ["edge4"] = 1,
  }
  local consistent_hash_ring = resty_chash:new(server_list)

  -- Store the consistent hash ring and server list for later use
  package.loaded.consistent_hash_ring = consistent_hash_ring
  package.loaded.server_list = server_list
end

-- Set the current peer in the load balancer
load_balancer.set_current_peer = function ()
  local consistent_hash_ring = package.loaded.consistent_hash_ring
  local ip_servers = package.loaded.ip_servers
  local server_id = consistent_hash_ring:find(ngx.var.uri)

  local ok, err = ngx_balancer.set_current_peer(ip_servers[server_id] .. ":8080")
  if not ok then
    ngx.log(ngx.ERR, "Failed to set the current peer: ", err)
    return
  end
end

-- Resolve the IP addresses of the servers
load_balancer.resolve_ip_addresses = function ()
  local resolver, err = resty_resolver:new{
     nameservers = {"127.0.0.11", {"127.0.0.1", 53}},
     retrans = 5,
     timeout = 1000,
     no_random = true,
  }
  if not resolver then
    ngx.log(ngx.ERR, "Failed to create the resolver: ", err)
    return
  end

  if package.loaded.ip_servers then
    return
  end

  local server_list = package.loaded.server_list
  local ip_servers = {}

  for host, weight in pairs(server_list) do
    local answers, err, tries = resolver:query(host, nil, {})
    if not answers then
      ngx.log(ngx.ERR, "Failed to resolve the host: ", host, " error: ", err)
    elseif #answers > 0 then
      ip_servers[host] = answers[1].address
    end
  end

  package.loaded.ip_servers = ip_servers
end

return load_balancer