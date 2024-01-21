
boolean overCircle(float x, float y, float r, PApplet w) {
  float disX = x - w.mouseX;
  float disY = y - w.mouseY;
  if (sqrt(sq(disX) + sq(disY)) < r) {
    return true;
  } else {
    return false;
  }
}

float sign (float X1, float Y1, float X2, float Y2, float X3, float Y3) {
  return (X1 - X3) * (Y2 - Y3) - (X2 - X3) * (Y1 - Y3);
}

boolean overTriangle(float X1, float Y1, float X2, float Y2, float X3, float Y3) {
  // Checking which side of the half-plane created by the edges the point is in
  float d1, d2, d3;
  boolean neg, pos;
  
  d1 = sign(mouseX, mouseY, X1, Y1, X2, Y2);
  d2 = sign(mouseX, mouseY, X2, Y2, X3, Y3);
  d3 = sign(mouseX, mouseY, X3, Y3, X1, Y1);
  
  neg = d1 < 0 || d2 < 0 || d3 < 0;
  pos = d1 > 0 || d2 > 0 || d3 > 0;
  
  return !(neg && pos);
}

float lock(float val, float minv, float maxv) {
  return min(max(val, minv), maxv);
}


class Triangle {
  float x1, y1, x2, y2, x3, y3;
  boolean over;
  boolean press;
  boolean locked = false;
  float fill = 120;
  float edge = 120;
  boolean firstMousePress = false;
  PApplet w;
  boolean movable = false;
  
  Triangle(float X1, float Y1, float X2, float Y2, float X3, float Y3, PApplet W) {
    x1 = X1;
    y1 = Y1;
    x2 = X2;
    y2 = Y2;
    x3 = X3;
    y3 = Y3;
    w = W;
  }
  
  void update() {
    overEvent();
    pressEvent();
  }
  
  void overEvent() {
    if (overTriangle(x1, y1, x2, y2, x3, y3)) {
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
  
  void setMovable(boolean m) {
    movable = m;
  }
  
  void display() {
    w.fill(255);
    //stroke(edge);
    if (over || press) {
      w.fill(0);
    }
    w.triangle(x1, y1, x2, y2, x3, y3);
  }
}

void drawSystem(ArrayList<Node> nodes) {
  for (Node n : nodes) {
    n.update();
    n.display();
  }
}

void adjustSystem(ArrayList<Node> nodes, IntList lims) {
  for (Node n : nodes) {
    n.adjust(lims);
    n.display();
  }
}
