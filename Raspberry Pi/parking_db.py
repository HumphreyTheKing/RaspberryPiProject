import sqlite3
from datetime import datetime

DB_NAME = 'ParkingLotInitializer'

def init_db():
    """Intialize Database with the neccessary tables."""
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()

    # Creates the parking_lots table
    c.execute('''CREATE TABLE IF NOT EXISTS parking_lots
                 (id INTEGER PRIMARY KEY,
                  name TEXT NOT NULL,
                  total_spots INTEGER NOT NULL,
                  available_spots INTEGER NOT NULL,
                  last_updated TIMESTAMP)''')
    
    # Creates the parking_events table for logging
    c.execute('''CREATE TABLE IF NOT EXISTS parking_events
                 (id INTEGER PRIMARY KEY,
                  lot_id INTEGER,
                  event_type TEXT,
                  timestamp TIMESTAMP,
                  FOREIGN KEY (lot_id) REFERENCES parking_lots (id))''')
    
    # Insert the initial parking lot data if not exists
    c.execute('''INSERT OR IGNORE INTO parking_lots (id, name, total_spots, available_spots, last_updated)
                 VALUES (1, 'Main Lot', 100, 100, ?)''', (datetime.now(),))
    
    conn.commit()
    conn.close()

    #still not complete