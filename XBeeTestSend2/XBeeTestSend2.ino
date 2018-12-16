/* Random Conversation
 *  by Jiuxin Zhu and Edanur Kuntman
 *  Note: 
 *  1. The code is for Mask B (Player 2).
 *  2. Light sensor threshold needs to be adjusted before use.
 *  3. The value of light sensors used on Mask B increases when it gets dark.
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

#include <Adafruit_NeoPixel.h>

// Which pin on the Arduino is connected to the NeoPixels?
// On a Trinket or Gemma we suggest changing this to 1
#define PIN            7

// How many NeoPixels are attached to the Arduino?
#define NUMPIXELS      1

// When we setup the NeoPixel library, we tell it how many pixels, and which pin to use to send signals.
// Note that for older NeoPixel strips you might need to change the third parameter--see the strandtest
// example for more information on possible values.
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int button = A0;
int button2 = A1;
int buttonState;
int button2State;
byte incomingByte;
byte outgoingByte;

void setup()
{
  // Set up both ports at 9600 baud. This value is most important
  // for the XBee. Make sure the baud rate matches the config
  // setting of your XBee.
  XBee.begin(9600);
  Serial.begin(9600);
  pinMode(button, INPUT);
  pinMode(button2, INPUT);
  pixels.begin(); // This initializes the NeoPixel library.
}

void loop() {
  // Read the signal from the computer and change the light based on the signal
  if (XBee.available())
  { 
    incomingByte=(XBee.read());
    if (incomingByte == 'A') {
      // pixels.Color takes RGB values, from 0,0,0 up to 255,255,255
      pixels.setPixelColor(0, pixels.Color(0,0,0));
      pixels.show(); // This sends the updated pixel color to the hardware.
    } else if (incomingByte == 'B') {
      // pixels.Color takes RGB values, from 0,0,0 up to 255,255,255
      pixels.setPixelColor(0, pixels.Color(255,255,255));
      pixels.show(); // This sends the updated pixel color to the hardware.
    }
  }

  buttonState = analogRead(button);
  button2State = analogRead(button2);
  // For debugging
  Serial.print(buttonState);
  Serial.print(',');
  Serial.println(button2State);

  outgoingByte = '0';
  if (buttonState > 1000) {
    outgoingByte = '1';
    // pixels.Color takes RGB values, from 0,0,0 up to 255,255,255
    pixels.setPixelColor(0, pixels.Color(255,255,255));
    pixels.show(); // This sends the updated pixel color to the hardware.
    delay(2000);
  }
  if (button2State  > 900) {
    outgoingByte = '2'; 
    // pixels.Color takes RGB values, from 0,0,0 up to 255,255,255
    pixels.setPixelColor(0, pixels.Color(255,255,255));
    pixels.show(); // This sends the updated pixel color to the hardware.
    delay(2000);
  }
  XBee.write(outgoingByte);
}
