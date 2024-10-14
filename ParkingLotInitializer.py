class ParkingLotInitializer:
    def __init__(self, floors):
        #declare number of floors
        self.total_cars = 0  #variable for number of cars
        self.floors = floors
        self.floor_counts = {i: 0 for i in range(1, floors + 1)}  #dict to hold number of cars for each floor

    def car_enters(self, floor):
        if floor in self.floor_counts:
            self.total_cars += 1
            self.floor_counts[floor] += 1
            print(f"Car entered on floor {floor}. Total cars: {self.total_cars}. Cars on floor {floor}: {self.floor_counts[floor]}") #output when car enters
        else:
            print(f"Invalid floor {floor}") #if floor does not exist

    def car_exits(self, floor):
        if floor in self.floor_counts and self.floor_counts[floor] > 0:
            self.total_cars -= 1
            self.floor_counts[floor] -= 1
            print(f"Car exited from floor {floor}. Total cars: {self.total_cars}. Cars on floor {floor}: {self.floor_counts[floor]}") #output when car exits
        else:
            print(f"No cars on floor {floor} to exit.") #if there are no cars to exit

    def move_car_up(self, current_floor):
        #function for when car moves up
        if current_floor < self.floors and self.floor_counts[current_floor] > 0:
            self.floor_counts[current_floor] -= 1
            self.floor_counts[current_floor + 1] += 1
            print(f"Car moved up from floor {current_floor} to floor {current_floor + 1}") #text for debugging
            self.display_floor_counts()
        else:
            print(f"Cannot move car up from floor {current_floor}") #if no floor above

    def move_car_down(self, current_floor):
        #function for when car moves down
        if current_floor > 1 and self.floor_counts[current_floor] > 0:
            self.floor_counts[current_floor] -= 1
            self.floor_counts[current_floor - 1] += 1
            print(f"Car moved down from floor {current_floor} to floor {current_floor - 1}") #text for debugging
            self.display_floor_counts()
        else:
            print(f"Cannot move car down from floor {current_floor}") #if no floor below

    def display_floor_counts(self): #funtion to display current counts
        #display current counts
        print("Current car counts by floor:")
        for floor, count in self.floor_counts.items(): #display itmes of the dicts
            print(f"Floor {floor}: {count} cars")


#example lot with 3 floors
parking_lot = ParkingLotInitializer(floors=3)

#example functiosn to replace with sensors later
parking_lot.car_enters(1)    # A car enters on floor 1   # A car enters on floor 2
parking_lot.move_car_up(1)   # A car moves from floor 1 to 2
parking_lot.move_car_down(2) # A car moves from floor 2 to 1
parking_lot.car_exits(1)     # A car exits from floor 1
