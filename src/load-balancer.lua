local rc = require "resty.chash"
local lb = {}

lb.server_list_setup = function()
  local server_list = {
    ["edge1"] = 1,
    ["edge2"] = 1,
    ["edge3"] = 1,
  }
  local chash_up = rc:new(server_list)

  package.loaded.my_chash_up = chash_up
  package.loaded.my_servers = server_list
end

lb.set_servers = function ()
  local balancer = require "ngx.balancer"
  local chash_up = package.loaded.my_chash_up
  local servers = package.loaded.my_ip_servers
  local id = chash_up:find(ngx.var.uri)

  assert(balancer.set_current_peer(servers[id] .. ":8080"))
end

lb.resolve_for_upstream = function ()
  local resolver = require "resty.dns.resolver"
  local r, err = resolver:new{
     nameservers = {"127.0.0.11", {"127.0.0.1", 53}},
     retrans = 5,
     timeout = 1000,
     no_random = true,
  }
  if package.loaded.my_ip_servers ~= nil then
    return
  end

  local servers = package.loaded.my_servers
  local ip_servers = {}

  for host, weight in pairs(servers) do
    local ans, err, tries = r:query(host, nil, {})
    if ans and #ans > 0 then
      ip_servers[host] = ans[1].address
    else
      print("DNS resolution failed for " .. host)
    end
  end

  package.loaded.my_ip_servers = ip_servers
end

return lb

