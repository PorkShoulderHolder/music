sudo venv/bin/python luatool.py --port $1 --src ../device_src/telnet_srv.lua --dest init.lua  --baud 115200 --verbose
sudo venv/bin/python luatool.py --port $1 --src ../aps.txt --dest aps.txt  --baud 115200 --verbose
sudo venv/bin/python luatool.py --port $1 --src ../device_src/udp.lua --dest udp.lua  --baud 115200 --verbose
sudo venv/bin/python luatool.py --port $1 --src ../device_src/coapcp.lua --dest coapcp.lua  --baud 115200 --verbose
sudo venv/bin/python luatool.py --port $1 --src ../config/pin_config.json --dest pin_config.json  --baud 115200 --verbose
sudo venv/bin/python luatool.py --port $1 --src ../device_src/test_pins.lua --dest test_pins.lua  --baud 115200 --verbose
