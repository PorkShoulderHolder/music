file.open("pin_config.json","r")
local settings = sjson.decode(file.read())
local red_pin = settings["red"]
local blue_pin = settings["blue"]
local green_pin = settings["green"]


function start_pins()
  pwm.setup(red_pin, 500, 0)
  pwm.setup(blue_pin, 500, 0)
  pwm.setup(green_pin, 500, 0)
  pwm.start(red_pin)
  pwm.start(blue_pin)
  pwm.start(green_pin)
end

function stop_pins()
  pwm.stop(red_pin)
  pwm.stop(blue_pin)
  pwm.stop(green_pin)
end

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

function ease_color(c) 
  start_pins()
  pwm.set_duty(red_pin, tonumber(c["r"]))
  pwm.set_duty(green_pin, tonumber(c["g"]))
  pwm.set_duty(blue_pin, tonumber(c["b"]))
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
