// Ariel and V3ga's arcball class with a couple tiny mods by Robert Hodgin

class Arcball {
  PApplet parent;
  float center_x, center_y, radius;
  
  Arcball(PApplet parent, float radius){
    this.parent = parent;
    this.radius = radius;  
  }

  void mousePressed(){
    print("whoa");
  }

  void mouseDragged(){
    print("hello");
  }

  void run(){
    center_x = parent.width/2.0;
    center_y = parent.height/2.0;
  }

}
