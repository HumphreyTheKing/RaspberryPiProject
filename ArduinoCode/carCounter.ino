//duplicate for number of sensors this only assumes entrance counting would need to duplicate for exit
#define TRIG_PIN1 9 //entrance sensor
#define ECHO_PIN1 10

#define TRIG_PIN2 11 //exit sensor
#define ECHO_PIN2 12

#define DISTANCE_THRESHOLD 50
#define HUMAN_TIME_THRESHOLD 200
#define CAR_TIME_THRESHOLD 500


void setup() {
   //getting rasppi to take input from serial usb 
  Serial.begin(9600); //from arduino ide
    pinMode(TRIG_PIN1, OUTPUT);
    pinMode(ECHO_PIN1, INPUT);
    pinMode(TRIG_PIN2, OUTPUT);
    pinMode(ECHO_PIN2, INPUT);
}

void loop() {
    handleSensor(1, TRIG_PIN1, ECHO_PIN1);
    handleSensor(2, TRIG_PIN2, ECHO_PIN2);
    delay(500); //small delay between readings to avoid overlapping signals
}

void handleSensor(int sensorID, int trigPin, int echoPin) {
    //this sends the pulse from the ultrasonic sensors 
    //in the constant loop in order to keep having it detect
    //with delays of 2, and 1, millisecond in between
    digitalWrite(TRIG_PIN, LOW);
    delayMicroseconds(2);
    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG_PIN, LOW);


    //reads in the time it took for the pulse to be sent back
    long duration = pulseIn(ECHO_PIN, HIGH);
    float distance = duration * 0.034 / 2;  // Calculate distance in cm

    if (distance > 0 && distance < DISTANCE_THRESHOLD) { //begin checking time
        unsigned long startTime = millis();
        bool isHuman = false;

        while (millis() - startTime < CAR_TIME_THRESHOLD) { //if it is within car threshhold time
            digitalWrite(TRIG_PIN, LOW);
            delayMicroseconds(2);
            digitalWrite(TRIG_PIN, HIGH);
            delayMicroseconds(10);
            digitalWrite(TRIG_PIN, LOW);

            long newDuration = pulseIn(ECHO_PIN, HIGH); //continuously update
            float newDistance = newDuration * 0.034 / 2;

            if (abs(newDistance - distance) > 10) { //condition for if human
                isHuman = true;
                break;
            }
        }

        if (isHuman) { //debugging information and printing
            Serial.print("Human Detected on Sensor ");
            Serial.println(sensorID);
        } else {
            Serial.println("CarEnters"); //for database processing
            Serial.println(sensorID);
        }
        delay(1000);
    }
}