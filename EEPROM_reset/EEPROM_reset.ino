#include <EEPROM.h>

void setup(){
  EEPROM.write(0,48);
  EEPROM.write(1,48);
  EEPROM.write(2,49);
}
void loop(){}
