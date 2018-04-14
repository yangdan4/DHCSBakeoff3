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
float centreX = rectX + sizeOfInputArea / 2;
float centreY = rectX + sizeOfInputArea / 2;
int numAreas = 7;
float ang = 2 * PI / numAreas;
float radius = sqrt(pow(sizeOfInputArea, 2) + pow(sizeOfInputArea, 2)) / 2;
float [][][] lines = new float[numAreas][2][2];
int inSomeArea;
PVector lin = new PVector(1, 1);
float pressMouseX = 0;
float pressMouseY = 0;
String [][] letters = {{"q", "r", "s", "t"}, {"u", "v", "w", "x"}, {"y", "z", " ", ""}, {"a", "b", "c", "d"}, {"e", "f", "g", "h"}, {"i", "j", "k", "l"},
{"m", "n", "o", "p"}};
//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases

  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(1000, 1000); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 24)); //set the font to arial 24
  //noStroke(); //my code doesn't use any strokes.
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
    for(int i = 0; i < numAreas; i++)
    {
      line(lines[i][0][0], lines[i][0][1], lines[i][1][0], lines[i][1][1]);
      int j = (i + 1) % numAreas;
      PVector dir1 = new PVector(lines[i][1][0] - lines[i][0][0], lines[i][0][1] - lines[i][1][1]);
      PVector dir2 = new PVector(lines[j][1][0] - lines[j][0][0], lines[j][0][1] - lines[j][1][1]);
      PVector dir3 = new PVector((dir1.x + dir2.x), (-(dir1.y + dir2.y)));
      if(i == 0)
      {
        println(dir3);
      }
      fill(255);
      text(letters[i][0], centreX + dir3.x / 3 - 20, centreY + dir3.y / 3 + 20);
      text(letters[i][1], centreX + dir3.x / 3, centreY + dir3.y / 3);
      if(letters[i][2] != " ")
      {
        text(letters[i][2], centreX + dir3.x / 3 + 20, centreY + dir3.y / 3 + 20);
      }
      else
      {
        text("_", centreX + dir3.x / 3 + 20, centreY + dir3.y / 3 + 20);
      }
      text(letters[i][3], centreX + dir3.x / 3, centreY + dir3.y / 3 + 40);
      text(i, lines[i][1][0], lines[i][1][1]);
    }
  }
}

boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

int inArea()
{
  if(!(mouseX > rectX && mouseX < rectX + sizeOfInputArea && mouseY > rectY && mouseY < rectY + sizeOfInputArea))
  {
    return -1;
  }
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
    println(inSomeArea);
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
  if(startTime == 0)
  {
    nextTrial();
  }
  else
  {
    float endMouseX = mouseX;
    float endMouseY = mouseY;
    if(inSomeArea != -1)
    {
      PVector dir = new PVector(endMouseX - pressMouseX, pressMouseY - endMouseY);
      //println(dir);
      println(degrees(angle(dir, lin)));
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