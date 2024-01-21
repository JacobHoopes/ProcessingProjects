// Node class describes a modifiable point in a window
class Node {
  float x, y, r;
  boolean over;
  boolean press;
  boolean locked = false;
  boolean otherslocked = false; // This does nothing right now, it might not ever do anything
  int position;
  int col = 100;
  ArrayList<Node> node_array;
  PApplet w;
  boolean firstMousePress = false;
  IntList lims; // limits for nodes etc that can move around on the screen
  
  Node(float ix, float iy, float radius, int p, ArrayList<Node> o, PApplet W, IntList limits) {
    w = W;
    lims = limits;
    r = radius;
    x = lock(ix, lims.get(0) + r, lims.get(1) - r);
    y = lock(iy, lims.get(2) + r, lims.get(3) - r);
    position = p;
    node_array = o;
    
  }
  
  void update() {
    overEvent();
    pressEvent();
    
    if (press) {
      x = lock(w.mouseX, lims.get(0) + r, lims.get(1) - r);
      y = lock(w.mouseY, lims.get(2) + r, lims.get(3) - r);
    }
  }
  
  void overEvent() {
    int highestPosition = 0;
    for (Node n : node_array) {
      if (overCircle(n.x, n.y, n.r, w) && n.position > highestPosition) {
        highestPosition = n.position;
      }
    }
    if (overCircle(x, y, r, w) && highestPosition == position) {
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
    w.fill(col);
    w.stroke(255);
    if (over || press) {
      w.fill(col + 100);
    }
    w.circle(x, y, r*2);
  }
}
