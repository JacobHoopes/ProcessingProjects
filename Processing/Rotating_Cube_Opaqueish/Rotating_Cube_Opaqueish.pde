/*
*
* A spinning Cube
* 
*/


float increment = 0.01;

// Global variable that increments once per cycle
float woff = 0.0;

int size = 15;

float a = 0.0;
float b = 0.0;

 void setup() {
  size(640, 640, P3D);
  frameRate(30);
  //ortho();
 }

void draw() {
  camera();
  background(255);
  translate(width/2,height/2,165);
  a += 0.0097;
  if (a > PI * 2) {
    a = 0.0;
  }
  b += 0.0083;
  if (a > PI * 2) {
    b = 0.0;
  }
  rotateX(a);
  rotateY(b);
  
  float xoff = 0.0;
  for (int x = 0; x < size; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < size; y++) {
      yoff += increment;
      float zoff = 0.0;
      for (int z = 0; z < size; z++) {
        zoff += increment;
        makeCube(x*size-size*size/2, y*size-size*size/2, z*size-size*size/2, 7, 0);
      }
    }
  }
}

void makeCube(float x, float y, float z, float r, float c) {
  
  fill(0,0.0);
  stroke(0,0,0);
  pushMatrix();
  translate(x, y, z);
  box(r);
  popMatrix();
}
