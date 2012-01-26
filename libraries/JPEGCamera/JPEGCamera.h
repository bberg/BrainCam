/* Arduino JPeg Camera Library
 * Copyright 2010 SparkFun Electronics
 * Written by Ryan Owens
*/

#ifndef JPEGCamera_h
#define JPEGCamera_h

#include <avr/pgmspace.h>
#if ARDUINO >= 100
  #include "Arduino.h"
#else
  #include "WProgram.h"
#endif

class JPEGCamera
{
	public:
		JPEGCamera();
		void begin(void);
		int reset(char * response);
		int getSize(char * response);
		int takePicture(char * response);
        int sizeLarge(char * response);
		int sizeLargeHard(char * response);
		int stopPictures(char * response);
		int readData(char * response, int address);
		
	private:
		int sendCommand(const char * command, char * response, int length);
};

#endif