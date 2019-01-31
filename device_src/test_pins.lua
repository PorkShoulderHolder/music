function testpin(pin)
    local delay = 400000
    gpio.mode(pin, gpio.OUTPUT)
    print("testing pin " .. pin .. " on high")
    gpio.write(pin, gpio.HIGH)
    tmr.delay(delay)
    print("testing pin " .. pin .. " on low")
    gpio.write(pin, gpio.LOW) 
    tmr.delay(delay)
end

function testall()
    local i = 0
    while i < 9 do
        print("===")
        if i ~= 4 then testpin(i) end
        i = i + 1
    end
end

testall()
   
