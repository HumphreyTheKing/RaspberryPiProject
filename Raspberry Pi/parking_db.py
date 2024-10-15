import sqlite3
from datetime import datetime

DB_NAME = 'parking.db'

def init_db(floors):
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
    
    # Create floor_counts table
    c.execute(
        "CREATE TABLE IF NOT EXISTS floor_counts ("
        "floor_number INTEGER PRIMARY KEY, "
        "car_count INTEGER NOT NULL)"
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
    
    # Initialize floor counts
    for floor in range(1, floors + 1):
        c.execute(
            "INSERT OR REPLACE INTO floor_counts (floor_number, car_count) "
            "VALUES (?, 0)", 
            (floor,)
        )
    
    conn.commit()
    conn.close()

    #still not complete