/*
*
* A 3d animated cloud made with Perlin Noise
*
* Voxels darker than a specific size are made fully transparent
*
*/


float increment = 0.01;

int cube_size = 2;
int grid_size = 25;
int spacing = 0;

float z_rot = 0.0;

 void setup() {
  size(640, 640, P3D);
  frameRate(30);
  //ortho();
 }

void draw() {
  camera();
  background(255);
  translate(width/2, height/2, (height/2.0) / tan(PI*30.0 / 180.0) - 2 * grid_size * (cube_size + spacing));
  
  //rotateX(-3 * PI * mouseY / (float) height);
  //rotateY(3 * PI * mouseX / (float) width);
  rotateY(z_rot);
  if (mousePressed) {
    z_rot += PI/32;
    if (z_rot > 2*PI) {
      z_rot = 0.0;
    }
  }
  
  float detail = map(mouseX, 0, width, -0.3, 1); // 0.6 is a good value usually
  noiseDetail(8, detail);
  
  float xoff = 0.0;
  for (int x = 0; x < grid_size; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < grid_size; y++) {
      yoff += increment;
      float zoff = 0.0;
      for (int z = 0; z < grid_size; z++) {
        zoff += increment;
        float new_x = (float) (x - grid_size/2) * (spacing + cube_size) + ((grid_size + 1) % 2) * (spacing + cube_size) / 2;
        float new_y = (float) (y - grid_size/2) * (spacing + cube_size) + ((grid_size + 1) % 2) * (spacing + cube_size) / 2;
        float new_z = (float) (z - grid_size/2) * (spacing + cube_size) + ((grid_size + 1) % 2) * (spacing + cube_size) / 2;
        float bright = map(noise(xoff,yoff,zoff) * 255, 120, 225, 0, 255);
        makeCube(new_x, new_y, new_z, cube_size, bright);
      }
    }
  }
}

void makeCube(float x, float y, float z, float r, float c) {
  pushMatrix();
  stroke(0, 0, 0);
  float x_col = map(x, -grid_size*(spacing+cube_size)/2, grid_size*(spacing+cube_size)/2, 0, 255);
  float y_col = map(y, -grid_size*(spacing+cube_size)/2, grid_size*(spacing+cube_size)/2, 0, 255);
  float z_col = map(z, -grid_size*(spacing+cube_size)/2, grid_size*(spacing+cube_size)/2, 0, 255);
  if (c < 20) {
    noStroke();
    noFill();
  } else {
    fill(c, c, c);
  }
  translate(x, y, z);
  box(r);
  popMatrix();
}
