/* Random Conversation
 *  by Jiuxin Zhu and Edanur Kuntman, Dec 12, 2018
 *  Last Modification: Dec 16, 2018
 *  Note: To run the code without an Adurino connected to the computer,
 *  please comment codes related to serial communication. You can use
 *  'a', 's', 'd', 'f' to make selections, which are used for debugging.
 */

import processing.serial.*;
import processing.sound.*;

// Variables for serial connection
Serial myPort;  // Create object from Serial class
int val = 0;      // Data received from the serial port

// Variables for the game
boolean is_heading = true; // Display heading or not
boolean is_player1 = true; // Who's turn?
boolean is_left = true; // Which button did the player choose?
int left_count = 0;  // How many times did players choose the button on the left? Max is 10.
int right_count = 0;  // How many times did players choose the button on the right? Max is 10.
int left = 0; // The index of the sentence that left button indicates
int right = 0; // The index of the sentence the right button indicates
int picked = 0; // The index of the sentence that player picked
long startTime = 0; // For text to last for 5 seconds

// Variables for font and soundfiles
PFont Gill;
// Female sounds
SoundFile v0; SoundFile v1; SoundFile v2; SoundFile v3; SoundFile v4;
SoundFile v5; SoundFile v6; SoundFile v7; SoundFile v8; SoundFile v9;
SoundFile v10; SoundFile v11; SoundFile v12; SoundFile v13; SoundFile v14;
SoundFile v15; SoundFile v16; SoundFile v17; SoundFile v18; SoundFile v19;
// Male sounds
SoundFile v20; SoundFile v21; SoundFile v22; SoundFile v23; SoundFile v24;
SoundFile v25; SoundFile v26; SoundFile v27; SoundFile v28; SoundFile v29;
SoundFile v30; SoundFile v31; SoundFile v32; SoundFile v33; SoundFile v34;
SoundFile v35; SoundFile v36; SoundFile v37; SoundFile v38; SoundFile v39;

// Sentence states map
int[] map = { 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0,
              0, 0, 0, 0, 0,
              0, 0, 0, 0, 0 }; // 0: available; 1: used
String[] sentences = { "I can't keep this conversation going if you don't look me into the eyes.", //*
                       "Why are you looking at me like that?",
                       "Rumor has it, I make you nervous.",
                       "I feel that I'm out of luck these days.",
                       "Pretty soon, you will see tears in my eyes.", //*
                       "I am alone in the dark.",
                       "Wow I can't believe I said that out loud.", //*
                       "Do you not like when I look at you like that?",
                       "You weren't supposed to see me in this.", //*
                       "You know what, we all become what we pretend to be.", //*
                       
                       "I'd like to tell you what I know.",
                       "We all become what we pretend to be.", //*
                       "You wish! But life is full of surprises.", 
                       "Nobody has an objective experience of reality.",
                       "Just be yourself.",
                       "No matter what, everything is going to be fine.", //*
                       "I suggest, you speak less than you know.", //*
                       "Sometimes you confuse me.",
                       "It seems like you enjoy talking.", //*
                       "A thousand times yes." };

void setup() 
{
  startTime = millis();
  size(1920, 1080);
  
  // Serial connection
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
  // Game preparation
  left = pick_left();
  right = pick_right();
  
  // Font
  // Uncomment the following two lines to see the available fonts 
  //String[] fontList = PFont.list();
  //printArray(fontList);
  Gill = createFont("Gill Sans MT", 32);
  textFont(Gill);
  
  // Soundfiles
  // Female sounds
  v0 = new SoundFile(this, "0.wav");  v1 = new SoundFile(this, "1.wav");
  v2 = new SoundFile(this, "2.wav");  v3 = new SoundFile(this, "3.wav");
  v4 = new SoundFile(this, "4.wav");  v5 = new SoundFile(this, "5.wav");
  v6 = new SoundFile(this, "6.wav");  v7 = new SoundFile(this, "7.wav");
  v8 = new SoundFile(this, "8.wav");  v9 = new SoundFile(this, "9.wav");
  v10 = new SoundFile(this, "10.wav");  v11 = new SoundFile(this, "11.wav");
  v12 = new SoundFile(this, "12.wav");  v13 = new SoundFile(this, "13.wav");
  v14 = new SoundFile(this, "14.wav");  v15 = new SoundFile(this, "15.wav");
  v16 = new SoundFile(this, "16.wav");  v17 = new SoundFile(this, "17.wav");
  v18 = new SoundFile(this, "18.wav");  v19 = new SoundFile(this, "19.wav");
  // Male sounds
  v20 = new SoundFile(this, "20.wav");  v21 = new SoundFile(this, "21.wav");
  v22 = new SoundFile(this, "22.wav");  v23 = new SoundFile(this, "23.wav");
  v24 = new SoundFile(this, "24.wav");  v25 = new SoundFile(this, "25.wav");
  v26 = new SoundFile(this, "26.wav");  v27 = new SoundFile(this, "27.wav");
  v28 = new SoundFile(this, "28.wav");  v29 = new SoundFile(this, "29.wav");
  v30 = new SoundFile(this, "30.wav");  v31 = new SoundFile(this, "31.wav");
  v32 = new SoundFile(this, "32.wav");  v33 = new SoundFile(this, "33.wav");
  v34 = new SoundFile(this, "34.wav");  v35 = new SoundFile(this, "35.wav");
  v36 = new SoundFile(this, "36.wav");  v37 = new SoundFile(this, "37.wav");
  v38 = new SoundFile(this, "38.wav");  v39 = new SoundFile(this, "39.wav");
}

void draw()
{
  // Serial communication
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
  }
  
  // Game
  fill(0);
  rect(0, 0, width/2, height);
  fill(255);
  rect(width/2, 0, width/2, height);
  println(millis() - startTime); // For debugging
  if (millis() - startTime < 5000) {
    // Display heading or sentence, no choice of button can be made at this stage
    if (is_heading) {
      // Heading
      textAlign(CENTER, CENTER);
      fill(255);
      text("Conversation", width/4, height/2);
      fill(0);
      text("by Jiuxin Zhu & Edanur Kuntman", width*3/4, height/2);
      textAlign(LEFT, TOP);
    } else {
      // Display sentence
      if (is_left) {
        fill(0);
        rect(0, 0, width, height);
        fill(255);
      } else {
        fill(255);
        rect(0, 0, width, height);
        fill(0);
      }
      text(sentences[picked], width/4, height/3);
    }
  } else {
    // Wait for players to make a selection, and set variables
    if (val == 1 && is_player1) {              // If the serial value is 1,
      is_heading = false;                      // 1. No heading
      is_left = true;                          // 2. Make the selection,
      picked = left;                           // mark in the map,
      map[picked] = 1;
      left_count++;                            // increase the counter,
      check_and_pick();                        // and assign new sentences to buttons
      val = 0;                                 // 3. Reset signal receiver
      startTime = millis();                    // 4. Play voice
      voices(picked);
      is_player1 = false;                      // 5. Change player
    } else if (val == 2 &&  is_player1) {              // If the serial value is 2,
      is_heading = false;
      is_left = false;
      picked = right;
      map[picked] = 1;
      right_count++;
      check_and_pick();
      val = 0;
      startTime = millis();
      voices(picked);
      is_player1 = false;
    } else if (val == 3 && !is_player1) {              // If the serial value is 3,
      is_heading = false;
      is_left = true;
      picked = left;
      map[picked] = 1;
      left_count++;
      check_and_pick();
      val = 0;
      startTime = millis();
      voices(picked);
      is_player1 = true;
    } else if (val == 4 && !is_player1) {              // If the serial value is 4,
      is_heading = false;
      is_left = false;
      picked = right;
      map[picked] = 1;
      right_count++;
      check_and_pick();
      val = 0;
      startTime = millis();
      voices(picked);
      is_player1 = true;
    }
  }
  
  // For debugging
  if (keyPressed) {
    if (key == 'a' || key == 'A') {
      val = 1;
    } else if (key == 's' || key == 'S') {
      val = 2;
    } else if (key == 'd' || key == 'D') {
      val = 3;
    } else if (key == 'f' || key == 'F') {
      val = 4;
    }
  }
  
  // Serial communication, broadcast current player to masks
  if (is_player1) {
    myPort.write('A');
  } else {
    myPort.write('B');
  }
}

// Help functions
// Randomly pick a sentence for left button
int pick_left() {
  int index = int(random(10));
  while (map[index] == 1) {
    index = int(random(10));
  }
  return index;
}

// Randomly pick a sentence for right button
int pick_right() {
  int index = int(random(10, 20));
  while (map[index] == 1) {
    index = int(random(10, 20));
  }
  return index;
}

// Check button counters and assign new sentences to buttons 
void check_and_pick() {
  if (left_count == 10) {
    for (int i = 0; i < 10; i++) {
      map[i] = 0;
    }
    left_count = 0;
  }
  if (right_count == 10) {
    for (int i = 10; i < 20; i++) {
      map[i] = 0;
    }
    right_count = 0;
  }
  left = pick_left();
  right = pick_right();
}

// Play a sound file based on player and the choice
void voices(int index) {
  if (!is_player1) {
    // Female voice
    if (index == 0) {
      v0.play();
    } else if (index == 1) {
      v1.play();
    } else if (index == 2) {
      v2.play();
    } else if (index == 3) {
      v3.play();
    } else if (index == 4) {
      v4.play();
    } else if (index == 5) {
      v5.play();
    } else if (index == 6) {
      v6.play();
    } else if (index == 7) {
      v7.play();
    } else if (index == 8) {
      v8.play();
    } else if (index == 9) {
      v9.play();
    } else if (index == 10) {
      v10.play();
    } else if (index == 11) {
      v11.play();
    } else if (index == 12) {
      v12.play();
    } else if (index == 13) {
      v13.play();
    } else if (index == 14) {
      v14.play();
    } else if (index == 15) {
      v15.play();
    } else if (index == 16) {
      v16.play();
    } else if (index == 17) {
      v17.play();
    } else if (index == 18) {
      v18.play();
    } else if (index == 19) {
      v19.play();
    }
  } else {
    // Male voice
    if (index == 0) {
      v20.play();
    } else if (index == 1) {
      v21.play();
    } else if (index == 2) {
      v22.play();
    } else if (index == 3) {
      v23.play();
    } else if (index == 4) {
      v24.play();
    } else if (index == 5) {
      v25.play();
    } else if (index == 6) {
      v26.play();
    } else if (index == 7) {
      v27.play();
    } else if (index == 8) {
      v28.play();
    } else if (index == 9) {
      v29.play();
    } else if (index == 10) {
      v30.play();
    } else if (index == 11) {
      v31.play();
    } else if (index == 12) {
      v32.play();
    } else if (index == 13) {
      v33.play();
    } else if (index == 14) {
      v34.play();
    } else if (index == 15) {
      v35.play();
    } else if (index == 16) {
      v36.play();
    } else if (index == 17) {
      v37.play();
    } else if (index == 18) {
      v38.play();
    } else if (index == 19) {
      v39.play();
    }
  }
}
