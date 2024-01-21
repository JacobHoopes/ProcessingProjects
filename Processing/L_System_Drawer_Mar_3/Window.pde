
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
  
  String production /* the value that is replaced */, replacement; /* the value that replaces */
  
    
  @Override
    public void exitActual() {
  }
  
  Window(PApplet Parent, String P, int Nth) {
    super();
    parent = Parent;
    production = P;
    name = "Production rule for " + production;
    nth = Nth;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    //firstMousePress = false;
  }
  
  public void settings() {
    size(displayWidth/4, (int) (displayHeight/2 - titleHeight * 1.5));
    //registerMethod("pre", this);
    
    w = width;
    h = height;
    
    xmin = 0;
    xmax = w;
    ymin = 0;
    ymax = h;
    lims = new IntList();
    lims.append(xmin);
    lims.append(xmax);
    lims.append(ymin);
    lims.append(ymax);
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
      ymax = h;
      
      lims.append(xmin);
      lims.append(xmax);
      lims.append(ymin);
      lims.append(ymax);
      
      adjustSystem(subNodes, lims);
      
      
    }
    
    background(40);
    noStroke();
    
    textAlign(LEFT, TOP);
    if (mousePressed) {
      fill(0, 240, 0);
      ellipse(mouseX, mouseY, CSize, CSize);
      fill(255);
      text("Mouse pressed on " + name, 30, 30);
    } else {
      fill(255);
      ellipse(width/2, height/2, CSize, CSize);
    }
    
    if (parent.mousePressed) {
      fill(255);
      text("Mouse pressed on Main at " + parent.mouseX + ", " + parent.mouseY, 30, 30);
      fill(240, 0, 0);
      ellipse(map(parent.mouseX, 0, parent.width, 0, width), 
      map(parent.mouseY, 0, parent.height, 0, height), CSize, CSize);
    }
    fill(255);
    rect(0, height - titleHeight, width, titleHeight);
    textAlign(LEFT, TOP);
    textSize(15);
    fill(0);
    //stre(
    text(production + " : " + replacement, 10, height - titleHeight + 3);
    
    drawSystem(subNodes);
    
    for (Node n : subNodes) {
      n.setFirstMousePress(false);
    }
    replacement = str(subNodes.size());
  }
  
  
  public void mousePressed() {
    //print("pressed on " + name);
    boolean overAny = false;
    // This loop places the grabbed circle at the end of the array, making it the last rendered,
    // as well as the circle on the top of all the others (it can be dragged above the others)
    for (Node n : subNodes) {
      if (n.over) {
        subNodes.add(new Node(n.x, n.y, n.r, subNodes.size()-1, subNodes, this, lims));
        subNodes.remove(n);
        overAny = true;
        break;
      }
    }
    for (int i = 0; i < subNodes.size(); i++) {
      subNodes.get(i).position = i;
    }
    if (!overAny) {
      subNodes.add(new Node(mouseX, mouseY, r, subNodes.size(), subNodes, this, lims));
    }
    
    for (Node n : subNodes) {
      n.setFirstMousePress(true);
    }
  }
  
  public void mouseDragged() {
    //print(" | dragging on " + name);
  }
  
  public void mouseReleased() {
    for (Node n : subNodes) {
      n.releaseEvent();
    }
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
