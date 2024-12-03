//code written in arduino IDE and subsequently uploaded to board
//pins that were plugged into from board
#define TRIG_PIN 9
#define ECHO_PIN 10


void setup(){
    //getting rasppi to take input from serial usb 
    Serial.begin(9600);
    pinMode(TRIG_PIN, OUTPUT);
    pinMode(ECHO_PIN, INPUT);
}

//main code goes here, runs repeatedly
void loop(){
    //this sends the pulse from the ultrasonic sensors 
    //in the constant loop in order to keep having it detect
    //with delays of 2, and 1, millisecond in between
    digitalWrite(TRIG_PIN, LOW);
    delay(2000);
    digitalWrite(TRIG_PIN, HIGH);
    delay(1000); 
    digitalWrite(TRIG_PIN, LOW);

    //reads in the time it took for the pulse to be sent back
    long duration = pulseIn(ECHO_PIN, HIGH);
    float distance = duration * 0.034 / 2


    //if something took less than normal time,
    //it is assumed that a car was detected
    if(distance<50){
        Serial.println("Car Detected");
        delay(1000);
    }

}