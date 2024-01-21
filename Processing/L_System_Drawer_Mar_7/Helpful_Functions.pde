
boolean overCircle(float x, float y, float r, PApplet W) {
  float disX = x - W.mouseX;
  float disY = y - W.mouseY;
  if (sqrt(sq(disX) + sq(disY)) < r) {
    return true;
  } else {
    return false;
  }
}

float sign (float X1, float Y1, float X2, float Y2, float X3, float Y3) {
  return (X1 - X3) * (Y2 - Y3) - (X2 - X3) * (Y1 - Y3);
}

boolean overTriangle(float X1, float Y1, float X2, float Y2, float X3, float Y3, PApplet W) {
  // Checking which side of the half-plane created by the edges the point is in
  float d1, d2, d3;
  boolean neg, pos;
  
  d1 = sign(W.mouseX, W.mouseY, X1, Y1, X2, Y2);
  d2 = sign(W.mouseX, W.mouseY, X2, Y2, X3, Y3);
  d3 = sign(W.mouseX, W.mouseY, X3, Y3, X1, Y1);
  
  neg = d1 < 0 || d2 < 0 || d3 < 0;
  pos = d1 > 0 || d2 > 0 || d3 > 0;
  
  return !(neg && pos);
}

boolean overQuad(float X1, float Y1, float X2, float Y2, float X3, float Y3, float X4, float Y4, PApplet W) {
  float d1, d2, d3, d4;
  boolean neg, pos;
  
  d1 = sign(W.mouseX, W.mouseY, X1, Y1, X2, Y2);
  d2 = sign(W.mouseX, W.mouseY, X2, Y2, X3, Y3);
  d3 = sign(W.mouseX, W.mouseY, X3, Y3, X4, Y4);
  d4 = sign(W.mouseX, W.mouseY, X4, Y4, X1, Y1);
  
  neg = d1 < 0 || d2 < 0 || d3 < 0 || d4 < 0;
  pos = d1 > 0 || d2 > 0 || d3 > 0 || d4 > 0;
  
  return !(neg && pos);
}

boolean overRect(float X, float Y, float w, float h, PApplet W) {
  boolean xgood = W.mouseX > X && W.mouseX < X + w;
  boolean ygood = W.mouseY > Y && W.mouseY < Y + h;
  return xgood && ygood;
}



class Triangle {
  float x1, y1, x2, y2, x3, y3;
  boolean over;
  boolean press;
  boolean locked = false;
  float fill = 120;
  float overFill = 160;
  float edge = 120;
  boolean firstMousePress = false;
  PApplet w;
  IntList lims;
  boolean movable = false;
  float h;
  Node child;
  
  Triangle(float X1, float Y1, float X2, float Y2, float X3, float Y3, PApplet Window, IntList limits) {
    x1 = X1;
    y1 = Y1;
    x2 = X2;
    y2 = Y2;
    x3 = X3;
    y3 = Y3;
    w = Window;
    lims = limits;
    h = max(y1, max(y2, y3)) - min(y1, min(y2, y3));
  }
  
  void update() {
    overEvent();
    pressEvent();
    
    
    if (press && movable) {
      float x = lock(w.mouseX, lims.get(0) + (x1-x3), lims.get(1) + (x1-x2));
      float y = lock(w.mouseY - h / 2, lims.get(2), lims.get(3) - h);
      child.move(x - x1, y - y1);
      shift(x, y);
    }
  }
  
  void overEvent() {
    if (overTriangle(x1, y1, x2, y2, x3, y3, w)) {
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
  
  void setChild(Node n) {
    child = n;
  }
  
  void setMovable(boolean m) {
    movable = m;
  }
  
  void shift(float x, float y) {
    float xChange = x - x1;
    float yChange = y - y1;
    x2 += xChange;
    y2 += yChange;
    x3 += xChange;
    y3 += yChange;
    x1 = x;
    y1 = y;
  }
  
  void move(float X1, float Y1, float X2, float Y2, float X3, float Y3) {
    x1 = X1;
    y1 = Y1;
    x2 = X2;
    y2 = Y2;
    x3 = X3;
    y3 = Y3;
  }
  
  void adjust(IntList newlims) {
    lims = newlims;
    float x = lock(x1, lims.get(0) + (x1-x3), lims.get(1) + (x1-x2));
    float y = lock(y1, lims.get(2), lims.get(3) - h);
    shift(x, y);
  }
  
  void display() {
    w.fill(fill);
    w.stroke(edge);
    if (over || press) {
      w.fill(overFill);
    }
    w.triangle(x1, y1, x2, y2, x3, y3);
  }
}

class Rectangle {
  float x, y, w, h;
  boolean over;
  boolean press;
  boolean locked = false;
  float fill = 120;
  float overFill = 160;
  float edge = 120;
  boolean firstMousePress = false;
  PApplet W;
  boolean movable = false;
  String s;
  
  Rectangle(float X, float Y, float Width, float Height, String string, PApplet Window) {
    x = X;
    y = Y;
    w = Width;
    h = Height;
    s = string;
    W = Window;
  }
  
  void update() {
    overEvent();
    pressEvent();
  }
  
  void overEvent() {
    if (overRect(x, y, w, h, W)) {
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
    W.fill(fill);
    W.stroke(edge);
    if (over || press) {
      W.fill(overFill);
    }
    W.rect(x, y, w, h, 5);
    
    W.textAlign(CENTER, CENTER);
    W.fill(0);
    int yChange = 3;
    if (s == "+") {
      yChange = 5;
    }
    W.text(s, x + w/2 + 1, y + yChange);
  }
}


float lock(float val, float minv, float maxv) {
  return min(max(val, minv), maxv);
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

float distance(float x1, float y1, float x2, float y2) {
  return sqrt(pow((x1 - x2), 2) + pow((y1 - y2), 2));
}

String generateSystem(Node n) {
  String s = "";
  for (Node nn : n.children) {
    if (nn.children.size() == 0) {
      s += generateSystem(nn);
    } else {
      
    }
  }
  return s;
}