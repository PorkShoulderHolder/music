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

file.open("pin_config.json","r")
local js_str = file.read()
local mappings = cjson.decode(js_str)
print("mappings: ")
for r,t in pairs(mappings) do print(r,t) end
setup_pindriver_server(mappings)


return function() return right, left end
