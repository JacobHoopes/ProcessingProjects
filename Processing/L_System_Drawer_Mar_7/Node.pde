// Node class describes a modifiable point in a window
class Node {
  float x, y;
  boolean over;
  boolean press;
  boolean locked = false;
  int position; // Ordering of nodes - which is on top?
  int col = 100;
  Node parent;
  PApplet w;
  boolean firstMousePress = false;
  IntList lims; // limits for nodes etc that can move around on the screen
  ArrayList<Node> children;
  boolean prodNode; // is this node a production node?
  boolean visible = true;
  float theta = 0;
  float r = d/2;
  ArrayList<Node> onScreen;
  float s = 1; //scale
  float vicinity = r + 20;
  
  float leastX = r;
  float mostX = r;
  float leastY = r;
  float mostY = r;
  
  Node(float ix, float iy, PApplet W, boolean productionNode, ArrayList<Node> a, IntList limits, float rotation/*, Node predecessor*/) {
    
    w = W;
    prodNode = productionNode;  
    lims = limits;
    x = lock(ix, lims.get(0) + r, lims.get(1) - r);
    y = lock(iy, lims.get(2) + r, lims.get(3) - r);
    onScreen = a;
    theta = radians(rotation) % (2*PI);
    // p = predecessor;
    
    if (prodNode) {
      leastX = max(r, -s*r*pow(2,0.5)*cos(theta+PI/2));
      mostX = max(r, s*r*pow(2,0.5)*cos(theta+PI/2));
      leastY = max(r, s*r*pow(2,0.5)*sin(theta+PI/2));
      mostY = max(r, -s*r*pow(2,0.5)*sin(theta+PI/2));
    }
  }
  
  void update() {
    overEvent();
    pressEvent();
    
    if (prodNode) {
      leastX = max(r, -s*r*pow(2,0.5)*cos(theta+PI/2));
      mostX = max(r, s*r*pow(2,0.5)*cos(theta+PI/2));
      leastY = max(r, s*r*pow(2,0.5)*sin(theta+PI/2));
      mostY = max(r, -s*r*pow(2,0.5)*sin(theta+PI/2));
    }
    
    if (press) {
      x = lock(w.mouseX, lims.get(0) + leastX, lims.get(1) - mostX);
      y = lock(w.mouseY, lims.get(2) + leastY, lims.get(3) - mostY);
    }
  }
  
  void overEvent() {
    int highestPosition = 0;
    for (Node n : onScreen) {
      if (overCircle(n.x, n.y, n.r, w) && n.position > highestPosition) {
        highestPosition = n.position;
      }
    }
    if ((overQuad(x, y, x-r*sin(theta+PI/4), y-r*cos(theta+PI/4), 
        x+s*r*pow(2,0.5)*cos(theta+PI/2), y-s*r*pow(2,0.5)*sin(theta+PI/2), 
        x+r*cos(theta+PI/4), y-r*sin(theta+PI/4), w) || (overCircle(x, y, r, w))) && highestPosition == position) {
      over = true;
    } else {
      over = false;
    }
  }
  
  void setFirstMousePress(boolean p) {
    firstMousePress = p;
  }
  
  void pressEvent() {
    if (over && firstMousePress || locked) {
      press = true;
      locked = true;
    } else {
      press = false;
    }
  }
  
  void releaseEvent() {
    locked = false;
  }
  
  void move(float Dx, float Dy) {
    x = x + Dx;
    y = y + Dy;
  }
  
  void rotate(float T) {
    theta += radians(T) % (2*PI);
  }
  
  void setTheta(float T) {
    theta = radians(T) % (2*PI);
  }
  
  void setVisibility(boolean V) {
    visible = V;
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
  
  
  void display() {
    if (visible) {
      w.fill(col);
      w.noStroke();
      if (over || press) {
        w.fill(col + 100);
      }
      if (prodNode) {
        w.quad(x, y, x-r*sin(theta+PI/4), y-r*cos(theta+PI/4), 
        x+s*r*pow(2,0.5)*cos(theta+PI/2), y-s*r*pow(2,0.5)*sin(theta+PI/2), 
        x+r*cos(theta+PI/4), y-r*sin(theta+PI/4));
      }
      w.circle(x, y, d);
      
      //if (over) {
      //  for (Node c : children) {
      //    c.display();
      //  }
      //}
    }
  }
}
