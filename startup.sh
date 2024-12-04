#!/bin/bash

#open the browser to the specified URL
chromium-browser --kiosk --app=https://unlvparkify.netlify.app &

#open Arduino IDE and load the carCounter.ino file
arduino /home/pi/Documents/carCounter.ino &

#run the Python database script
python3 /RaspberryPi/parking_db.py &

