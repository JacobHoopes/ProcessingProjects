
float increment = 0.01;

int cube_size = 10;
int grid_size = 12;

 void setup() {
  size(640, 640, P3D);
  frameRate(30);
 }

void draw() {
  camera();
  background(255);
  translate(width/2, height/2, cube_size * grid_size * 2);
  
  rotateX(-3 * PI * mouseY / (float) height);
  rotateY(3 * PI * mouseX / (float) width);
  
  for (int x = 0; x < grid_size; x++) {
    for (int y = 0; y < grid_size; y++) {
      for (int z = 0; z < grid_size; z++) {
        float adjustment = grid_size / 2;
        float new_x = (float) (x - grid_size/2) * grid_size + adjustment;
        float new_y = (float) (y - grid_size/2) * grid_size + adjustment;
        float new_z = (float) (z - grid_size/2) * grid_size + adjustment;
        makeCube(new_x, new_y, new_z, cube_size);
      }
    }
  }
}

void makeCube(float x, float y, float z, float r) {
  pushMatrix();
  stroke(0, 0, 0);
  float x_col = map(x, -grid_size*grid_size/2, grid_size*grid_size/2, 0, 255);
  float y_col = map(y, -grid_size*grid_size/2, grid_size*grid_size/2, 0, 255);
  float z_col = map(z, -grid_size*grid_size/2, grid_size*grid_size/2, 0, 255);
  fill(x_col, y_col, z_col);
  translate(x, y, z);
  box(r);
  popMatrix();
}
