/*
BrainCam_1_0_0
This project connects a Serial TTL JPEG camera and a Matel MindFlex EEG to a mini SD memory card using an Arduino Uno.
The MindFlex updates about every 900ms, and it takes about 90s to transfer a 640 x 480 image from the camera to the SD card.
This sketch transfers images to the SD card during the 900ms gap between updates from the MindFlex.

Wiring: 
  MindFlex Data -> Arduino Digital 0 
  MindFlex Ground -> Arduino Ground
  Camera TX -> Arduino Digital 2
  Camera RX -> Arduino Digital 3
  Camera Ground -> Arduino Ground
  Camera VCC -> Arduino 5V


CURRENT LARGEST ISSUE:STREAKING IN IMAGE - attempted to increase the delay after 
sending the commands to the camera, but this didn't seem to help.

    Copyright (C) 2012, Ben Berg

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    For a copy of the GNU General Public License, see <http://www.gnu.org/licenses/>.
*/


// The libraries have been edited to reduce the size of debugging string variables, freeing up RAM
#include <EEPROM.h>
#include <MemoryCard.h>
#include <SdFat.h>
#include <JPEGCamera.h>
#include <NewSoftSerial.h>
#include <Brain.h>

Brain brain(Serial);              // Set up the brain parser, on hardware serial

JPEGCamera camera;                //Set up the camera, on Soft Serial (2,3)

//Timing
unsigned long brainTimer = 0;     // Amount of time since the last brain update
int brainLag = 770;               // Amount of time to wait before checking for a new brain update  <------------- Critical
                                            // Must account for delay after sending commands built into the JPEGcamera library
                                            // currently 40ms, so this is really more like 810ms

//JPEG Camera
char response[32];                // Create a character array to store the cameras response to commands
unsigned int count=0;             // Count is used to store the number of characters in the response string.
long int address=0;               // This will keep track of the data address being read from the camera
int eof=0;                        // eof is a flag for the sketch to determine when the end of a file is detected
unsigned int newSize = 0;         // The size of an image file

// Keep track of the image number
byte counterOne = 48;             // Image number is stored in EEPROM
byte counterTwo = 48;             // in the event of an accidental reset, data will not be overwritten
byte counterThree = 49;           
char imgNum[10] = "/100.txt";     // Image number as a string for the file name
int imgNumCounter;                // Image number as an int for data file

void setup()
{
   Serial.begin(9600);                
   imgNum[3] = char(EEPROM.read(0));  // Recall the image number in case of an accidental reset / power loss
   imgNum[2] = char(EEPROM.read(1));  // To reset the EEPROM image numbers, see the attached sketch
   imgNum[1] = char(EEPROM.read(2));
   counterOne = EEPROM.read(0);
   counterTwo = EEPROM.read(1);
   counterThree = EEPROM.read(2); 
//DEBUG   Serial.println(imgNum);
   imgNumCounter = (counterOne - 48) + (counterTwo - 48)*10 + (counterThree - 48)*100;
//DEBUG   Serial.println(imgNumCounter);

//Setup the camera, serial port and memory card
    camera.begin();
    Serial.println("INIT");
    MemoryCard.begin();                     // Program will HALT without SD card present
    
    count = camera.sizeLarge(response);     //Change image size (RAM)
    delay(2000); 
    count = camera.sizeLargeHard(response); //Redundant, but mysteriously necessary.
    delay(2000);
    count=camera.reset(response);           //Reset the camera
    delay(4000);
    count = camera.sizeLarge(response);     //change image size (RAM)
    delay(2000);
    
    brainRecord(5);                         // Record Brain Data for 5 sec - will HALT without input from MindFlex
    shootPic();                             // Then take a picture
}


void loop(){                                // Main Loop - entered between brain data reads
  transferPic();                            // Continue to transfer the image until timer runs out or image ends
  if (eof==1){                              // If the image is over, advance counter
    picComplete();                          // Reset camera
    brainRecord(4);                         // Delay 4 seconds while transfering brain data
    shootPic();                             // Take another picture
  }
  else{
    brainRecord(0);                         // If brain timer has expired, check for a brain update
  }
}


int secs(){                                 // Turn millis() into secs()
  return (millis() / 1000);
}


void brainRecord(int wait){
  if (wait > 0){                            //  Then collect data for 'wait' seconds
    wait = wait + secs();
    while (wait - secs() > 0){
      if (brain.update()) { 
//DEBUG        Serial.println(millis() - brainTimer);
        brainTimer = millis();
        compBrain(2);
      }
    }
  }
  else {                                   // If the time since the last update > timer > 1050
      if (millis() - brainTimer > brainLag && millis() - brainTimer  < 1050){
        while (millis() - brainTimer > brainLag && millis() - brainTimer  < 1050){
          if (brain.update()){
              brainTimer = millis();
              compBrain(1);
          }
          else{}
        }
      }
    else{                                // Otherwise the system is out of sync, get back in sync
      Serial.println("OOS");
      brainTimer = millis();
           while (millis() - brainTimer <2000 ){
//DEBUG             Serial.println(millis() - brainTimer);
            if (brain.update()){
                brainTimer = millis();
                Serial.println("CLR");
                compBrain(3);
                break;    
            }
          }
    }
  }
}


void compBrain(int prnt){               // Compile the brain data and print to the SD card
//DEBUG  Serial.println(prnt);          // Prints the code 1 - normal, 2 - timed, 3 - cleared OOS
  String brainData = "";
  brainData += secs();                  // Time
  brainData += ",";
  brainData += imgNumCounter;           // Image Number as INT
  brainData += ",";
  brainData += imgNum;                  // Image Dir as string
  brainData += ",";
  brainData += brain.readCSV();         // Brain data
  MemoryCard.open("log.txt", true;
  MemoryCard.file.println(brainData);   // Write the brain data to the log file
  MemoryCard.close();
  if (prnt == 2 || prnt == 1)Serial.println(brainData);
  brainData = "";                    
}


void shootPic(){
  count = 0;                                   //reset writing variables
  address = 0;
  response[7]=0;
  response[8]=0;
  count = camera.sizeLarge(response);
  delay(200);
  count=camera.takePicture(response);
  delay(200);
  count = camera.getSize(response);                  
  delay(100);
       byte   leftbyte = (response[7]);       // parse the size of the image
       byte   rightbyte = (response[8]);
       newSize = (leftbyte*256)+rightbyte;    // prevents the error in the SparkFun code at 640x480
       Serial.println(newSize);
       delay(200);
}


void transferPic(){
      MemoryCard.open(imgNum, true);
          while(address < newSize)
        {
            //Read the data starting at the current address.
            count=camera.readData(response, address);
            //Store all of the data that we read to the SD card
            for(int i=0; i<count; i++){
                //Check the response for the eof indicator (0xFF, 0xD9). If we find it, set the eof flag
                if((response[i] == (char)0xD9) && (response[i-1]==(char)0xFF))eof=1;
                //Save the data to the SD card
                MemoryCard.file.write(response[i]);
                //If we found the eof character, get out of this loop and stop reading data
                  if(eof==1)break;
            }
            //Increment the current address by the number of bytes we read
            address+=count;
            //If the brain timer has elapsed, get out of the loop and look for a brain update
            if(millis() - brainTimer > brainLag||eof==1)break;
        }
        MemoryCard.close();
}


void picComplete(){
 eof = 0;
 Serial.println(imgNum);
 counterOne++;
 EEPROM.write(0,counterOne);            // Update the img counters and write to EEPROM
 if (counterOne > 57){
   counterOne = 48;
   counterTwo++;
   EEPROM.write(1,counterTwo);
 }
 if (counterTwo > 57){
   counterTwo = 48;
   counterThree++;
   EEPROM.write(2,counterThree);
 }
   imgNum[3] = counterOne;              //Update the imgNum string
   imgNum[2] = counterTwo;
   imgNum[1] = counterThree;
   imgNumCounter = (counterOne - 48) + (counterTwo - 48)*10 + (counterThree - 48)*100;
   Serial.println(imgNumCounter);
   count=camera.reset(response);
}


/*
Maybe use this to check the amount of memory during writing to see if overload is causing streaking

uint8_t * heapptr, * stackptr;
void check_mem() {
  stackptr = (uint8_t *)malloc(4);          // use stackptr temporarily
  heapptr = stackptr;                     // save value of heap pointer
  free(stackptr);      // free up the memory again (sets stackptr to 0)
  stackptr =  (uint8_t *)(SP);           // save value of stack pointer
}
*/

