/*
This file contains the Funtions called while the Draw function of
processing is runs which mostly includes ploting the Graph, Making Objects Dynamic
and Creating Animation
*/
int sequenceLength= 12;
PImage[] animationSequence = new PImage[sequenceLength+1];
int lastFrame= 1;
int lastTime=1;
int bpm= 80;
boolean isPortChoosen = false;
boolean isFullScreen= false;

/*
This function uses the bpm and the time since the program started (milis())
to switch to the next frame of the animation
*/
void createAnimation(int bpm){
  int timeDiff =  millis() - lastTime;
  int requiredTimeDiff = int((60*1000)/(bpm*sequenceLength));
  image(animationSequence[lastFrame], width*0.55+120,height*0.45+180);
  if(timeDiff>=requiredTimeDiff){
    //change frame
    lastTime= millis();
    lastFrame= (lastFrame%sequenceLength)+1;
  }
}


/*
This function is called when any of the dropdown is selected. (Baudrate/Port)
*/
void controlEvent(ControlEvent theEvent) {

  if(theEvent.isController() &&  (theEvent.getController().getName()).equals("baudrate")){
    int index = int(theEvent.getController().getValue());
    baudrate = baudrateList[index];
    println("Baudrate Choosen : "+ baudrate);
  }
  else if (theEvent.isController() &&  (theEvent.getController().getName()).equals("choosePort")) {
    int portNumber= int(theEvent.getController().getValue());
    portName = Serial.list()[portNumber];
    println("Port Choosen : "+ portName);
    serial = new Serial(this, portName, baudrate);
    isPortChoosen = true;
  }

}

/*
Plots the points into the Digital Graph (Plot 2)
Push function is used because we need to continously add as well as remove a point
*/
void graph2Plot(int val){
 println("DigitalVal0:"+val);
          plot2.push("digitalData", val);
          cp5.getController("digitalVal0").setValue(val);
}

/*
Plots the points into Analog Grph (Plot1)
here I manually add a point and symoltaneously remove a point.
*/
void graph1Plot(int val){
    while(plot1.getPointsRef().getNPoints()>cp5.getController("timeScale").getValue()){
           plot1.removePoint(0);
        }
    println("AnalogVal0:"+val);
    plot1.addPoint(relativeTime,val);
    relativeTime+=1;
    cp5.getController("analogVal0").setValue(val);

}

/*
This function is called in every frame of Processing
It checks the size of the Screen and according to that changes the dimensions
of other objects in the Screen to make them more Dynamic
*/
void GUIDraw(){
 //image(animationSequence[1], 1000, 150);
  // Add Header Image
  image(headerImage, (width/2)-125 , 10);
  createAnimation(bpm);
  bpm = int(cp5.getController("BPM").getValue());

  //Draw the first plot
  //plot1.activatePanning();
  plot1.beginDraw();
  plot1.setDim(width*0.55,height*0.45);
  plot1.setPos(10, headerImage.height+10);
  plot1.drawBackground();
  plot1.drawBox();
  plot1.drawXAxis();
  plot1.drawYAxis();
  plot1.drawTitle();
  plot1.drawGridLines(GPlot.BOTH);
  plot1.drawLines();
  plot1.endDraw();

  plot2.setPosition(73, headerImage.height+height*0.45+85)
       .setSize(int(width*0.56), int(height*0.20));

  accordion.setPosition(width*0.68,headerImage.height+50);
}

/*
Makes the size of the surface equal to that of the screen
*/
public void setFullScreen(){
  if(!isFullScreen){
    buttonFullScreen.setImage(buttonMinimizeImage);
    surface.setSize(displayWidth, displayHeight);
    isFullScreen = true;
  }
  else {
    buttonFullScreen.setImage(buttonFullScreenImage);
    surface.setSize(850,600);
     isFullScreen = false;
  }
}

/*
This Stops the Serial, Cleans the Graph, and Refreshes the Serial Port List
*/
public void refreshEverything(){
   if(isPortChoosen){
   isPortChoosen = false;
   serial.stop();
   }
  choosePortDropdown.clear();
  for (int i=0;i<(Serial.list()).length;i++) {
    choosePortDropdown.addItem(Serial.list()[i], i);
  }
   while(plot1.getPointsRef().getNPoints()>0){
           plot1.removePoint(0);
        }

}
