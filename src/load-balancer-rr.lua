local resty_roundrobin = require "resty.roundrobin"
local resty_resolver = require "resty.dns.resolver"
local ngx_balancer = require "ngx.balancer"

local load_balancer = {}

-- Setup the server list for the consistent hashing ring
load_balancer.setup_server_list = function()
  local server_list = {
    ["172.22.0.6:8080"] = 1,
   -- ["edge2:8080"] = 1,
   -- ["edge3:8080"] = 1,
   -- ["edge4:8080"] = 1,
  }
  local rr_up = resty_roundrobin:new(server_list)

  package.loaded.my_rr_up = rr_up
end

-- Set the current peer in the load balancer
load_balancer.set_current_peer = function ()
    local b = require "ngx.balancer"

    local rr_up = package.loaded.my_rr_up    

    local server = rr_up:find()

    assert(b.set_current_peer(server))
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