/* Arduino JPEGCamera Library
 * Copyright 2010 SparkFun Electronic
 * Written by Ryan Owens
 * Edited by Ben Berg (Dec 10, 2012)
*/

#include <avr/pgmspace.h>
#include "JPEGCamera.h"
#if ARDUINO >= 100
  #include "Arduino.h"
#else
  #include "WProgram.h"
#endif
#include "NewSoftSerial.h"

//Commands for the LinkSprite Serial JPEG Camera
const char GET_SIZE[5] = {0x56, 0x00, 0x34, 0x01, 0x00};
const char SIZE_LARGE[5] = {0x56, 0x00, 0x54, 0x01, 0x00};
const char SIZE_LARGE_HARD[9] = {0x56, 0x00, 0x31, 0x05, 0x04, 0x01, 0x00, 0x19, 0x00};
const char RESET_CAMERA[4] = {0x56, 0x00, 0x26, 0x00};
const char TAKE_PICTURE[5] = {0x56, 0x00, 0x36, 0x01, 0x00};
const char STOP_TAKING_PICS[5] = {0x56, 0x00, 0x36, 0x01, 0x03};
char READ_DATA[8] = {0x56, 0x00, 0x32, 0x0C, 0x00, 0x0A, 0x00, 0x00};

//We read data from the camera in chunks, this is the chunk size
const int read_size=32;

//Make sure the camera is plugged into pins 2 and 3 for Rx/Tx
NewSoftSerial cameraPort(2,3);

JPEGCamera::JPEGCamera()
{
}

//Initialize the serial connection
void JPEGCamera::begin(void)
{
	//Camera baud rate is 38400
	cameraPort.begin(38400);
}

//Get the size of the image currently stored in the camera
//pre: response is an empty string. size is a pointer to an integer
//post: response string contains the entire camera response to the GET_SIZE command
//		size is set to the size of the image
//return: number of characters in the response string
//usage: length = camera.getSize(response, &img_size);
int JPEGCamera::getSize(char * response)
{
	int count=0;
	//Send the GET_SIZE command string to the camera
	count = sendCommand(GET_SIZE, response, 5);
	//Read 4 characters from the camera and add them to the response string
	for(int i=0; i<4; i++)
	{
		while(!cameraPort.available());
		response[count+i]=cameraPort.read();
	}
	//Set the number of characters to return
	count+=4;
	//Send the number of characters in the response back to the calling function
	return count;
}

//Reset the camera
//pre: response is an empty string
//post: response contains the cameras response to the reset command
//returns: number of characters in the response
//Usage: camera.reset(response);
int JPEGCamera::reset(char * response)
{
	int count=0;
	//Send the GET_SIZE command string to the camera
	count = sendCommand(RESET_CAMERA, response, 4);
	
	//Read 4 characters from the camera and add them to the response string
	//Set the number of characters to return

	//The size is in the last 2 characters of the response.
	//Parse them and convert the characters to an integer
	//Send the number of characters in the response back to the calling function
	return count;
}


//Set image size to 640x480
//pre: response is an empty string
//post: response contains the cameras response to the SIZE_LARGE command
//returns: number of characters in the response
//Usage: camera.sizeLarge(response);
int JPEGCamera::sizeLarge(char * response)
{
	//Serial.println("DEBUG 2");
	int count = 0;
	//Serial.println("DEBUG 3");
	count = sendCommand(SIZE_LARGE, response, 5);
	return count;
}

int JPEGCamera::sizeLargeHard(char * response)
{
	response[0, 5] = 0;
	int count = 0;
	cameraPort.flush();  
	cameraPort.write(0x56);
	cameraPort.write(0x00);
	cameraPort.write(0x31);
	cameraPort.write(0x05);
	cameraPort.write(0x04);
	cameraPort.write(0x01);
	cameraPort.write(0x00);
	cameraPort.write(0x19);
	cameraPort.write(0x00);
	for(int i=0; i<4; i++)
	{
		while(!cameraPort.available());
		*response++=cameraPort.read();	
		count+=1;
	}
	
	//return the number of characters in the response string
	return count;
}


//Take a new picture
//pre: response is an empty string
//post: response contains the cameras response to the TAKE_PICTURE command
//returns: number of characters in the response
//Usage: camera.takePicture(response);
int JPEGCamera::takePicture(char * response)
{
	return sendCommand(TAKE_PICTURE, response, 5);
}

//Stop taking pictures
//pre: response is an empty string
//post: response contains the cameras response to the STOP_TAKING_PICS command
//returns: number of characters in the response
//Usage: camera.stopPictures(response);
int JPEGCamera::stopPictures(char * response)
{
	return sendCommand(STOP_TAKING_PICS, response, 5);
}

//Get the read_size bytes picture data from the camera
//pre: response is an empty string, address is the address of data to grab
//post: response contains the cameras response to the readData command, but the response header is parsed out.
//returns: number of characters in the response
//Usage: camera.readData(response, cur_address);
//NOTE: This function must be called repeatedly until all of the data is read
//See Sample program on how to get the entire image.
int JPEGCamera::readData(char * response, int address)
{
	int count=0;

	//Flush out any data currently in the serial buffer
	cameraPort.flush();
	
	//Send the command to get read_size bytes of data from the current address
	for(int i=0; i<8; i++)cameraPort.print(READ_DATA[i]);
	cameraPort.write(address>>8);
	cameraPort.write(address);
	cameraPort.write(0x00);
	cameraPort.write(0x00);
	cameraPort.write(read_size>>8);
	cameraPort.write(read_size);
	cameraPort.write(0x00);
	cameraPort.write(0x0A);	
	delay(40);

	//Print the data to the serial port. Used for debugging.
	/*
	for(int i=0; i<8; i++)Serial.print(READ_DATA[i]);
	Serial.write(address>>8);
	Serial.write(address);
	Serial.write(0x00);
	Serial.write(0x00);
	Serial.write(read_size>>8);
	Serial.write(read_size);
	Serial.write(0x00);
	Serial.write(0x0A);	
	Serial.println();
	*/

	//Read the response header.
	for(int i=0; i<5; i++){
		while(!cameraPort.available());
		cameraPort.read();
	}
	
	//Now read the actual data and add it to the response string.
	count=0;
	while(count < read_size)
	{
		while(!cameraPort.available());
		*response++=cameraPort.read();
		count+=1;
//		Serial.print(response[count]);
	}
	
	//Return the number of characters in the response.
	return count;
}

//Send a command to the camera
//pre: cameraPort is a serial connection to the camera set to 3800 baud
//     command is a string with the command to be sent to the camera
//     response is an empty string
//	   length is the number of characters in the command
//post: response contains the camera response to the command
//return: the number of characters in the response string
//usage: None (private function)
int JPEGCamera::sendCommand(const char * command, char * response, int length)
{
	char c=0;
	int count=0;
	//Clear any data currently in the serial buffer
	cameraPort.flush();
	//Send each character in the command string to the camera through the camera serial port
	for(int i=0; i<length; i++){
		cameraPort.print(*command++);
	}
	//Get the response from the camera and add it to the response string.
	for(int i=0; i<length; i++)
	{
		while(!cameraPort.available());
		*response++=cameraPort.read();	
		count+=1;
	}
	
	//return the number of characters in the response string
	return count;
}
