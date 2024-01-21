
int cube_size = 10;
int grid_size = 20;
int spacing = 0;

float z_rot = 0.0;

 void setup() {
  size(640, 640, P3D);
  frameRate(30);
 }

void draw() {
  camera();
  background(255);
  translate(width/2, height/2, (height/2.0) / tan(PI*30.0 / 180.0) - 2 * grid_size * (cube_size + spacing));
  
  rotateX(-3 * PI * mouseY / (float) height);
  rotateY(3 * PI * mouseX / (float) width);
  rotateZ(z_rot);
  if (mousePressed) {
    z_rot += PI/32;
    if (z_rot > 2*PI) {
      z_rot = 0.0;
    }
  }
  
  
  for (int x = 0; x < grid_size; x++) {
    for (int y = 0; y < grid_size; y++) {
      for (int z = 0; z < grid_size; z++) {
        float new_x = (float) (x - grid_size/2) * (spacing + cube_size) + ((grid_size + 1) % 2) * (spacing + cube_size) / 2;
        float new_y = (float) (y - grid_size/2) * (spacing + cube_size) + ((grid_size + 1) % 2) * (spacing + cube_size) / 2;
        float new_z = (float) (z - grid_size/2) * (spacing + cube_size) + ((grid_size + 1) % 2) * (spacing + cube_size) / 2;
        makeCube(new_x, new_y, new_z, cube_size);
      }
    }
  }
}

void makeCube(float x, float y, float z, float r) {
  pushMatrix();
  
  float x_col = map(x, -grid_size*(spacing+cube_size)/2, grid_size*(spacing+cube_size)/2, 0, 255);
  float y_col = map(y, -grid_size*(spacing+cube_size)/2, grid_size*(spacing+cube_size)/2, 0, 255);
  float z_col = map(z, -grid_size*(spacing+cube_size)/2, grid_size*(spacing+cube_size)/2, 0, 255);
  stroke(x_col, y_col, z_col);
  fill(x_col, y_col, z_col);
  translate(x, y, z);
  box(r);
  popMatrix();
}
