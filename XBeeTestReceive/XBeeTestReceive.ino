/* Random Conversation
 *  by Jiuxin Zhu and Edanur Kuntman
 *  Note: 
 *  1. The code is for Host (Computer).
 */

/*****************************************************************
XBee_Serial_Passthrough.ino

Set up a software serial port to pass data between an XBee Shield
and the serial monitor.

Hardware Hookup:
  The XBee Shield makes all of the connections you'll need
  between Arduino and XBee. If you have the shield make
  sure the SWITCH IS IN THE "DLINE" POSITION. That will connect
  the XBee's DOUT and DIN pins to Arduino pins 2 and 3.

*****************************************************************/
// We'll use SoftwareSerial to communicate with the XBee:
#include <SoftwareSerial.h>

//For Atmega328P's
// XBee's DOUT (TX) is connected to pin 2 (Arduino's Software RX)
// XBee's DIN (RX) is connected to pin 3 (Arduino's Software TX)
SoftwareSerial XBee(2, 3); // RX, TX

//For Atmega2560, ATmega32U4, etc.
// XBee's DOUT (TX) is connected to pin 10 (Arduino's Software RX)
// XBee's DIN (RX) is connected to pin 11 (Arduino's Software TX)
//SoftwareSerial XBee(10, 11); // RX, TX

byte incomingByte;

void setup()
{
  // Set up both ports at 9600 baud. This value is most important
  // for the XBee. Make sure the baud rate matches the config
  // setting of your XBee.
  XBee.begin(9600);
  Serial.begin(9600);
}

void loop()
{
  // Send the signal from Processing
  if (Serial.available())
  { // If data comes in from serial monitor, send it out to XBee
    XBee.write(Serial.read());
  }

  // Receive the signal from Masks
  if (XBee.available())
  { 
    incomingByte=(XBee.read());
    if (incomingByte == '1') {
      Serial.write(1);
//      Serial.println('1');
    } else if (incomingByte == '2') {
      Serial.write(2);
//      Serial.println('2');
    } else if (incomingByte == '3') {
      Serial.write(3);
//      Serial.println('3');
    } else if (incomingByte == '4') {
      Serial.write(4);
//      Serial.println('4');
    }
  }
}
