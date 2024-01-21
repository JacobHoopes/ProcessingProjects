
/*
 * Simulating gravitational attraction 
 * G ---> universal gravitational constant
 * m1 --> mass of object #1
 * m2 --> mass of object #2
 * d ---> distance between objects
 * F = (G*m1*m2)/(d*d)
 */
 
float min_size = 200;
float max_size = 1600;

float max_radius = pow((max_size / PI), 0.5);

float r = 1;
float x = mouseX;
float y = mouseY;
float vx = 0.0;
float vy = 0.0;

float min_fling = 10;
float max_fling = 100;

boolean pressed = true;
boolean dragging = false;

Body[] bodies = new Body[10];

void setup() {
  size(640, 640);
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(random(min_size, max_size), random(0, width), random(0, height), vx, vy);
  }
}

void draw() {
  background(0);
  for (Body b : bodies) {
    for (Body b2 : bodies) {
      if (b != b2) {
        PVector force = b.attract(b2);
        b2.applyForce(force);
      }
    }
    b.update();
    b.display();
  }
  
    
  if (pressed) {
    if (!dragging) {
      if (r < max_radius) {
        r += 0.2;
      }
      stroke(255);
      strokeWeight(2);
      noFill();
      ellipse(x, y, r*2, r*2);
    } else {
      stroke(255);
      strokeWeight(2);
      noFill();
      ellipse(x, y, r*2, r*2);
      PVector center = new PVector(x, y);
      PVector test_mouse = new PVector(mouseX, mouseY);
      PVector mouse;
      test_mouse.sub(center);
      if (test_mouse.mag() < min_fling) {
        test_mouse.setMag(min_fling);
      } else if (test_mouse.mag() > max_fling) {
        test_mouse.setMag(max_fling);
      }
      mouse = test_mouse.copy();
      translate(x, y);
      stroke(255);
      strokeWeight(3);
      noFill();
      line(0, 0, mouse.x, mouse.y);
      vx = mouse.x;
      vy = mouse.y;
    }
  }
  
  if (!mousePressed) {
    if (pressed && dragging) {
      Body b = new Body(PI*r*r, x, y, vx/10, vy/10);
      bodies = (Body[]) append(bodies, b);
    }  
    r = 1;
    x = mouseX;
    y = mouseY;
    vx = 0.0;
    vy = 0.0;
    pressed = false;
    dragging = false;
  }
}

void mousePressed() {
  pressed = true;
}

void mouseDragged() {
  if (abs(x - mouseX) > r || abs(y - mouseY) > r) {
    dragging = true;
  }
}
