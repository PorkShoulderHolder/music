file.open("pin_config.json","r")
local settings = cjson.decode(file.read())
local red_pin = settings["red"]
local blue_pin = settings["blue"]
local green_pin = settings["green"]

function green_flash() 
  gpio.write(green_pin, gpio.HIGH)
  tmr.delay(100000)
  gpio.write(green_pin, gpio.LOW)
  tmr.delay(100000)
  gpio.write(green_pin, gpio.HIGH)
  tmr.delay(100000)
  gpio.write(green_pin, gpio.LOW)
  tmr.delay(100000)
  gpio.write(green_pin, gpio.HIGH)
  tmr.delay(100000)
  gpio.write(green_pin, gpio.LOW)
end

function blink_blue()
  gpio.write(blue_pin, gpio.HIGH)
  tmr.delay(50000)
  gpio.write(blue_pin, gpio.LOW)
  tmr.delay(50000)
end

function blink_red()
  gpio.write(red_pin, gpio.HIGH)
  tmr.delay(50000)
  gpio.write(red_pin, gpio.LOW)
  tmr.delay(50000)
end

function blink_green()
  gpio.write(green_pin, gpio.HIGH)
  tmr.delay(50000)
  gpio.write(green_pin, gpio.LOW)
  tmr.delay(50000)
end
