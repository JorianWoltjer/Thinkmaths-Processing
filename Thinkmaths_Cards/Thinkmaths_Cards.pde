// Information ----------------------------------------------------------------------------+
// | This project was made to solve the 'face-down card game' by Matt Parker               |
// | More information about this game on the following video: https://youtu.be/oCMVUROty0g |
// +---------------------------------------------------------------------------------------+

// Changeable variables -----------------+
int cards = 4; //                        |
boolean interactive = false; //          |
float padding = 10; //                   |
// --------------------------------------+

int[] solution = new int[(int)Math.pow(2, cards)-1];
int currentStep;
int currentMax;
float timerOffset = 0;
boolean[] up = new boolean[cards];
boolean pmousePressed;

void setup() {
  if (!interactive) {
    frameRate(60); // <-- Remove this line for maximum speed
  }
  size(640, 360);
  surface.setResizable(true);
  background(50);
  noStroke();
  textAlign(CENTER, CENTER);

  currentStep = 0;
  for (int i = 0; i < cards; i++) { // Shuffle cards randomly
    up[i] = random(0, 1) > 0.5;
  }

  if (frameCount == 0) { // First time loading
    createSolution(cards, floor(solution.length*0.5), (int)Math.pow(2, cards-2));
    printSolution();
  } else { // After resetting
    fill(0, 200, 100);
    text("FINISHED", width/2, height/2);
  }
}

void draw() {
  background(50);

  float cardSize = (width-padding*(cards+1))/float(cards);
  boolean finished = true;
  for (int i = 0; i < cards; i++) {
    float leftWall = padding*(i+1)+cardSize*i;
    float rightWall = (padding+cardSize)*(i+1);

    // Check for clicking card
    fill(255);
    if (interactive && mouseX < rightWall && mouseX > leftWall && mouseY < height-padding && mouseY > padding) { // If mouse over card
      fill(200);
      if (mousePressed && !pmousePressed) {
        up[i] = !up[i]; // Turn over card
      }
    }

    // Draw card
    rect(leftWall, padding, cardSize, height-padding*2);
    fill(50);
    if (up[i]) {
      textSize(cardSize/2);
      text("UP", (leftWall+rightWall)/2, height/2);
      finished = false;
    }
  }
  if (finished) {
    stroke(50);
    strokeWeight(10);
    fill(0, 255, 0);
    textSize(72);
    text("FINISHED", width/2, height/2);
    if (interactive) {
      noLoop();
    } else {
      currentMax = max(currentStep, currentMax);
      println("solved in " + currentStep + " steps, current max: " + currentMax + " time: " + nf((millis()-timerOffset)/1000, 0, 3));
      timerOffset = millis();
      setup();
    }
  } else if (!interactive) {
    up[cards-solution[currentStep]] = !up[cards-solution[currentStep]];
    currentStep++;
  }

  pmousePressed = mousePressed;
}

void printSolution() {
  println("Solution:");
  println("---------");
  boolean[] bits = new boolean[cards];
  for (int i = 0; i < solution.length; i++) {
    if (i > 0) {
      print("    ");
      for (int j = 0; j < cards-solution[i-1]; j++) {
        print(" ");
      }
      println("|");
    }
    print(nf(i+1, str(solution.length).length(), 0) + ": ");
    for (int j = 0; j < cards; j++) {
      if (bits[j]) {
        print(1);
      } else {
        print(0);
      }
    }
    bits[cards-solution[i]] = !bits[cards-solution[i]];
    println();
  }
  println("---------");
}

// Solution: Sets array of steps 'solution' to a binary tree pattern. For 4 cards, solution will look like this: {1, 2, 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 1, 2, 1}
void createSolution(int depth, int position, int difference) { 
  

  if (depth < 1) {
    return;
  }  
  solution[position] = depth;

  createSolution(depth-1, position-difference, difference/2);
  createSolution(depth-1, position+difference, difference/2);
}
