
// First, defining some variables for the appearance of the main window
int rH = 70; // The height of the bottom rectangles
int LW = 200; // The width of the Left rectangle
int RW = 120; // The width of the Right rectange
int sep = 5; // The seperation of the buttons
int edge = 10; // The distance from the edge of the screen to the boxes
float bC = 100; // The base color of the buttons
int r = 10; // radius of the nodes

int w, h; // variables to keep track of the width and height of the window for resizing purposes

Triangle LT, RT;

int xmin, xmax, ymin, ymax;
IntList lims;

float CSize = 40;


// True if a mouse button has just been pressed while no other button was.
boolean firstMousePress = false;

// Initializing some values for the L-system
LSystem LS;
int gens = 5;

ArrayList<Node> nodes = new ArrayList<Node>();
boolean overCircle = false;

// Initializing some values for the multiple windows
ArrayList<Window> subWindows = new ArrayList<Window>();

void settings() {
  size(displayWidth/2, displayHeight);
  for (int i = 0; i < 4; i++) {
    subWindows.add(new Window(this, "child"+str(i), i));
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
}

void setup() { 
  //surface.hideCursor();
  surface.setResizable(true);
  surface.setTitle("Main Window");
  surface.setLocation(0, 0);
  LS = new LSystem();
  for (Window w : subWindows) {
    w.setup();
  }
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
  fill(100);
  rect(edge, height-rH-edge, LW, rH);
  
  // Expanded L-System Box
  fill(150);
  rect(LW + sep + edge, height-rH-edge, width - (LW + RW + sep * 2 + edge * 2), rH);
  
  // Iterations Box
  fill(220);
  rect(width - RW - edge, height - rH - edge, RW, rH);
  
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(0);
  text("Generations", width - edge - RW/2, height - edge - rH + 12);
  text(str(gens), width - edge - RW/2, height - edge - rH/2 + 6);
  
  fill(0);
  
  LT = new Triangle(width - edge - RW/2 - 40, height - edge - rH/2 + 10, 
            width - edge - RW/2 - 15, height - edge - rH/2 - 5,
            width - edge - RW/2 - 15, height - edge - rH/2 + 25, this);
  
  RT = new Triangle(width - edge - RW/2 + 40, height - edge - rH/2 + 10, 
            width - edge - RW/2 + 15, height - edge - rH/2 - 5,
            width - edge - RW/2 + 15, height - edge - rH/2 + 25, this);
  
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
  //for (Window w : subWindows) {
  //  w.mousePressed();
  //}
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

    
//    //pushMatrix();
//    //LS.simulate(iters);
//    //popMatrix();
    
    
