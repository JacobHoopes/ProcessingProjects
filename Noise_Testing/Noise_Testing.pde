/*
*
* Experimenting with Perlin noise
*
*/

float increment = 0.01;

float zoff = 0.0;

OpenSimplexNoise noise;

void setup() {
  size(750,750);
  frameRate(30);
  //background(0);
  //noStroke();
  noise = new OpenSimplexNoise();
}

void draw() {
  loadPixels();
  
  float zincrement = (mouseY / (float) height) * 0.2;
  float increment = (mouseX / (float) width) * 0.2;
  
  float xoff = 0.0;
  //float detail = map(mouseX, 0, width, 0.1, 0.6);
  //noiseDetail(8, detail);
  //fill(0, 10);
  //rect(0, 0, width, height);
  
  //float n = random(0, width);
  
  for (int x = 0; x < width; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < height; y++) {
      yoff += increment;
      
      
      //float bright = noise(xoff, yoff, zoff) * 255;
      
      
      float n = (float) noise.eval(xoff, yoff, zoff);
      //float bright = map(n, -1, 1, 0, 255); // This looks very cool and flat
      float bright = map(n, -1, 1, 0, 255);
      
      //float bright = random(0, 255);
      pixels[x + y * width] = color(bright, bright, bright);
    }
  }
  
  updatePixels();
  
  zoff += zincrement;
  
  //float n = noise(xoff) * width;
  
  //xoff += xincrement;
  
  //fill(200);
  //ellipse(n, height/2, 64, 64);
}
