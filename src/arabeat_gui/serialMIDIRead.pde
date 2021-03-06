/*
This file contains the function which reads the Byte serial and converts into command
and Data.Then using this data plot the Graph.
*/
import processing.serial.*;

Serial serial;
int baudrate= 115200;
final int AnalogVal0 = 0xE0;
final int DigitalVal0 = 0x90;
String portName;
int negativeConversion = -65536;
int data;
int command;

/*
Reads the Serial using MIDI and Firmat Protocol
and calls the Plot function according the data
Detailed Explanation in the README.md
*/
void serialMIDIRead(){
   command= serial.read();
      data= 0;
      switch(command){

        // Add a case for every command value you want to listen
        case AnalogVal0:
          // For first 2 MSB
          while(serial.available()==0);
          data= (serial.read())<<7;
          //For middle 7 Bits
          while(serial.available()==0);
          data= (data|serial.read())<<7;
          //For last 7 Bits
          while(serial.available()==0);
          data= (data|serial.read());
          // if the first MSB has set bit then the Val is negative
          if(data>32767) data= data| negativeConversion;
          graph1Plot(data);
          break;

        case DigitalVal0:
          while(serial.available()==0);
          data=serial.read();
          graph2Plot(data);
          break;
      }
}
