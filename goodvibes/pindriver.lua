function setup_pindriver_server(settings)
   pindriver = coap.Server()
   pindriver:listen(4000)
   for k, pin in pairs(settings) do
      pwm.setup(pin, 500, 0)
      pwm.start(pin)
   end

   function right(data)
      local power = tonumber(data)
      pwm.setduty(settings["right"], power)
   end
   function left(data)
      local power = tonumber(data)
      pwm.setduty(settings["left"], power)
   end
   pindriver:func("right")
   pindriver:func("left")
end
file.open("pin_config.json","r")
local js_str = file.read()
local mappings = cjson.decode(js_str)
print("mappings: ")
for r,t in pairs(mappings) do print(r,t) end
setup_pindriver_server(mappings)
