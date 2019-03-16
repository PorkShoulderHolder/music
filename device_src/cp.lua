require('lights')

function write_file(input)
    local s, f = input:find(":::")
    local filename = input:sub(1, s - 1)
    local part_idx_s, part_idx_f = input:find(";;;")
    local part_all = input:sub(f + 1, part_idx_s - 1)
    local div_idx, _ = part_all:find("/")
    local part = tonumber(part_all:sub(1, div_idx - 1))
    local total = tonumber(part_all:sub(div_idx + 1))
    local content = input:sub(part_idx_f + 1)
    if part == 1 then
      file.remove(filename)
      file.open(filename, 'w+')
    else
      file.open(filename, 'a')
    end
    print("--")
    print(part)
    print(total)
    print(part_all)
    print(s, f)
    print(part_idx_s, part_idx_f)
    print(part.." / "..total)
    print("writing new data to " .. filename)
    file.write(content)
    file.close()
    return part, total
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

function handle_sequence_async(sequence)
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

function handle_sequence_sync(sequence)
  local last_ms = 0;
  local ordered_keys = {};

  for k in pairs(sequence) do
    table.insert(ordered_keys, tonumber(k))
  end

  table.sort(ordered_keys)
  
  for i = 1, #ordered_keys do
    local k, v = ordered_keys[i], sequence[tostring(ordered_keys[i])]
    local ms = tonumber(k)
    local side = string.sub(v, 1, 1)
    local action = string.sub(v, 2, 2)
    local diff = ms - last_ms
    last_ms = ms
    print(diff * 1000, ordered_keys[i])
    tmr.delay(diff * 1000)
    if side == 'r' then
      right(action)
    elseif side == 'l' then
      left(action)
    end
  end
end

function handle_file_cp(input)
  local part, total = write_file(string.sub(input, 7))
  sock:send("{'msg': 'wrote ".. part .. "/" .. total .. " chunks'}")
  blink_blue();
  if part == total then
    blink_green();
    local t = tmr.create()
    t:register(1000, 
               tmr.ALARM_SINGLE,
               function()
                 sock.close() 
                 node.restart()
               end)
    t:start()
  end
end

function setupTcpServer()
    inUse = false
    should_repeat = false
    function listenFun(sock)
        if inUse then
            sock:send("Already in use.\\n")
            sock:close()
            return
        end
        inUse = true
        local buffer = nil;
        
        local timer = tmr.create()
        sock:on("receive", function(sock, input)
            if string.sub(input, 1, 6) == 'cpfile' then
              handle_file_cp(input)
            else
              local mappings = sjson.decode(input)
              if mappings["sequence"] ~= nil then
                timer:unregister()
                if mappings["repeat"] then
                  should_repeat = true
                  timer:register(tonumber(mappings["repeat"]),
                                 tmr.ALARM_SEMI,
                                 function()
		                   handle_sequence_sync(mappings["sequence"]) 
                                   if not should_repeat then
                                     timer:unregister()
                                   else
                                     timer:start()
                                   end
                                 end)
                  sock:send("{'msg': 'sequence ok'}")
                  timer:start()
                else
                  should_repeat = false
                  handle_sequence_sync(mappings["sequence"])
                  sock:send("{'msg': 'sequence ok'}")
                end
              elseif mappings["lights"] ~= nil then 
                ease_color(mappings["lights"])
              else
                sock:send("{'msg': 'command not understood'}")
              end
            end
          end)

        sock:on("disconnection", function(sock)
            inUse = false
        end)
    end

    telnetServer = net.createServer(net.TCP)
    telnetServer:listen(3344, listenFun)
    print("telnet server listening")
end
setupTcpServer()
