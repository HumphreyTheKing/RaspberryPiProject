import serial
import threading
from flask import Flask, request, jsonify

# starting up flask app, calling it parkify
app = Flask('Parkify')

# global var for car count
car_count = 0

# to get data from arduino
arduino = serial.Serial('/dev/ttyACM0', 9600, timeout=1)

# flask webserver, everytime count is updated this runs
@app.route('/update_count', methods=['POST'])
def update_count():
    global car_count
    car_count = request.json.get('count', 0)
    return "Car count updated", 200

# gets the actual count of the cars
@app.route('/get_count', methods=['GET'])
def get_count():
    global car_count
    return jsonify({'count': car_count})

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
    # doing the arduino reading in a separate thread (not sure if possible with rasppi)
    arduino_thread = threading.Thread(target=read_from_arduino, daemon=True)
    arduino_thread.start()

    # runs app
    app.run(host='0.0.0.0', port=5000)




# 
# This can be added to the HTML index file to display the data
# # <script>
#     async function updateCarCount() {
#         try {
#             const response = await fetch('http://<raspberry_pi_ip>:5000/get_count');
#             const data = await response.json();
#             document.getElementById('car-count').innerText = data.count;
#         } catch (error) {
#             console.error('Error fetching car count:', error);
#         }
#     }


#     setInterval(updateCarCount, 1000);
# </script> 
