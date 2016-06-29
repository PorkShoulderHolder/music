adc.force_init_mode(adc.INIT_ADC)
function ReadSharp()
    file.open("storage.lua", "r")
    v0=file.readline()
    v0=tonumber(v0)
    file.close()
    led_pin=2
    gpio.mode(led_pin,gpio.OUTPUT)
    gpio.write(led_pin,gpio.HIGH)
    tmr.delay(280)
    voltage=adc.read(0)
    tmr.delay(40)
    gpio.write(led_pin,gpio.LOW)
    tmr.delay(9680)
    if voltage<v0 then
        v0=voltage
        file.open("storage.lua", "w+")
        file.writeline(v0)
        file.close()
    end
    v0=(v0/1024)*3.615384615
    dust=(voltage*0.17-v0)*1000
    return voltage
end

function rpt(n)
    local i = n
    while i > 0 do
        print(ReadSharp())
        i = i - 1
        tmr.delay(10000)
    end
end
