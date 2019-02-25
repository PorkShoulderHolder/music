sudo ./venv/bin/esptool.py --port $1 --baud 112500 write_flash -fm dio 0x00000 ../device_images/nodemcu-dev-28-modules-2016-05-31-18-45-40-float.bin  
echo 'Firmware upload done. Restart device! Waiting 4 seconds...'
sleep 4
sh full_flash.sh $1
echo 'software update done'
