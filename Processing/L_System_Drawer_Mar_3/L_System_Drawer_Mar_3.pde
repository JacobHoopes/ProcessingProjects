
// First, defining some variables for the appearance of the main window
int rH; // The height of the bottom boxes
int RW = 120; // The width of the Right boxes
int sep = 5; // The seperation of the boxes
int edge = 10; // The distance from the edge of the screen to the boxes
int r = 10; // radius of the nodes

float CSize = 40; // Size of the central/mousetracking cursor

int w, h; // Variables to keep track of the width and height of the window for resizing purposes

boolean firstMousePress = false; // True if a mouse button has just been pressed while no other button was.

Triangle LT, RT; // The different arrow buttons for changing values

ArrayList<Rectangle> windowButtons = new ArrayList<Rectangle>(); // The buttons that can add or remove windows/production rules
int buttonSize = 16;


int gens = 5;

// The bounds for where new nodes can be placed or dragged to
int xmin, xmax, ymin, ymax;
IntList lims;


StringList Replacements; // A list of the replacement rules

ArrayList<Window> subWindows = new ArrayList<Window>(); // The windows that control the different production rules
int maxSubWindows = 4;

//IntList wIandPN; // Initializing a short intlist that keeps track of some values for the main window's production display
int minProdNum;


ArrayList<Node> nodes = new ArrayList<Node>();


String[] L = {"A", "B", "C", "D", "E", "F"};



void settings() {
  size(displayWidth/2, displayHeight);
  //StringList Letters = new StringList();
  //for (int i = 0; i < 4
  //Array.asList("A", "B", "C", "D");
  
  for (int i = 0; i < maxSubWindows; i++) {
    subWindows.add(new Window(this, L[i], i));
    String s = "-";
    if (i == 0) {
      s = "+";
    }
    windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, s, this));
  }
  for (Window w : subWindows) {
    w.settings();
  }
  registerMethod("pre", this);
  
  w = width;
  h = height;
  
  xmin = 0;
  xmax = w;
  ymin = 0;
  ymax = h - rH - edge;
  
  lims = new IntList();
  lims.append(xmin);
  lims.append(xmax);
  lims.append(ymin);
  lims.append(ymax);
  
  Replacements = new StringList();
}

void setup() { 
  //surface.hideCursor();
  surface.setResizable(true);
  surface.setTitle("Main Window");
  surface.setLocation(0, 0);
  for (Window w : subWindows) {
    w.setup();
  }
  Replacements.append("test");
}

void pre() {
  if (w != width || h != height) {
    // Sketch window has resized
    w = width;
    h = height;
    while (lims.size() > 0) {
      lims.remove(0);
    }
    xmin = 0;
    xmax = w;
    ymin = 0;
    ymax = h - rH - edge;
    
    lims.append(xmin);
    lims.append(xmax);
    lims.append(ymin);
    lims.append(ymax);
    
    adjustSystem(nodes, lims);

  }
}

void draw() {
  background(40);
  noStroke();
  
  textAlign(LEFT, TOP);
  if (mousePressed) {
    fill(255);
    text("Mouse pressed on Main.", 40, 40);
    fill(0, 240, 0);
    ellipse(mouseX, mouseY, CSize, CSize);
  } else {
    fill(255);
    ellipse(width/2, height/2, CSize, CSize);
  }
  for (Window w : subWindows) {
    if (w.mousePressed) {
      fill(200);
      text("Mouse pressed on " + w.name + " at " + w.mouseX + ", " + w.mouseY, 40, 40);
      fill (240, 0, 0);
      ellipse(map(w.mouseX, 0, w.width, 0, width), 
      map(w.mouseY, 0, w.height, 0, height), CSize, CSize);
    }
  }
  
  stroke(255);
  // Axiom, Productions, and Angle Box
  //fill(100);
  //rect(edge, height-rH-edge, LW, rH);
  
  // Productions Box
  Replacements.clear();
  for (Window w : subWindows) {
    Replacements.append(w.getReplacement());
  }
  fill(150);
  rH = Replacements.size() * 20;
  rect(sep + edge, height - rH - edge, width - (RW + sep * 2 + edge * 2), rH);
  minProdNum = 0;
  //wIandPN = new IntList();
  // This gets the production rules from each of the active windows and puts them into the text box in the main window
  for (int i = 0; i < Replacements.size(); i++) {
    float currentW = sep + edge + 4;
    float currentH = height - rH - edge + 20*i - 3;
    fill(255);
    textAlign(LEFT,TOP);
    textSize(20);
    
    //int val;
    //val = prodNum(minProdNum)[0];
    //ArrayList<int> 
    
    //print(val, minProdNum);
    //for (int j = 0; j < subWindows.size(); j++) {
    //  if (subWindows.get(
    //int wIndex = getwIndex(maxSubWindows, subWindows); // window index (also updates minProdNum)
    //print(wIndex);
    //print(wIandPN);
    
    //outer:
    //for (int j = minProdNum; j < maxSubWindows; j++) {
    //  for (int k = 0; k < subWindows.size(); k++) {
    //    if (subWindows.get(k).nth == j) {
    //      minProdNum = j + 1;
    //      wIndex = k;
    //      break outer;
    //    }
    //  }
    //}
    
    
    
    text(subWindows.get(i).production + " : " + Replacements.get(i), currentW, currentH);
    
    //text(Productions.get(prodNum(minProdNum, maxSubWindows, subWindows)), currentW, currentH);
    
    float step = rH / windowButtons.size();
    windowButtons.get(windowButtons.size() - 1 - i).x = width - RW - sep - 18 - edge;
    windowButtons.get(windowButtons.size() - 1 - i).y = height - edge - step*i - buttonSize - 2;
    
    // This places buttons that can remove (or add) production rules and their corresponding windows
    windowButtons.get(i).update();
    windowButtons.get(i).display();
  }
  
  // Generations Box
  fill(220);
  int newrH = 80;
  rect(width - RW - edge, height - newrH - edge, RW, newrH);
  
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(0);
  text("Generations", width - edge - RW/2, height - edge - newrH + 12);
  text(str(gens), width - edge - RW/2, height - edge - newrH/2 + 6);
  
  fill(0);
  
  LT = new Triangle(width - edge - RW/2 - 40, height - edge - newrH/2 + 10, 
            width - edge - RW/2 - 15, height - edge - newrH/2 - 5,
            width - edge - RW/2 - 15, height - edge - newrH/2 + 25, this);
  
  RT = new Triangle(width - edge - RW/2 + 40, height - edge - newrH/2 + 10, 
            width - edge - RW/2 + 15, height - edge - newrH/2 - 5,
            width - edge - RW/2 + 15, height - edge - newrH/2 + 25, this);
  
  LT.update();
  LT.display();
  LT.setFirstMousePress(false);
  
  RT.update();
  RT.display();
  RT.setFirstMousePress(false);
  
  drawSystem(nodes);
  for (Node n : nodes) {
    n.setFirstMousePress(false);
  }
}

void mousePressed() {
  boolean overAny = false;
  // This loop places the grabbed circle at the end of the array, making it the last rendered,
  // as well as the circle on the top of all the others (it can be dragged above the others)
  for (Node n : nodes) {
    if (n.over) {
      nodes.add(new Node(n.x, n.y, n.r, nodes.size()-1, nodes, this, lims));
      nodes.remove(n);
      overAny = true;
      break;
    }
  }
  if (mouseY > height - rH - edge) {
    overAny = true;
  }
  for (int i = 0; i < nodes.size(); i++) {
    nodes.get(i).position = i;
  }
  if (!overAny) {
    nodes.add(new Node(mouseX, mouseY, r, nodes.size(), nodes, this, lims));
  }
  
  for (int i = 0; i < windowButtons.size(); i++) {
    if (windowButtons.get(i).over) {
      if (windowButtons.get(i).s == "-") {
        windowButtons.remove(windowButtons.get(i));
        subWindows.get(i).close();
        subWindows.remove(subWindows.get(i));
      } else {
        addNewWindow();
      }
    }
  }
  
  
  if (LT.over) {
    gens--;
    if (gens < 0) {
      gens = 0;
    }
  }
  if (RT.over) {
    gens++;
  }
  LT.setFirstMousePress(true);
  RT.setFirstMousePress(true);
  
  for (Node n : nodes) {
    n.setFirstMousePress(true);
  }
  
}

void mouseDragged() {
  
}

void mouseReleased() {
  for (Node n : nodes) {
    n.releaseEvent();
  }
}

void addNewWindow() {
  for (int i = 0; i < maxSubWindows; i++) {
    boolean inList = false;
    for (int j = 0; j < subWindows.size(); j++) {
      if (subWindows.get(j).nth == i) {
        inList = true;
        break;
      }
    }
    if (!inList) {
      subWindows.add(i, new Window(this, L[i], i));
      windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, "-", this));
      break;
    }
  }
}

//int[] prodNum (int min /* min value the Windex could be */, int max /* similarly... */, ArrayList<Window> W ) { // Given the index of a production, determine the index of its paired Window in an array
