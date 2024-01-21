
// Perhaps I could make a fixed-body subclass next?

class Body {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float top_speed;
  float[] c = new float[3];
  
  float G;
  
  Body(float m, float x, float y, float vx, float vy) {
    mass = m;
    position = new PVector(x, y);
    velocity = new PVector(vx, vy);
    acceleration = new PVector(0, 0);
    c[0] = random(0, 255);
    c[1] = random(0, 255);
    c[2] = random(0, 255);
    
    top_speed = 5.0;
    
    G = 0.002;
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  //void run() {
  //  update();
  //  display();
  //}
  
  PVector attract(Body b) {
    PVector force = PVector.sub(position, b.position);
    float d = force.mag();
    d = constrain(d, 5.0, 25.0);
    float strength = (G * mass * b.mass) / (d * d);
    force.setMag(strength);
    return force;
  }
  
  void update() {
    //PVector mouse = new PVector(mouseX, mouseY);
    //PVector acceleration = PVector.sub(mouse, location);
    //acceleration.setMag(0.2);
    
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    
    velocity.limit(top_speed);
  }
  
  void display() {
    stroke(255);
    strokeWeight(2);
    fill(c[0], c[1], c[2], 100);
    ellipse(position.x, position.y, pow((mass / PI), 0.5) * 2, pow((mass / PI), 0.5) * 2);
    // d = (A / PI)^0.5 * 2
  }
}
