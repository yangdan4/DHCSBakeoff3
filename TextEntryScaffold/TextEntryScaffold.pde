import java.util.Arrays;
import java.util.Collections;

String[] phrases; //contains all of the phrases
int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 441; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
//http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!
float rectX = 200;
float rectY = 200;
//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';
//centre of rect
float centreX = rectX + sizeOfInputArea / 2;
float centreY = rectX + sizeOfInputArea / 2;
//number of groups of letters
int numAreas = 6;
//angle of each group
float ang = 2 * PI / numAreas;
//radius of the "circle" that encloses the input square
float radius = sqrt(pow(sizeOfInputArea, 2) + pow(sizeOfInputArea, 2)) / 2;
//lines for drawing the groups
float [][][] lines = new float[numAreas][2][2];
//if mouse pressed in some area
int inSomeArea;
//a (1, 1) vector for calculating direction of swipe
PVector lin = new PVector(1, 1);
float pressMouseX = 0;
float pressMouseY = 0;
float pressTime = 0;
//finger lift time
float liftTime = 0;
float holdTime = 0;
//swipe letters
String [][] letters = {{"u", "v", "w", "x"}, {"m", "n", "o", "p"}, {"e", "f", "g", "h"}, {"a", "b", "c", "d"}, {"i", "j", "k", "l"}, {"q", "r", "s", "t"}};
//tap letters, empty strings mean noOp
String [] tapLetters = {"y", "", "z", " ", "", "D"};
String [] nums = {"20", "12", "4", "0", "8", "16"};

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases

  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(1000, 1000); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 24)); //set the font to arial 24
  //noStroke(); //my code doesn't use any strokes.
  //initialize lines for groups
  for(int i = 0; i < numAreas; i++)
  {
    lines[i][0][0] = centreX;
    lines[i][0][1] = centreY;
    lines[i][1][0] = centreX + radius * cos(i * ang);
    lines[i][1][1] = centreY + radius * sin(i * ang);
  }
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(0); //clear background

  // image(watch,-200,200);
  fill(100);
  rect(rectX, rectY, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"

  if (finishTime!=0)
  {
    fill(255);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(255);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }
  if(mousePressed)
  {
    holdTime = millis();
    float currMouseX = mouseX;
    float currMouseY = mouseY;
    //direction of swipe
    PVector dir = new PVector(currMouseX - pressMouseX, pressMouseY - currMouseY);
    fill(255);
    textSize(50);
    if(sqrt(pow(dir.x, 2) + pow(dir.y, 2)) < 20 && holdTime - pressTime < 200)
    {
      /*if(inSomeArea != -1)
      {
        if(tapLetters[inSomeArea] == "D")
        {
          text("<-", centreX - 10, centreY);
        }
        else if(tapLetters[inSomeArea] == " ")
        {
          text("-", centreX - 10, centreY);
        }
        else
        {
          text(tapLetters[inSomeArea], centreX - 10, centreY);
        }
      }*/
    }
    else
    {
      if(inSomeArea != -1)
      {
        //println(dir);
        //println(degrees(angle(dir, lin)));
        //if angle between swipe direction and (1,1) is within some range then it's some letter
        if(angle(dir, lin) <= TWO_PI && angle(dir, lin) > TWO_PI - PI / 2)
        {
          text(letters[inSomeArea][1], centreX - 15, centreY);
        }
        else if(angle(dir, lin) <= TWO_PI - PI / 2 && angle(dir, lin) > PI)
        {
          text(letters[inSomeArea][0], centreX - 15, centreY);
        }
        else if(angle(dir, lin) <= PI && angle(dir, lin) > PI / 2)
        {
          text(letters[inSomeArea][3], centreX - 15, centreY);
        }
        else if(angle(dir, lin) <= PI / 2 && angle(dir, lin) > 0)
        {
          text(letters[inSomeArea][2], centreX - 15, centreY);
        }
      }
    }
  }
  textSize(24);
  if (startTime!=0)
  {
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    text("Entered:  " + currentTyped +"|", 70, 140); //draw what the user has entered thus far 
    fill(255, 0, 0);
    rect(800, 00, 200, 200); //draw next button
    fill(255);
    text("NEXT > ", 850, 100); //draw next label

    //my draw code
    /*textAlign(CENTER);
    text("" + currentLetter, 200+sizeOfInputArea/2, 200+sizeOfInputArea/3); //draw current letter
    fill(255, 0, 0);
    rect(200, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw left red button
    fill(0, 255, 0);
    rect(200+sizeOfInputArea/2, 200+sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2);*/ //draw right green button
    stroke(0);
    strokeWeight(1);
    //draw lines and letters for groups
    
    
    
    
    for(int i = 0; i < numAreas; i++)
    {
      line(lines[i][0][0], lines[i][0][1], lines[i][1][0], lines[i][1][1]);
      int j = (i + 1) % numAreas;
      PVector dir1 = new PVector(lines[i][1][0] - lines[i][0][0], lines[i][0][1] - lines[i][1][1]);
      PVector dir2 = new PVector(lines[j][1][0] - lines[j][0][0], lines[j][0][1] - lines[j][1][1]);
      PVector dir3 = new PVector((dir1.x + dir2.x), (-(dir1.y + dir2.y)));
      fill(255);
      
      // serene -- increase text font upon selection
      if (inSomeArea == i && mousePressed) {
        pushStyle();
        textSize(50);
        fill(255,215,0);
        text(letters[inSomeArea][0], int(pressMouseX-80), int(pressMouseY+10)); // left
        arrow(int(pressMouseX), int(pressMouseY), int(pressMouseX-40), int(pressMouseY));
        text(letters[inSomeArea][1], int(pressMouseX-8), int(pressMouseY-55)); // top
        arrow(int(pressMouseX), int(pressMouseY), int(pressMouseX), int(pressMouseY-40));
        text(letters[inSomeArea][2], int(pressMouseX+55), int(pressMouseY+10)); // right
        arrow(int(pressMouseX), int(pressMouseY), int(pressMouseX+40), int(pressMouseY));
        text(letters[inSomeArea][3], int(pressMouseX-13), int(pressMouseY+70)); // bottom
        arrow(int(pressMouseX), int(pressMouseY), int(pressMouseX), int(pressMouseY+40));
        popStyle();
      }
      else {
        textSize(40);
        text(letters[i][0], centreX + dir3.x / 3 - 35, centreY + dir3.y / 3.5 + 20);
        text(letters[i][1], centreX + dir3.x / 3, centreY + dir3.y / 3.5 - 10);
        text(letters[i][2], centreX + dir3.x / 3 + 30, centreY + dir3.y / 3.5 + 20);
        text(letters[i][3], centreX + dir3.x / 3, centreY + dir3.y / 3.5 + 50);
      }
      //text(nums[i], centreX + dir3.x / 12 - 15, centreY + dir3.y / 12 + 5);
      
      if(tapLetters[i] == " ")
      {
        text("-", centreX + dir3.x / 6 - 5, centreY + dir3.y / 6 + 5);
        if (inSomeArea == 3 && mousePressed) {
          circle(centreX + dir3.x / 6, centreY + dir3.y / 6, 30);
        }
      }
      else if(tapLetters[i] == "D")
      {
        text("<-", centreX + dir3.x / 6 - 5, centreY + dir3.y / 6 + 5);
        if (inSomeArea == 5 && mousePressed) {
          circle(centreX + dir3.x / 6 + 5, centreY + dir3.y / 6 - 5, 40);
        }
      }
      else
      {
        text(tapLetters[i], centreX + dir3.x / 6 - 5, centreY + dir3.y / 6 + 5);
        if (inSomeArea == i && (tapLetters[i] == "y" || tapLetters[i] == "z") && mousePressed) {
          circle(centreX + dir3.x / 6 + 5, centreY + dir3.y / 6 - 5, 40);
        }
      }
      //text(i, lines[i][1][0], lines[i][1][1]);
    }
    

  }
}

// source: https://processing.org/discourse/beta/num_1219607845.html
void arrow(int x1, int y1, int x2, int y2) {
  pushStyle();
  stroke(255,215,0);
  strokeWeight(2);
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
  popStyle();
} 

void circle(float x2, float y2, int rad) {
    pushStyle();
    stroke(255,215,0);
    strokeWeight(3);
    noFill();
    ellipse(x2, y2, rad, rad);
    popStyle();
}
  
boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

//if pressed in some area
int inArea()
{
  //if not in box then noOp
  if(!(mouseX > rectX && mouseX < rectX + sizeOfInputArea && mouseY > rectY && mouseY < rectY + sizeOfInputArea))
  {
    return -1;
  }
  //line side test, there can be one pair of lines where they are on
  //either side of the mouse press
  for(int i = 0; i < numAreas; i++)
  {
    float d1 = (mouseX - lines[i][0][0]) * (lines[i][1][1] - lines[i][0][1])
    - (mouseY - lines[i][0][1]) * (lines[i][1][0] - lines[i][0][0]);
    
    int j = (i + 1) % numAreas;
    float d2 = (mouseX - lines[j][0][0]) * (lines[j][1][1] - lines[j][0][1])
    - (mouseY - lines[j][0][1]) * (lines[j][1][0] - lines[j][0][0]);
    
    if(d1 < 0 && d2 > 0)
    {
      return i;
    }
  }
  return -1;
}

void mousePressed()
{
  if(startTime != 0)
  {
    inSomeArea = inArea();
    pressMouseX = mouseX;
    pressMouseY = mouseY;
    pressTime = millis();
    //println(inSomeArea);
    //You are allowed to have a next button outside the 2" area
    if (didMouseClick(800, 00, 200, 200)) //check if click is in next button
    {
      nextTrial(); //if so, advance to next trial
    }
  }
}
//source: https://forum.processing.org/one/topic/calculating-angle.html
float angle(PVector v1, PVector v2) {
  float a = atan2(v2.y, v2.x) - atan2(v1.y, v1.x);
  if (a < 0) a += TWO_PI;
  return a;
}

void mouseReleased()
{
  liftTime = millis();
  float endMouseX = mouseX;
  float endMouseY = mouseY;
  //direction of swipe
  PVector dir = new PVector(endMouseX - pressMouseX, pressMouseY - endMouseY);
  /*println(dir.x);
  println(dir.y);
  println(liftTime - pressTime);*/
  if(startTime == 0)
  {
    nextTrial();
  }
  //if don't move much and fast press and lift then it's tap
  //feel free to change this to whatever seems right for users
  else if(sqrt(pow(dir.x, 2) + pow(dir.y, 2)) < 20 && liftTime - pressTime < 200)
  {
    if(inSomeArea != -1)
    {
      if(tapLetters[inSomeArea] == "D")
      {
        if(currentTyped.length() > 0)
        {
          currentTyped = currentTyped.substring(0, currentTyped.length() - 1);
        }
      }
      else
      {
        currentTyped += tapLetters[inSomeArea];
      }
    }
  }
  else
  {
    if(inSomeArea != -1)
    {
      //println(dir);
      //println(degrees(angle(dir, lin)));
      //if angle between swipe direction and (1,1) is within some range then it's some letter
      if(angle(dir, lin) <= TWO_PI && angle(dir, lin) > TWO_PI - PI / 2)
      {
        currentTyped += letters[inSomeArea][1];
      }
      else if(angle(dir, lin) <= TWO_PI - PI / 2 && angle(dir, lin) > PI)
      {
        currentTyped += letters[inSomeArea][0];
      }
      else if(angle(dir, lin) <= PI && angle(dir, lin) > PI / 2)
      {
        currentTyped += letters[inSomeArea][3];
      }
      else if(angle(dir, lin) <= PI / 2 && angle(dir, lin) > 0)
      {
        currentTyped += letters[inSomeArea][2];
      }
    }
    else
    {
      
    }
  }
}


void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

  if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.length();
    lettersEnteredTotal+=currentTyped.length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  //probably shouldn't need to modify any of this output / penalty code.
  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output

    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    System.out.println("Raw WPM: " + wpm); //output

    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars

    System.out.println("Freebie errors: " + freebieErrors); //output
    float penalty = max(errorsTotal-freebieErrors, 0) * .5f;

    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
    System.out.println("==================");

    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  } else
  {
    currTrialNum++; //increment trial number
  }

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}



//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}