/*
*
* A 3d animated cloud made with Perlin Noise
*
* Voxels darker than a specific size are made fully transparent
*
*/


float increment = 0.01;

// Global variable that increments once per cycle
float woff = 0.0;

OpenSimplex noise;

int grid_size = 50;
int spacing = 1;
float lower_bound = 120; // 50 and 120 give interesting results

float z_rot = 0.0;

 void setup() {
  size(640, 640, P3D);
  frameRate(30);
  //ortho();
  
  noise = new OpenSimplex(1234567);
 }

void draw() {
  camera();
  background(255);
  translate(width/2, height/2, (height/2.0) / tan(PI*30.0 / 180.0) - 2 * grid_size * spacing);
  
  //rotateX(-3 * PI * mouseY / (float) height);
  //rotateY(3 * PI * mouseX / (float) width);
  rotateY(z_rot);
  if (mousePressed) {
    z_rot += PI/32;
    if (z_rot > 2*PI) {
      z_rot = 0.0;
    }
  }
  
  float wincrement = (mouseY / (float) height) * 0.2;
  float increment = (mouseX / (float) width) * 0.25;
  
  float xoff = 0.0;
  for (int x = 0; x < grid_size; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < grid_size; y++) {
      yoff += increment;
      float zoff = 0.0;
      for (int z = 0; z < grid_size; z++) {
        zoff += increment;
        float new_x = (float) (x - grid_size/2) * spacing;
        float new_y = (float) (y - grid_size/2) * spacing;
        float new_z = (float) (z - grid_size/2) * spacing;
        float bright = map((((float) noise.eval(xoff,yoff,zoff,woff)) + 1) / 2 * 255, 80, 255, 0, 255);
        draw_point(new_x, new_y, new_z, bright);
      }
    }
  }
  woff += wincrement;
}

void draw_point(float x, float y, float z, float c) {
  //pushMatrix();
  stroke(0, c, c);
  strokeWeight(10);
  if (c < lower_bound) {
    noStroke();
    //noFill();
  } else {
    //fill(c, c, c);
    stroke(c, 0, 255 - c);
  }
  point(x, y, z);
  //popMatrix();
}
