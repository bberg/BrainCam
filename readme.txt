BrainCam_1_0_0
Ben Berg
1.22.2012

This project connects a LinkSprite Serial TTL JPEG camera and a Matel MindFlex EEG to a mini SD memory card using an Arduino Uno with the SparkFun Data Shield.

<<--  Quick Start  -->>
1. Hack the MindFlex (http://frontiernerds.com/brain-hack), thanks Eric!
2. Move the contents of the libraries folder to the libraries folder in your sketchbook.
	Libraries have been edited to reduce the size of strings,
		with the original brain library, the arduino will run out of RAM and hang.
3. Upload the BrainCam sketch to the Arduino.
4. Wire it up:
    SparkFun Data Shield -> Arduino 8,10,11,12
    MindFlex Data -> Arduino Digital 0    	(you will have to remove this to update the Arduino)
    MindFlex Ground -> Arduino Ground
    Camera TX -> Arduino Digital 2
    Camera RX -> Arduino Digital 3
    Camera Ground -> Arduino Ground
    Camera VCC -> Arduino 5V
5. Put in SD card, power up Arduino, turn on MindFlex
6. Take Pics & concurrently log your brain state
7. Place the pictures (numbered .txt files) and the log.txt file into the img_processing_2_5 folder
8. Run the script "RenameImages100.vbs" to rename the image files to .JPGs
9. Run Img_Processing sketch, and see images processed based on your brain state!

To reset image numbers, upload and run EEPROM_reset.



<<--  Details  -->>
The MindFlex updates about every 900ms, and it takes about 90s to transfer a 640 x 480 image from the camera to the SD card.
This sketch transfers images to the SD card during the gap between updates from the MindFlex.
The delay between brain updates is the most important variable, and may need to be adjusted.
This delay is slightly extended by the pauses after sending image read commands to the camera (40ms currently).

CURRENT LARGEST ISSUE:STREAKING IN IMAGE - attempted to increase the delay after 
sending the commands to the camera, but this didn't seem to help.

Documentation for the processing sketch is in the works.


<<-- Brain Hack Resources -->>
Many thanks to Eric Mika, Arturo Vidich and Sofy Yuditskaya of ITP who did the original hack of the MindFlex.
Their work is well documented here: http://frontiernerds.com/brain-hack

<<-- Camera Resources -->>
The LinkSprite camera is distributed and documented by sparkfun: http://www.sparkfun.com/products/10061
Other resources are on the LinkSprite Page: http://linksprite.com/product/showproduct.php?lang=en&id=50
This PDF contains the camera communication protocol: http://www.linksprite.com/upload/file/1274419957.pdf


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
