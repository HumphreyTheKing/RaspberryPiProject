class ParkingLotInitializer:
    def __init__(self, floors, spaces_per_floor=None):
        self.total_cars = 0  #creates a variable for how many cars are currently in
        self.floors = floors #get the total number of floors
        
        #either give total number of floors in initalization or prompt user
        if spaces_per_floor is None:
            self.spaces_per_floor = {i: int(input(f"Enter the number of spaces for floor {i}: ")) for i in range(1, floors + 1)}
        else:
            self.spaces_per_floor = {i: spaces_per_floor[i-1] for i in range(1, floors + 1)}

        self.floor_counts = {i: 0 for i in range(1, floors + 1)}  #dict to hold number of cars per each floor

    def car_enters(self, floor): #fucntion for when a car enters a parking garage
        if floor in self.floor_counts and self.floor_counts[floor] < self.spaces_per_floor[floor]:
            self.total_cars += 1
            self.floor_counts[floor] += 1
            print(f"Car entered on floor {floor}. Total cars: {self.total_cars}. Cars on floor {floor}: {self.floor_counts[floor]}")  #debugging output for when car enter
        else:
            print(f"Floor {floor} is full or invalid.")  #if the floor is full or does not exist

    def car_exits(self, floor): #function for when a car enters the parking garage
        if floor in self.floor_counts and self.floor_counts[floor] > 0:
            self.total_cars -= 1
            self.floor_counts[floor] -= 1
            print(f"Car exited from floor {floor}. Total cars: {self.total_cars}. Cars on floor {floor}: {self.floor_counts[floor]}")  #debugging output for when car exits
        else:
            print(f"No cars on floor {floor} to exit.")  #if there are no cars left to exit

    def move_car_up(self, current_floor): #function for when a car goes up a floor
        if current_floor < self.floors and self.floor_counts[current_floor] > 0 and self.floor_counts[current_floor + 1] < self.spaces_per_floor[current_floor + 1]:
            self.floor_counts[current_floor] -= 1
            self.floor_counts[current_floor + 1] += 1
            print(f"Car moved up from floor {current_floor} to floor {current_floor + 1}")  #debugging text
            self.display_floor_counts()
        else:
            print(f"Cannot move car up from floor {current_floor}")  #if no floors above or if above floor is full

    def move_car_down(self, current_floor): #function for when a car goes down a floor
        if current_floor > 1 and self.floor_counts[current_floor] > 0 and self.floor_counts[current_floor - 1] < self.spaces_per_floor[current_floor - 1]:
            self.floor_counts[current_floor] -= 1
            self.floor_counts[current_floor - 1] += 1
            print(f"Car moved down from floor {current_floor} to floor {current_floor - 1}")  #text for debugging
            self.display_floor_counts()
        else:
            print(f"Cannot move car down from floor {current_floor}")  #if no floor below or if floor is full

    def display_floor_counts(self): #display counters
        print("Current car counts by floor:")
        for floor, count in self.floor_counts.items():
            percentage = (count / self.spaces_per_floor[floor])*100  #calculate percentage for heatmap
            print(f"Floor {floor}: {count}/{self.spaces_per_floor[floor]} cars ({percentage:.2f}%)")  #display heatmap percentage


#example initializations
spaces = [10, 15, 20]  #define spaces in each floor
parking_lot = ParkingLotInitializer(floors=3, spaces_per_floor=spaces)

#example functions
parking_lot.car_enters(1) #car enters garage
parking_lot.move_car_up(1) #car goes to floor 2 to from 1
parking_lot.move_car_down(2) #car goes to floor 1 from 2
parking_lot.car_exits(1) #a car exits the garage
parking_lot.display_floor_counts() #display all values
