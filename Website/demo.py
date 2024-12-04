# This file is meant to be a live demo for the judges
# After multiple attempts to solve the flask and arduino connections
# They have proven to be too unreliable and fail if the raspPi
# Isn't connected to wifi. 
# 
# The arduino board is also quite unreliable 
# with us constantly having to fix wiring issues and the sensors working
# half the time
# 
# The arduino would be great for real time use when there are more stable network
# and hardware resources, but for the prototype, this code quickly allows us
# to show proof of concept

# This will allow us to prove to the judges that our sensors work
# and can transmit data. Everytime the sensor is activated, there is 
# info printed out onto the commandline, and the data is stored in a CSV
# running this python script and waving hand / hotwheel in front of sensor
# will be an easy way to demonstrate proof of concept

# TLDR: Super quick miniature version of our database and car tracking hardware

# gpiozero is the necessary library to get sensor data straight from raspPi GPIO Pins
from gpiozero import DigitalInputDevice
from time import sleep # for causing delay
from datetime import datetime #inputting current time

# getting input from pin 17
sensor = DigitalInputDevice(17)

# print intro message
print("Sensor Active, detecting input")

# infinite loop until program ended
while True: 
    # constantly checks if sensor is active
    if sensor.is_active:
        print("Car Detected\n")
        # if sensor takes in data, opens up CSV and adds data to it
        logData = open("data.csv", "a")
        # logging with timestamp
        dtNow = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        logData.write(f"Car Detected! at {dtNow}")
        sleep(2)
    else:
        # prints this out every 2 seconds theres no input! 
        print("No Input \n")
        sleep(2)