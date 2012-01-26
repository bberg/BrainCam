// Arduino Brain Library
// Basic brain example, blinks an LED on pin 13 faster as your "attention" value increases.
// Adapted from the Blink without Delay example distributed with Arduino environment.
// Eric Mika, 2010

#include <Brain.h>
#include <NewSoftSerial.h>

// Set up the brain parser, pass it the serial object you want to listen on.

// Create a NewSoftSerial connection, TX on pin 2, and RX on pin 3
// Download the library here: http://arduiniana.org/libraries/NewSoftSerial/
NewSoftSerial softBrain(2, 3);

Brain brain(softBrain);

const int ledPin = 13; // 13 is handy because it's on the board.
long interval = 500; // Changes based on attention value.
long previousMillis = 0;
int ledState = LOW;     

void setup() {
	// Set up the LED pin.
	pinMode(ledPin, OUTPUT);
	
	// Start the hardware serial.
	Serial.begin(9600);
}

void loop() {
	// Expect packets about once per second.
	if (brain.update()) {
		Serial.println(brain.readCSV());
		
		// Attention runs from 0 to 100.
		interval = (100 - brain.readAttention()) * 10;
	}
	
	// Make sure we have a signal.
	if(brain.readSignalQuality() == 0) {
		
		// Blink the LED.
	  if (millis() - previousMillis > interval) {
	    // Save the last time you blinked the LED.
	    previousMillis = millis();   

	    // If the LED is off turn it on and vice-versa:
	    if (ledState == LOW)
	      ledState = HIGH;
	    else
	      ledState = LOW;
      
	    // Set the LED with the ledState of the variable:
	    digitalWrite(ledPin, ledState);
	  }	
	}
	else {
    digitalWrite(ledPin, LOW);
	}
	
}