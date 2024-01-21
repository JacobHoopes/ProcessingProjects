
class Window extends PApplet {
  PApplet parent;
  String name;
  int nth;
  int titleHeight = 27;
  ArrayList<Node> subNodes = new ArrayList<Node>();
  boolean overCircle = false;
  boolean firstMousePress = false;
  float CSize = 40;
  
  int xmin, xmax, ymin, ymax;
  IntList lims;
  
  int w, h;
  
  Triangle StartTriangle;
  float startX, startY;
  
  int stW = 40; // The width of the start triangle
  int stH = 20; // The height of the start triangle
  
  float vicinity = 20;
  
  String production; // the value that is replaced
  String replacement = ""; // the value that replaces 
  
  ArrayList<Node> visibleNodes = new ArrayList<Node>();
    
  @Override
    public void exitActual() {
  }
  
  Window(PApplet Parent, String P, int Nth) {
    super();
    parent = Parent;
    production = P;
    //replacement = production;
    name = "Production rule for " + production;
    nth = Nth;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
  
  public void settings() {
    size(displayWidth/4, (int) (displayHeight/2 - titleHeight * 1.5));
    
    w = width;
    h = height;
    
    lims = new IntList();
    
    xmin = 0;
    xmax = w;
    ymin = 0;
    ymax = h - titleHeight;
    
    lims.append(xmin);
    lims.append(xmax);
    lims.append(ymin);
    lims.append(ymax);
    
                
    startX = w/2;
    startY = h/2;
    StartTriangle = new Triangle(startX, startY, startX + stW/2, startY + stH, startX - stW/2, startY + stH, this, lims);
    StartTriangle.setMovable(true);
    Node StartNode = new Node(startX, startY, this, false, subNodes, lims, 0);
    subNodes.add(StartNode);
    StartTriangle.setChild(StartNode);
  }
  
  public void setup() {
    
    surface.setResizable(true);
    surface.setTitle(name);
    surface.setLocation(displayWidth/2 + displayWidth/4 * (nth % 2), (int) (displayHeight/2 + titleHeight * 0.5) * (nth / 2));
    
    //if (getGraphics().isGL()) {
    //  final com.jogamp.newt.Window w = (com.jogamp.newt.Window) getSurface().getNative();
    //  w.setDefaultCloseOperation(WindowClosingMode.DISPOSE_ON_CLOSE);
    //}
  }
  
  public void draw() {
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
      ymax = h - titleHeight;
      
      lims.append(xmin);
      lims.append(xmax);
      lims.append(ymin);
      lims.append(ymax);
      
      adjustSystem(subNodes, lims);
      
      
      StartTriangle.adjust(lims);
    }
    
    background(40);
    fill(255);
    rect(0, height - titleHeight, width, titleHeight);
    textAlign(LEFT, TOP);
    textSize(15);
    fill(0);
    text(production + " : " + replacement, 10, height - titleHeight + 3);
    
  
    StartTriangle.update();
    StartTriangle.display();
    StartTriangle.setFirstMousePress(false);
    
    startX = StartTriangle.x1;
    startY = StartTriangle.y1;
    
    fill(0, 0, 255);
    if (distance(mouseX, mouseY, startX, startY) < d/2) {
      fill(255, 0, 0);
    }
    //circle(startX, startY, d);
    
  
    boolean overAny = false;
    for (Node n : subNodes) {
      if (n.over) {
        overAny = true;
        break;
      }
    }
    //if (overAny) { // this double for-loop might be able to be compressed if the right conditions hold for the Node class
    for (Node n : subNodes) {
      n.setVisibility(true);
      if ((n.over && overAny) || (distance(mouseX, mouseY, n.x, n.y) < 50 && !overAny) || n.locked) {
        n.setVisibility(true);
      } else {
        if (!n.prodNode) {
          n.setVisibility(false);
        }
      }
    }
    //} else {
    //  for (Node n : subNodes) {
    //    if (distance(mouseX, mouseY, n.x, n.y) < 50) {
    //      n.setVisibility(true);
    //    } else {
    //      n.setVisibility(false);
    //    }
    //  }
    //}
    
    drawSystem(subNodes);
    
    for (Node n : subNodes) {
      n.setFirstMousePress(false);
      if (n.press && keyPressed) {
        n.rotate(3);
      }
    }
    replacement = generateSystem(StartTriangle.child); // Need to update replacement here to reflect what's going on in the window
  }
  
  
  public void mousePressed() {
    //print("pressed on " + name);
    boolean overAny = false;
    // This loop places the grabbed circle at the end of the array, making it the last rendered,
    // as well as the circle on the top of all the others (it can be dragged above the others)
    for (Node n : subNodes) {
      if (n.over) {
        float rot = degrees(n.theta);
        subNodes.add(new Node(n.x, n.y, this, n.prodNode, subNodes, lims, rot));
        subNodes.remove(n);
        overAny = true;
        
        break;
      }
    }
    if (StartTriangle.over) {
      overAny = true;
    }
    
    for (int i = 0; i < subNodes.size(); i++) {
      subNodes.get(i).position = i;
    }
    
    if (!overAny) {
      boolean prodNode = false;
      if (keyPressed) {
        prodNode = true;
      }
      subNodes.add(new Node(mouseX, mouseY, this, prodNode, subNodes, lims, 0));
    }
    
    for (Node n : subNodes) {
      n.setFirstMousePress(true);
    }
    
    
    
    StartTriangle.setFirstMousePress(true);
  }
  
  
  public void mouseDragged() {
    //print(" | dragging on " + name);
  }
  
  public void mouseReleased() {
    for (Node n : subNodes) {
      n.releaseEvent();
    }
    StartTriangle.releaseEvent();  
  }
  
  public String getReplacement() {
    return replacement;
  }
  
  public void close() {
    this.exitActual();
    //this.dispose();
    surface.setVisible(false);
  }
}
