
// First, defining some variables for the appearance of the main window
int BH; // The height of the productions box
int RW = 120; // The width of the right box
int RH = 80; // The height of the right box
int sep = 5; // The seperation of the boxes
int edge = 10; // The distance from the edge of the screen to the boxes
int d = 15; // diameter of the nodes

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
IntList windowBounds;


StringList Replacements; // A list of the replacement rules

ArrayList<Window> subWindows = new ArrayList<Window>(); // The windows that control the different production rules
int maxSubWindows = 4;

//IntList wIandPN; // Initializing a short intlist that keeps track of some values for the main window's production display
int minProdNum;


ArrayList<Node> nodes = new ArrayList<Node>();


String[] L = {"A", "B", "C", "D", "E", "F"};

Triangle StartTriangle;
float startX, startY;
int stW = 40; // The width of the start triangle
int stH = 20; // The height of the start triangle

void settings() {
  size(displayWidth/2, displayHeight);
  
  for (int i = 0; i < maxSubWindows; i++) {
    subWindows.add(new Window(this, L[i], i));
    windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, "-", this));
  }
  windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, "+", this));
  
  for (Window w : subWindows) {
    w.settings();
  }
  registerMethod("pre", this);
  
  w = width;
  h = height;
  
  xmin = 0;
  xmax = w;
  ymin = 0;
  ymax = h - BH - edge;
  
  lims = new IntList();
  lims.append(xmin);
  lims.append(xmax);
  lims.append(ymin);
  lims.append(ymax);
  
  windowBounds = new IntList();
  windowBounds.append(0);
  windowBounds.append(w);
  windowBounds.append(0);
  windowBounds.append(h);
  
  LT = new Triangle(0, 0, 0, 0, 0, 0, this, windowBounds);
            
  RT = new Triangle(0, 0, 0, 0, 0, 0, this, windowBounds);
            
  startX = w/2;
  startY = h/2;
  StartTriangle = new Triangle(startX, startY, startX + stW/2, startY + stH, startX - stW/2, startY + stH, this, lims);
  StartTriangle.setMovable(true);
  
  
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
    //while (lims.size() > 0) {
    //  lims.remove(0);
    //}
    lims.clear();
    xmin = 0;
    xmax = w;
    ymin = 0;
    ymax = h - BH - edge;
    
    lims.append(xmin);
    lims.append(xmax);
    lims.append(ymin);
    lims.append(ymax);
    
    windowBounds.clear();
    windowBounds.append(0);
    windowBounds.append(w);
    windowBounds.append(0);
    windowBounds.append(h);
    
    adjustSystem(nodes, lims);
    
    LT.move(w - edge - RW/2 - 15, h - edge - RH/2 - 5,
            w - edge - RW/2 - 15, h - edge - RH/2 + 25,
            w - edge - RW/2 - 40, h - edge - RH/2 + 10);
            
    RT.move(w - edge - RW/2 + 15, h - edge - RH/2 - 5,
            w - edge - RW/2 + 40, h - edge - RH/2 + 10,
            w - edge - RW/2 + 15, h - edge - RH/2 + 25);
            
    StartTriangle.adjust(lims);
  }
}

void draw() {
  background(40);
  noStroke();
  
  textAlign(LEFT, TOP);
  //}
  
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
  BH = (Replacements.size() + 1) * 20;
  rect(sep + edge, height - BH - edge, width - (RW + sep * 2 + edge * 2), BH);
  minProdNum = 0;
  //wIandPN = new IntList();
  // This gets the production rules from each of the active windows and puts them into the text box in the main window
  for (int i = 0; i < Replacements.size() + 1; i++) {
    float currentW = sep + edge + 4;
    float currentH = height - BH - edge + 20*i - 3;
    fill(255);
    textAlign(LEFT,TOP);
    textSize(20);
    
    if (i != Replacements.size()) {
      text(subWindows.get(i).production + " : " + Replacements.get(i), currentW, currentH);
    }
    //text(Productions.get(prodNum(minProdNum, maxSubWindows, subWindows)), currentW, currentH);
    
    float step = BH / windowButtons.size();
    windowButtons.get(windowButtons.size() - 1 - i).x = width - RW - sep - 18 - edge;
    windowButtons.get(windowButtons.size() - 1 - i).y = height - edge - step*i - buttonSize - 2;
    
    // This places buttons that can remove (or add) production rules and their corresponding windows
    windowButtons.get(i).update();
    windowButtons.get(i).display();
  }
  
  // Generations Box
  fill(220);
  rect(width - RW - edge, height - RH - edge, RW, RH);
  
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(0);
  text("Generations", width - edge - RW/2, height - edge - RH + 12);
  text(str(gens), width - edge - RW/2, height - edge - RH/2 + 6);
  
  fill(200);
  
  
  LT.update();
  LT.display();
  LT.setFirstMousePress(false);
  
  RT.update();
  RT.display();
  RT.setFirstMousePress(false);
  
  StartTriangle.update();
  StartTriangle.display();
  StartTriangle.setFirstMousePress(false);
  
  drawSystem(nodes);
  //for (Node n : nodes) {
  //  n.setFirstMousePress(false);
  //}
}

void mousePressed() {
  //boolean overAny = false;
  //// This loop places the grabbed circle at the end of the array, making it the last rendered,
  //// as well as the circle on the top of all the others (it can be dragged above the others)
  //for (Node n : nodes) {
  //  if (n.over) {
  //    nodes.add(new Node(n.x, n.y, n.r, nodes.size()-1, nodes, this, lims));
  //    nodes.remove(n);
  //    overAny = true;
  //    break;
  //  }
  //}
  //if (mouseY > height - BH - edge) {
  //  overAny = true;
  //}
  //for (int i = 0; i < nodes.size(); i++) {
  //  nodes.get(i).position = i;
  //}
  //if (!overAny) {
  //  nodes.add(new Node(mouseX, mouseY, r, nodes.size(), nodes, this, lims));
  //}
  
  for (int i = windowButtons.size() - 1; i >= 0; i--) {
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
  
  StartTriangle.setFirstMousePress(true);
  
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
  
  //for (Node n : nodes) {
  //  n.setFirstMousePress(true);
  //}
  
}

void mouseDragged() {
  
}

void mouseReleased() {
  //for (Node n : nodes) {
  //  n.releaseEvent();
  //}
  LT.releaseEvent();
  RT.releaseEvent();
  StartTriangle.releaseEvent();
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
      windowButtons.add(windowButtons.size() - 1, new Rectangle(0, 0, buttonSize, buttonSize, "-", this));
      break;
    }
  }
}

//int[] prodNum (int min /* min value the Windex could be */, int max /* similarly... */, ArrayList<Window> W ) { // Given the index of a production, determine the index of its paired Window in an array
