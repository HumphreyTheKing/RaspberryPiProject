# to add context to this file: We attempted multiple database
#structures to test out which would be the best,
# Flask seemed more promising for hosting python-based web server,
# other attempts include sqllite. Although it didn't work as reliably
# Flask was the easiest and most useful implementation we attempted


from flask import Flask, render_template, request, jsonify
from parking_db import get_parking_status, get_recent_events
#necessary imports for running arduino script and flask app at the sametime
import serial
import threading

# starting up flask app, calling it parkify
# originally just said _name_
app = Flask('Parkify')

# global var for car count
car_count = 0

# to get data from arduino
arduino = serial.Serial('/dev/ttyACM0', 9600, timeout=1)

@app.route('/')
def home():
    return render_template('home.html')

# flask webserver, everytime count is updated this runs
# attempted bug fix where it wouldn't post to website
# still doesn't work
# changed name from my attempt to actual API name
@app.route('/api/get_parking_status', methods=['POST'])
def update_count():
    global car_count
    car_count = request.json.get('count', 0)
    return "Car count updated", 200

# gets the actual count of the cars
@app.route('api/get_count', methods=['GET'])
def get_count():
    global car_count
    return jsonify({'count': car_count})

@app.route('/api/recent_events')
def recent_events():
    events = get_recent_events()
    return jsonify(events)

# adding in arduino script
# reads from arduino, counts the cars
def read_from_arduino():
    global car_count
    while True:
        try:
            # Read data from Arduino
            data = arduino.readline().decode().strip()
            if data == "Car detected":
                car_count += 1
                print(f"Cars counted: {car_count}")
        except Exception as e:
            print(f"Error reading from Arduino: {e}")

if __name__ == '__main__':
    app.run(debug=True)
    
# runs app on local server, possible fix for webserver
# not running properly request
app.run(host='0.0.0.0', port=5000)
