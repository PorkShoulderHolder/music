require('sharp')

local is_started = false
local remote_host = get_remote_host()

function get_remote_host()
   file.open("remote_host.txt")
   remote_host = file.readline()
   file.close()
end
   
function update_server(measurement)
   http.post(remote_host, "","device_" .. node.chipid() .. " aout=" .. measurement)
end


local measurement_sum = 0.0
local counter = 0.0
local avg = nil

sample_interval = 200
update_period = 300
tmr.alarm(5, sample_interval, 1, function()
    counter = counter + 1
    measurement_sum = measurement_sum + ReadSharp()
    if counter % update_period == 0 then
        print("updating")
        avg = measurement_sum / counter 
        update_server(avg)
        measurement_sum = 0.0
        counter = 0.0
    end
end)




