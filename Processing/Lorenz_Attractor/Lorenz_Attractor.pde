
float x = 0.01;
float y = 0;
float z = 0;

float a = 10;
float b = 28;
float c = 8.0/3.0;

float dt = 0.01;

ArrayList<PVector> points = new ArrayList<PVector>();


void setup() {
  size(640, 360, P3D);
  colorMode(HSB);
  background(0);
  //frameRate(40);
}

void draw() {
  camera();
  
  
  background(0);
  float dx = a * (y - x) * dt;
  float dy = x * (b - z) * dt;
  float dz = (x * y - c * z) * dt;
  
  x = x + dx;
  y = y + dy;
  z = z + dz;
  
  points.add(new PVector(x, y, z));
  
  translate(width/2, height/2, 0);
  scale(2);
  stroke(255);
  noFill();
  beginShape();
  float hu = 0.0;
  for (PVector v : points) {
    stroke(hu, 255, 255);
    vertex(v.x, v.y, v.z);
    //PVector offset = PVector.random3D();
    //offset.mult(0.1);
    //v.add(offset);
    hu += 0.1;
    if (hu > 255) {
      hu = 0.0;
    }
    
  }
  endShape();
}
