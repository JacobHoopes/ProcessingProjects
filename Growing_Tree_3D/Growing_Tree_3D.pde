/*
*
* Dynamic tree that grows with the mouse
*
*/

int branches = 3;
float decrease = 0.66;
int minimum_size = 10;


float theta;
float y_rot = 0.0;
float a = 0.3;
float b = -0.1;
float c = 0.7;
float aincrement = 0.01;
float bincrement = 0.03;
float cincrement = 0.07;

void setup() {
  size(1000,750,P3D);
  //ortho();
}

void draw() {
  camera();
  background(255);
  frameRate(30);
  stroke(0);
  float a = 2 * (mouseX / (float) width) * 90f;
  theta = radians(a);
  translate(width/2, height, 0);
  float L = ((height - mouseY) / (float) height) * height/2;
  
  rotateY(y_rot);
  if (mousePressed) {
    y_rot += PI/64;
    if (y_rot > 2*PI) {
      y_rot = 0.0;
    }
  }
  
  a += aincrement;
  if (a > 1) {
    a = -1;
  }
  b += bincrement;
  if (b > 1) {
    b = -1.0;
  }
  c += cincrement;
  if (c > 1) {
    c = -1.0;
  }
  
  line(0, 0, 0, 0, -L, 0);
  translate(0, -L, 0);
  branch(L);
}


void branch(float h) {
  h *= decrease;
  
  if (h > minimum_size){
    for (int i = 0; i < branches; i++) {
      pushMatrix();
      rotate(theta);
      line(0, 0, 0, 0, -h, 0);
      translate(0, -h, 0);
      branch(h);
      popMatrix();
      rotateY(2*PI/branches);
    }
  } else {
    leaf();
  }
}

float calc(float v) {
  return noise((sin((v+1)*PI)+1)/2)*255;
}

void leaf() {
  fill(calc(a),calc(b),calc(c));
  box(5);

}
