
function write_file(mappings)
    file.remove(mappings["filename"])
    file.open(mappings["filename"], 'w+')
    print("writing new data to " .. mappings["filename"])
    file.write(mappings["data"])
    file.close()
    if mappings["filename"] == "init.lua" then
      sock:send("{'msg': 'ok, new init.lua file received...'}")
    end
    if mappings["restart"] ~= nil then
        node.restart()
    end
end
file.open("pin_config.json","r")
local settings = sjson.decode(file.read())
local hi = settings["reverse_power"] and gpio.LOW or gpio.HIGH
local low = settings["reverse_power"] and gpio.HIGH or gpio.LOW
file.close()

function right(data)
  print("r", data)
  local power = tonumber(data)
  gpio.write(settings["right"], power==1 and hi or low)
end
function left(data)
  print("l", data)
  local power = tonumber(data)
  gpio.write(settings["left"], power==1 and hi or low)
end

function handle_sequence(sequence)
  local tmr_id = 0;
  for k,v in pairs(sequence) do
    local ms = tonumber(k)
    local side = string.sub(v, 1, 1)
    local action = string.sub(v, 2, 2)
    local timer = tmr.create()
    if side == 'r' then
      timer:alarm(ms, tmr.ALARM_SINGLE, function() right(action) end)
    elseif side == 'l' then
      timer:alarm(ms, tmr.ALARM_SINGLE, function() left(action) end)
    end
    tmr_id = tmr_id + 1;
  end
end

function setupTcpServer()
    inUse = false
    function listenFun(sock)
        if inUse then
            sock:send("Already in use.\\n")
            sock:close()
            return
        end
        inUse = true
        
        sock:on("receive",function(sock, input)
            local mappings = sjson.decode(input)
            if mappings["filename"] ~= nil then
              write_file(mappings)
              sock:send("{'msg': 'ok'}")
            elseif mappings["sequence"] ~= nil then
              handle_sequence(mappings["sequence"])
              sock:send("{'msg': 'sequence ok'}")
            else
              sock:send("{'msg': 'command not understood'}")
            end
        end)

        sock:on("disconnection",function(sock)
            inUse = false
        end)
    end

    telnetServer = net.createServer(net.TCP)
    telnetServer:listen(3344, listenFun)
    print("telnet server listening")
end
setupTcpServer()