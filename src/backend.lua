local backend = {}

backend.generate_traffic = function()
  ngx.header['Content-Type'] = 'application/json'
  ngx.header['Cache-Control'] = 'public, max-age=' .. (ngx.var.arg_max_age or 15)

  ngx.say('{"service": "api", "value": 123}')
end

return backend
