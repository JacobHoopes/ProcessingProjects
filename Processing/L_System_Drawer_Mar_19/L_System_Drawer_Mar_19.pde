
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

String Productions; // A list of the productions that have a replacement rule
StringList Replacements; // A list of the replacement rules

ArrayList<Window> subWindows = new ArrayList<Window>(); // The windows that control the different production rules
int maxSubWindows = 4;
int initialWindows = 2;

String startVar;

//IntList wIandPN; // Initializing a short intlist that keeps track of some values for the main window's production display
int minProdNum;


ArrayList<Node> nodes = new ArrayList<Node>();


String[] L = {"A", "B", "C", "D", "E", "F"};
//ArrayList<String> M = new ArrayList<String>();
//M = {"A", "B", "C", "D", "E", "F"};

//Triangle StartTriangle;
//float startX, startY;
//int stW = 40; // The width of the start triangle
//int stH = 20; // The height of the start triangle


ArrayList<String> OGWindowProds = new ArrayList<String>(); // OG WindowProds
ArrayList<String> WindowProds = new ArrayList<String>(); // WindowProds

String LSystem;

void settings() {
  size(displayWidth/2, displayHeight);
  windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, "+", this));
  for (int i = 0; i < initialWindows; i++) {
    OGWindowProds.add(L[i]);
    windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, "-", this));
  }
  
  
  WindowProds = OGWindowProds;
  for (int i = 0; i < initialWindows; i++) {
    subWindows.add(new Window(this, L[i], i, OGWindowProds));
    subWindows.get(i).setWindowProds(WindowProds);
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
  
  LT = new Triangle(0, 0, 0, 0, 0, 0, this, windowBounds, OGWindowProds);
            
  RT = new Triangle(0, 0, 0, 0, 0, 0, this, windowBounds, OGWindowProds);
            
  //startX = w/2;
  //startY = h/2;
  //StartTriangle = new Triangle(startX, startY, startX + stW/2, startY + stH, startX - stW/2, startY + stH, this, lims, OGWindowProds);
  //StartTriangle.setMovable(true);
  //StartTriangle.setWindowProds(WindowProds);
  
  Replacements = new StringList();
}

void setup() { 
  //surface.hideCursor();
  surface.setResizable(true);
  surface.setTitle("Main Window");
  surface.setLocation(0, 0);
  //for (Window w : subWindows) {
  //  w.setup();
  //}
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
            
    //StartTriangle.adjust(lims);
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
  Productions = "";
  Replacements.clear();
  for (Window w : subWindows) {
    Productions += w.getProduction();
    Replacements.append(w.getReplacement());
    //print(" before: " + WindowProds.size());
    //w.setWindowProds(WindowProds);
    //print(" after: " + WindowProds.size());
  }
  //StartTriangle.setWindowProds(WindowProds);
  fill(150);
  int comboProdRows = 1;
  BH = (Replacements.size() + 1 /* this +1 is for the + button */ + comboProdRows /* the other is for the combined production */) * 20;
  rect(sep + edge, height - BH - edge, width - (RW + sep * 2 + edge * 2), BH);
  minProdNum = 0;
  //wIandPN = new IntList();
  
      
  if (subWindows.size() != 0) {
    startVar = subWindows.get(0).production;
  } else {
    startVar = "none";
  }
  
  LSystem = combineLSystem(startVar, Productions, Replacements, gens);
  
  // This gets the production rules from each of the active windows and puts them into the text box in the main window
  for (int i = 0; i < Replacements.size() + 1 + comboProdRows; i++) {
    float currentW = sep + edge + 4;
    float currentH = height - BH - edge + 20*i - 3;
    fill(255);
    textAlign(LEFT,TOP);
    textSize(20);

    
    if (i == 0) {
      text("Start Variable : " + startVar, currentW, currentH);
    } else if (i < Replacements.size() + 1) {
      text(subWindows.get(i-1).production + " : " + Replacements.get(i-1), currentW, currentH);
    } else {
      text("Combo Production: " + LSystem, currentW, currentH);
    }
    //text(Productions.get(prodNum(minProdNum, maxSubWindows, subWindows)), currentW, currentH);
    if (i < Replacements.size() + 1) {
      float step = (BH - comboProdRows*20) / windowButtons.size();
      windowButtons.get(windowButtons.size() - 1 - i).x = width - RW - sep - 18 - edge;
      windowButtons.get(windowButtons.size() - 1 - i).y = height - edge - step*i - buttonSize - 2 - comboProdRows * 20;
      
      // This places buttons that can remove (or add) production rules and their corresponding windows
      windowButtons.get(i).update();
      windowButtons.get(i).display();
    }
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
  
  //StartTriangle.setWindowProds(WindowProds);
  
  //StartTriangle.update();
  //StartTriangle.display();
  //StartTriangle.setFirstMousePress(false);
}

void mousePressed() {
  // remove window
  print(" old: " + WindowProds);
  for (int i = windowButtons.size() - 1; i >= 0; i--) {
    if (windowButtons.get(i).over) {
      if (windowButtons.get(i).s == "-") {
        windowButtons.remove(windowButtons.get(i));
        subWindows.get(i-1).close();
        subWindows.remove(subWindows.get(i-1));
        WindowProds.remove(WindowProds.get(i-1));
        
        
        //StartTriangle.setWindowProds(WindowProds);
      } else {
        addNewWindow();
        
      }
      //print(WindowProds);
    }
  }
  print(" new: " + WindowProds);
  
  for (Window w : subWindows) {
    print("first: " + w.WindowProds);
    w.setWindowProds(WindowProds);
    print("second: " + w.WindowProds);
  }
  //StartTriangle.setWindowProds(WindowProds);
  
  //StartTriangle.setFirstMousePress(true);
  
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
  //StartTriangle.releaseEvent();
}

ArrayList<String> getWindowProds() {
  return WindowProds;
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
      subWindows.add(i, new Window(this, L[i], i, OGWindowProds));
      subWindows.get(i).setWindowProds(WindowProds);
      windowButtons.add(new Rectangle(0, 0, buttonSize, buttonSize, "-", this));
      //print(" old: " + WindowProds);
      WindowProds.add(i, L[i]);
      //print(" new: " + WindowProds);
      break;
    }
  }
}

//int[] prodNum (int min /* min value the Windex could be */, int max /* similarly... */, ArrayList<Window> W ) { // Given the index of a production, determine the index of its paired Window in an array
