require('lights')

function testKnownNetworks(avail_nets)
   file.open("aps.txt")
   local line = file.readline()
   print(#avail_nets)
   for l,g in pairs(avail_nets) do print(l,g) end 
   while line ~= nil do 
      name,pw = string.match(line, "([^,]+),([^,]+)")
      pw = string.gsub(pw, "\n", "")
      if avail_nets[name] ~= nil then
         wifi.sta.config(name, pw)
         print(name)
         print(pw)
         print("attempting to connect to " .. name)
      end
      print(line)
      line = file.readline()
   end
end
function saferun(name)
   if file.exists(name) then
      dofile(name)
   else
      print ("file not found " .. name)
   end
end
wifi.setmode(wifi.STATION)
saferun("coapcp.lua")
saferun("udp.lua")
saferun("telnet.lua")
saferun("test_pins.lua")
wifi.sta.getap(testKnownNetworks)
uart.write(0,"\\n")
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == "0.0.0.0" or wifi.sta.getip() == nil then
      uart.write(0,".")
      blink_blue();
    else
      mdns.register("goodvibes" .. node.chipid())
      tmr.stop(0)
      tmr.unregister(0)
      uart.write(0,"connected")
      green_flash();
   end
end)
