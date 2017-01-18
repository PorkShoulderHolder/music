python luatool.py --port $1 --src telnet_srv.lua --dest init.lua  --baud 115200 --verbose
python luatool.py --port $1 --src aps.txt --dest aps.txt  --baud 115200 --verbose
python luatool.py --port $1 --src coapcp.lua --dest coapcp.lua  --baud 115200 --verbose
