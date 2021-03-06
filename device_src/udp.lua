function setup_pindriver_server(settings)
   pindriver = net.createServer(net.UDP)
   local hi = settings["reverse_power"] and gpio.LOW or gpio.HIGH
   local low = settings["reverse_power"] and gpio.HIGH or gpio.LOW 
   for k, pin in pairs(settings) do
      print(k, pin)
      gpio.mode(pin, gpio.OUTPUT)
   end
   function right(data)
      local power = tonumber(data)
      gpio.write(settings["right"], power==1 and hi or low)
   end
   function left(data)
      local power = tonumber(data)
      gpio.write(settings["left"], power==1 and hi or low)
   end
   function router(s, data)
      print(data)
      local i = 1
      local j = 3
      while string.sub(data,i,j) ~= ":::" do
         i = i + 1
         j = j + 1
      end
      local prefix = string.sub(data,1,i-1)
      print(prefix)
      if prefix == "r" then
         right(string.sub(data, j+1, string.len(data)))
      end
      if prefix == "l" then
         left(string.sub(data, j+1, string.len(data)))
      end
   end
   pindriver:on("receive",router)
   pindriver:listen(8888)
   print("udp listening")
end
file.open("pin_config.json","r")
local mappings = sjson.decode(file.read())
setup_pindriver_server(mappings)
