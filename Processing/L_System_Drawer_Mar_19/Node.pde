// Node class describes a modifiable point in a window
class Node {
  float x, y;
  boolean over;
  boolean press;
  boolean locked = false;
  int col = 100;
  float theta = 0;
  float d = 20;
  float r = d/2;
  
  Node before;
  ArrayList<Node> after;
  PApplet w;
  //ArrayList<Node> allNodes; // All the nodes in the window
  
  Triangle Tparent;
  Node optionParent; // arbiter? adjudicator? judge?
  ArrayList<Node> options;
  Node plus, minus;
  
  boolean firstMousePress = false;
  IntList lims; // limits for nodes etc that can move around on the screen
  
  String nodeType; // possible values are "rotation", "production", "forward", "start", and "option"
  
  float v = r + 10; // vicinity -> used to note how far away the mouse can go from the center of a node before deactivating the node
  boolean nearby;
  boolean activated;
  
  float leastX = r;
  float mostX = r;
  float leastY = r;
  float mostY = r;
  
  ArrayList<String> WindowProds;
  ArrayList<String> OGWindowProds;
  String t = " "; // The text that is in the center of the node. Only used for option and production nodes
  
  // This first constructor makes a special node without a before node. This node is tied to the StartTriangle 
  Node(float ix, float iy, float rotation, String Ntype, Triangle T, PApplet W, IntList limits) { // Only used once to initialize a window's tree of nodes
    w = W;
    nodeType = Ntype;
    lims = limits;
    x = ix;
    y = iy;
    theta = radians(rotation) % (2*PI);
    before = this;
    Tparent = T;
    
    OGWindowProds = Tparent.WindowProds;
    //print(" | these are OG: " + OGWindowProds);
    WindowProds = OGWindowProds;
    
    after = new ArrayList<Node>();
    options = new ArrayList<Node>(); // The option nodes that are children to either a main node or another option node
    Node plus = new Node(x + 2*r + 5, y, 0, "option", "+", this, w, lims);
    options.add(plus);
    Node rLeft = new Node(x + r + 3, y + 2*r + 3, 0, "option", "<-", this, w, lims);
    options.add(rLeft);
    Node rRight = new Node(x - r - 3, y + 2*r + 3, 0, "option", "->", this, w, lims);
    options.add(rRight);
    Node forward = new Node(x, y - 2*r - 5, 0, "option", "F", this, w, lims);
    options.add(forward);
    
  }
  
  Node(float ix, float iy, float rotation, String Ntype, String text, Node b, PApplet W, IntList limits) {
    w = W;
    nodeType = Ntype;
    lims = limits;
    x = ix;
    y = iy;
    theta = radians(rotation) % (2*PI);
    t = text;
    //t = w.production;
    print("CREATION");
    if (nodeType != "option") {
      before = b;
      OGWindowProds = before.OGWindowProds;
      WindowProds = before.WindowProds;
      //allNodes = b.allNodes; // Each node is responsible for adding its subsequent nodes to this growing array, but each subsequent node is responsible for removing itself if deleted
    } else {
      optionParent = b;
      OGWindowProds = optionParent.OGWindowProds;
      WindowProds = optionParent.WindowProds;
      
      //allNodes = b.allNodes;
    }
    //d = b.d * 0.99;
    d = b.d;
    if (nodeType != "option") {
      after = new ArrayList<Node>();
    }
    options = new ArrayList<Node>(); // The option nodes that are children to either a main node or another option node
    
    if (nodeType == "rotation") {
      leastX = max(r, -r*pow(2,0.5)*cos(theta+PI/2));
      mostX = max(r, r*pow(2,0.5)*cos(theta+PI/2));
      leastY = max(r, r*pow(2,0.5)*sin(theta+PI/2));
      mostY = max(r, -r*pow(2,0.5)*sin(theta+PI/2));
    }
    
    if (nodeType != "option") {
      Node minus = new Node(x - 2*r - 5, y, 0, "option", "-", this, w, lims);
      options.add(minus);
      Node plus = new Node(x + 2*r + 5, y, 0, "option", "+", this, w, lims);
      options.add(plus);
      Node rLeft = new Node(x + r + 3, y + 2*r + 3, 0, "option", "<-", this, w, lims);
      options.add(rLeft);
      Node rRight = new Node(x - r - 3, y + 2*r + 3, 0, "option", "->", this, w, lims);
      options.add(rRight);
      Node forward = new Node(x, y - 2*r - 5, 0, "option", "F", this, w, lims);
      options.add(forward);
    }
    
    //print(t);
    if (nodeType == "option" && t == "+") {
      //print("something");
      for (int i = 0; i < WindowProds.size(); i++) {
        options.add(new Node(x + 2*r*(i+1) + 5, y, 0, "option", WindowProds.get(i), this, w, lims));
        //options.get(i).setText(WindowProds.get(i));
      }
    }
  }
  
  void update() {
    //print("wprods: " + WindowProds);
    fixWindowProds();
    //print("nwprods: " + WindowProds);
    
    overEvent();
    pressEvent();
    nearbyEvent();
    
    if ((over && !beforeActivated() && !afterActivated())/* || (options.size() != 0 && nodeType == "option" && optionParent.activated)*/) {
      activated = true;
    }
    
    if (nodeType == "option" && over) {
      activated = true;
    }
    
    if (nodeType == "option" && optionParent.nodeType == "option" && optionParent.activated) {
      activated = true;
    }

    if (nodeType == "rotation") {
      leastX = max(r, -r*pow(2,0.5)*cos(theta+PI/2));
      mostX = max(r, r*pow(2,0.5)*cos(theta+PI/2));
      leastY = max(r, r*pow(2,0.5)*sin(theta+PI/2));
      mostY = max(r, -r*pow(2,0.5)*sin(theta+PI/2));
    }
    
    for (Node o : options) {
      o.update();
    }
    
    if (activated && options.size() != 0) { // A node will no longer be activated if the mouse is outside of its vicinity or the vicinity of any of its active options
      //print("active");
      boolean Near = false;
      for (Node o : options) {
        if (o.nearby) {
          Near = true;
          break;
        }
      }
      
      if (!nearby && !Near && !childNearby()) {
        activated = false;
      }
    }
    
    if (nodeType != "option") {
      for (Node a : after) {
        a.update();
      }
    }
  }
  
  boolean isOver() {
    boolean Over = (overCircle(x, y, r, w));
    if (nodeType == "rotation") {
      Over = (overQuad(x, y, x-r*sin(theta+PI/4), y-r*cos(theta+PI/4), 
        x+r*pow(2,0.5)*cos(theta+PI/2), y-r*pow(2,0.5)*sin(theta+PI/2), 
        x+r*cos(theta+PI/4), y-r*sin(theta+PI/4), w) || (overCircle(x, y, r, w)));
    } /*else if (nodeType == "forward") {
      Over = 
    }*/
    return Over;
  }
  
  boolean overAfter() {
    if (nodeType != "option") {
      for (Node a : after) {
        if (a.overAfter() || a.isOver()) {
          return true;
        }
      }
    }
    return false;
  }
  
  boolean overBefore() {
    if (over) {
      return true;
    } else if (nodeType == "start") {
      return false;
    } else if (nodeType != "option") {
      return before.overBefore();
    } else {
      return optionParent.overBefore();
    }
  }
  
  boolean afterActivated() {
    if (nodeType != "option") {
      for (Node a : after) {
        if (a.activated || a.afterActivated()) {
          return true;
        }
      }
    }
    return false;
  }
  
  boolean beforeActivated() {
    if (activated) {
      return true;
    } else if (nodeType == "start") {
      return false;
    } else if (nodeType != "option") {
      return before.beforeActivated();
    } else {
      return optionParent.beforeActivated();
    }
  }
  
  boolean anotherActivated() { // need to account for the case where two nodes on two different branches are both activated
    return false;
  }
  
  void activatedFalse() {
    activated = false;
    for (Node o : options) {
      o.activatedFalse();
    }
    if (nodeType != "option") {
      for (Node a : after) {
        a.activatedFalse();
      }
    }
  }
    
  
  void overEvent() {
    if (isOver()/* && nodeType == "option"*/) {
      over = true;
    } else {
      over = false;
    }
  }
  
  void nearbyEvent() {
    if (distance(w.mouseX, w.mouseY, x, y) > v) {
      nearby = false;
    } else {
      nearby = true;
    }
  }
  
  void setFirstMousePress(boolean p) {
    firstMousePress = p;
    for (Node o : options) {
      o.setFirstMousePress(p);
    }
    if (nodeType != "option") {
      for (Node a : after) {
        a.setFirstMousePress(p);
      }
    }
  }
  
  void pressEvent() {
    press = false;
    if (options.size() == 0 && over && firstMousePress) {
      press = true;
      locked = true;
    }
  }
  
  void releaseEvent() {
    //if (locked) {
    //  activated = false;
    //}
    locked = false;
    for (Node o : options) {
      o.releaseEvent();
    }
    if (nodeType != "option") {
      for (Node a : after) {
        a.releaseEvent();
      }
    }
    //activated = false;
  }
  
  void move(float Dx, float Dy) {
    x = x + Dx;
    y = y + Dy;
    for (Node o : options) {
      o.move(Dx, Dy);
    }
    if (nodeType != "option") {
      for (Node a : after) {
        a.move(Dx, Dy);
      }
    }
  }
  
  int getPlusIndex() {
    for (int i = 0; i < options.size(); i++) {
      if (options.get(i).t == "+") {
        return i;
      }
    }
    return -1;
  }
  
  void fixWindowProds() {
    //print(WindowProds);
    if (nodeType == "option") {
      WindowProds = optionParent.WindowProds;
    } else {
      //print("INCONSISTENCY");
      ArrayList<String> newWindowProds;
      if (nodeType == "start") {
        newWindowProds = Tparent.WindowProds;
      } else {
        newWindowProds = before.WindowProds;
      }
      //if (WindowProds != newWindowProds) {
      //print(" |  WindowProds: " + WindowProds + ", and newWindowProds: " + newWindowProds);
      //}
      Node plusNode = options.get(getPlusIndex());
      //print(newWindowProds);
      if (WindowProds.size() > newWindowProds.size()) { // An option node needs to be removed
        print("something must go");
        for (int i = 0; i < newWindowProds.size(); i++) { // to determine which option node should be removed
          if (WindowProds.get(i) != newWindowProds.get(i)) {
            print("removing " + i + "th node ");
            plusNode.options.get(i).removeOption(); // remove the node that is no longer represented in the WindowProds array
            WindowProds = newWindowProds;
            break;
          }
        }
      } else if (WindowProds.size() < newWindowProds.size()) { // an option node needs to be added
        print("something must be added");
        for (int i = 0; i < WindowProds.size(); i++) {
          if (newWindowProds.get(i) != WindowProds.get(i)) {
            String newProd = before.options.get(getPlusIndex()).options.get(i).t;
            options.get(getPlusIndex()).options.add(i, new Node(x + 2*r*(i+1) + 5, y, 0, "option", newProd, this, w, lims));
            WindowProds = newWindowProds;
            break;
          }
        }
      }
      //print(options.get(getPlusIndex()).options.size());
      //print("hmm");
      //WindowProds = newWindowProds;
    }
  }
  
  
  void setText(String T) {
    t = T;
  }
  
  void rotate(float T) {
    theta += radians(T) % (2*PI);
  }
  
  void setTheta(float T) {
    theta = radians(T) % (2*PI);
  }
  
  String generateSystem() {
    String replacement = "";
    if (nodeType == "rotation") {
      if (t == "R+") {
        replacement = "+";
      } else if (t == "R-") {
        replacement = "-";
      }
      //replacement = "±";
    } else if (nodeType == "production") {
      replacement = t;
    } else if (nodeType == "forward") {
      replacement = "F";
    } else {
      //print("GENERATOR MELTDOWN");
    }
    
    for (Node a : after) {
      replacement += a.generateSystem();
      if (nodeType == "start") {
      }
    }
    return replacement;
  }
  
  boolean childNearby() {
    if (options.size() == 0) {
      return nearby;
    }
    for (Node o : options) {
      if (o.childNearby()) {
        return true;
      }
    }
    return false;
  }
  
  void adjust(IntList newLims) {
    lims = newLims;
    if (x > lims.get(1) - r) {
      x = lims.get(1) - r;
    }
    if (y > lims.get(3) - r) {
      y = lims.get(3) - r;
    }
  }
  
  void removeOption() {
    int index = optionParent.options.indexOf(this);
    ArrayList<Node> temp = new ArrayList<Node>();
    for (int i = 0; i < optionParent.options.size(); i++) {
      if (i != index) {
        temp.add(optionParent.options.get(i));
      }
    }
    optionParent.options = temp;
  }
  
  void removeNode() {
    int index = before.after.indexOf(this);
    ArrayList<Node> temp = new ArrayList<Node>();
    for (int i = 0; i < before.after.size(); i++) {
      if (i != index) {
        temp.add(before.after.get(i));
      }
    }
    before.after = temp;
  }
  
  void createNode(String t) {
    //print(OGWindowProds);
    if (WindowProds.indexOf(t) != -1) { 
      print(t + " is in the list. ");
      optionParent.after.add(new Node(optionParent.x - 10, optionParent.y, 0, "production", t, optionParent, w, lims));
    } else if (t == "F") {
      after.add(new Node(x, y, 0, "forward", "", this, w, lims));
    } else if (t == "<-") {
      after.add(new Node(x, y, -PI/2, "rotation", "R-", this, w, lims));
    } else if (t == "->") {
      after.add(new Node(x, y, PI/2, "rotation", "R+", this, w, lims));
    }
    //print("this is t: " + t);
  }
  
  void drawNode(int fill) {
    // This part draws & fills in the shape of the node
    if (nodeType != "forward") {
      w.fill(fill);
      w.stroke(0);
      w.strokeWeight(1);
      w.circle(x, y, d);
      //w.fill(0);
      //w.arc(x, y, 2*r, 2*r, theta+PI/4 + PI/2, theta+PI/4 - PI/2);
    } else {
      w.stroke(0, 0, 255);
      w.strokeWeight(4);
      w.line(x, y, x + 100*cos(theta - PI/2), y + 100*sin(theta - PI/2));
      //w.line(optionParent.x, optionParent.y, optionParent.x+100, optionParent.y-100);
    }
    
    if (nodeType == "rotation") {
      w.noStroke();
      w.quad(x, y, x-r*sin(theta+PI/4), y-r*cos(theta+PI/4), 
      x+r*pow(2,0.5)*cos(theta+PI/2), y-r*pow(2,0.5)*sin(theta+PI/2), 
      x+r*cos(theta+PI/4), y-r*sin(theta+PI/4));
      w.stroke(0);
      w.strokeWeight(1);
      w.line(x-r*sin(theta+PI/4), y-r*cos(theta+PI/4), 
      x+r*pow(2,0.5)*cos(theta+PI/2), y-r*pow(2,0.5)*sin(theta+PI/2));
      w.line(x+r*pow(2,0.5)*cos(theta+PI/2), y-r*pow(2,0.5)*sin(theta+PI/2), 
      x+r*cos(theta+PI/4), y-r*sin(theta+PI/4));
    }
    
    
    // This part adds the text in the middle of the node (if there is any)
    w.fill(0, 255, 0);
    w.textAlign(CENTER, CENTER);
    w.textSize(d-3);
    w.text(t, x, y-3);
  }
  
  void display() {
    
    // This section manages the coloring of each node
    int fill = col;
    if ((options.size() == 0 && over) || (options.size() > 0 && (activated /*|| over*/))) { // 
      fill = col + 50;
    }
    if (firstMousePress && over && options.size() == 0) {
      fill = 255;
      if (t == "-") {
        optionParent.removeNode();
      } else {
        optionParent.createNode(t);
      }
    }
    if (locked) {
      fill = 255;
    } 
    
    drawNode(fill);
    
    if (nodeType != "option") {
      for (Node a : after) {
        a.display();
      }
    }
    
    if (activated) {
      drawNode(fill);
      for (Node o : options) {
        o.update();
        o.display();
      }
    }
  }
}
