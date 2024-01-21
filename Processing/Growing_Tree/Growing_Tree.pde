/*
*
* Dynamic tree that grows with the mouse
*
*/

float theta;

void setup() {
  size(1000,750);
}

void draw() {
  background(0);
  frameRate(100);
  stroke(255);
  float a = 2 * (mouseX / (float) width) * 90f;
  theta = radians(a);
  translate(width/2, height);
  float L = ((height - mouseY) / (float) height) * height/2;
  line(0, 0, 0, -L);
  translate(0, -L);
  branch(L);
}

void branch(float h) {
  h *= 0.66;
  
  if (h > 4){
    pushMatrix();
    rotate(theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
    
    
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}
