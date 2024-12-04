import sqlite3
from datetime import datetime
import serial #for reading arduino inputs
import time #yeah its time

DB_NAME = 'parking.db'
SERIAL_PORT = '/dev/ttyACM0' #specific arduino
BAUD_RATE = 9600

def init_db(floors, spaces_per_floor):
    """Initialize the database with necessary tables for a multi-floor parking system."""
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()
    
    # Create parking_lot table
    c.execute(
        "CREATE TABLE IF NOT EXISTS parking_lot ("
        "id INTEGER PRIMARY KEY, "
        "total_floors INTEGER NOT NULL, "
        "total_cars INTEGER NOT NULL)"
    )
    
    # Create floor_data table
    c.execute(
        "CREATE TABLE IF NOT EXISTS floor_data ("
        "floor_number INTEGER PRIMARY KEY, "
        "total_spaces INTEGER NOT NULL, "
        "occupied_spaces INTEGER NOT NULL)"
    )
    
    # Create parking_events table for logging
    c.execute(
        "CREATE TABLE IF NOT EXISTS parking_events ("
        "id INTEGER PRIMARY KEY, "
        "event_type TEXT, "
        "floor_number INTEGER, "
        "timestamp TIMESTAMP)"
    )
    
    # Insert or update parking lot data
    c.execute(
        "INSERT OR REPLACE INTO parking_lot (id, total_floors, total_cars) "
        "VALUES (1, ?, 0)", 
        (floors,)
    )
    
    # Initialize floor data
    for floor, spaces in spaces_per_floor.items():
        c.execute(
            "INSERT OR REPLACE INTO floor_data (floor_number, total_spaces, occupied_spaces) "
            "VALUES (?, ?, 0)", 
            (floor, spaces)
        )
    
    conn.commit()
    conn.close()


    #still not complete

def update_car_count(floor, change):
    """Update the car count for a specific floor and the total count."""
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()
    
    # Update floor occupancy
    c.execute(
        "UPDATE floor_data "
        "SET occupied_spaces = occupied_spaces + ? "
        "WHERE floor_number = ?", 
        (change, floor)
    )

    #Update total floor count
    c.execute(
        "UPDATE parking_lot"
        "SET total_cars = total_cars + ?"
        "WHERE id + ?"
        (change,)
    )
    
    #log event
    event_type = 'entry' if change > 0 else 'exit'
    c.execute(
        "INSERT INTO parking_events (event_type, floor_number, timestamp) "
        "VALUES (?, ?, ?)"
        (event_type, floor, datetime.now())
    )
    
    conn.commit()
    conn.close()
    
def move_car(from_floor, to_floor):
    """Move a car from one floor to another."""
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()
    
    c.execute(
        "UPDATE floor_data"
        "SET ccupied_spaces = occupied_spaces - 1"
        "WHERE floor_number = ?",
        (from_floor,)
    )
    
    c.execute(
        "UPDATE floor_data"
        "SET ccupied_spaces = occupied_spaces + 1"
        "WHERE floor_number = ?",
        (to_floor,)
    )
    
    c.execute(
        "INSERT INTO parking_events (event_type, floor_number timestamp) "
        "VALUES (?, ?, ?)",
        (f"move_{from_floor}_to_{to_floor}", to_floor, datetime.now())
    )
    
    conn.commit()
    conn.close()
    
def get_parking_status():
    """Retrieve the current status of the parking lot."""
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()
    
    c.execute(
        "SELECT total_floors, total_cars "
        "FROM parking_lot "
        "WHERE id = 1"
    )
    lot_info = c.fetchone()
    
    c.execute(
        "SELECT floor_number, total_spaces, occupied_spaces "
        "FROM floor_data "
        "ORDER BY floor_number"
    )
    floor_data = c.fetchall()
    
    conn.close()
    
    floor_counts = {}
    for floor, total, occupied in floor_data:
        percentage = (occupied / total) * 100 if total > 0 else 0
        floor_counts[floor] = {
            'occupied': occupied,
            'total': total,
            'percentage': round(percentage, 2)
        }
    
    return {
        'total_floors': lot_info[0],
        'total_cars': lot_info[1],
        'floor_counts': floor_counts
    }

def process_arduino_input():
    """Process inputs from the Arduino to update the database."""
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
    time.sleep(2) #give delay for connection to stabilize
    while True:
        if ser.in_waiting > 0:
            line = ser.readline().decode('utf-8').strip()
            print(f"Received: {line}") #debugging output
            #arse the input for event type and floor number
            parts = line.split()
            if len(parts) >= 2: #if input
                event_type = parts[0]
                floor = int(parts[1]) #initialize car parts
                if event_type == "CarEnters": #if a car enters
                    update_car_count(floor, 1)
                elif event_type == "CarExits": #if a car exits after parsing input
                    update_car_count(floor, -1)
                elif event_type.startswith("Move"):
                    from_floor, to_floor = map(int, event_type.split("_")[1:])
                    move_car(from_floor, to_floor)

def get_recent_events(limit=10):
    """Retrieve recent parking events."""
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()
    
    c.execute(
        "SELECT event_type, floor_number, timestamp "
        "FROM parking_events "
        "ORDER BY timestamp DESC "
        "LIMIT ?", 
        (limit,)
    )
    
    events = [{'event_type': row[0], 'floor_number': row[1], 'timestamp': row[2]} for row in c.fetchall()]
    conn.close()
    
    return events

# Example usage:
if __name__ == "__main__":
    #initialize floor database
    spaces_per_floor = {1: 10, 2: 15, 3: 20}
    init_db(floors=3, spaces_per_floor=spaces_per_floor)
    print("Database initialized.")
    #process arduino inputs and commands
    print("Waiting for Arduino inputs...")
    process_arduino_input()
    
    # Simulate some parking events
    update_car_count(1, 1)  # Car enters on floor 1
    update_car_count(2, 1)  # Car enters on floor 2
    move_car(1, 2)  # Car moves from floor 1 to 2
    move_car(2, 1)  # Car moves from floor 2 to 1
    update_car_count(1, -1)  # Car exits from floor 1
    # Get and print current status
    # status = get_parking_status()
    # print(f"\nCurrent parking lot status:")
    # print(f"Total floors: {status['total_floors']}")
    # print(f"Total cars: {status['total_cars']}")
    # print("Cars per floor:")
    # for floor, data in status['floor_counts'].items():
    #     print(f"  Floor {floor}: {data['occupied']}/{data['total']} cars ({data['percentage']}%)")
    
    # Get and print recent events
    # events = get_recent_events()
    # print("\nRecent events:")
    # for event in events:
    #    print(f"{event['event_type']} on floor {event['floor_number']} at {event['timestamp']}")\