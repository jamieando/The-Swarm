class Honey {

  PVector velocity;
  float lifespan = 255;
  
  PShape part;
  float partSize;
  
  PVector gravity = new PVector(0,0.1);


  Honey() {
    partSize = random(5,15);
    part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(honey);
    part.normal(0, 0, 1);
    part.vertex(-partSize/2, -partSize/2, 0, 0);
    part.vertex(+partSize/2, -partSize/2, honey.width, 0);
    part.vertex(+partSize/2, +partSize/2, honey.width, honey.height);
    part.vertex(-partSize/2, +partSize/2, 0, honey.height);
    part.endShape();
    
    rebirth(width/2,height/2);
    lifespan = random(255);
  }

  PShape getShape() {
    return part;
  }
  
  void rebirth(float x, float y) {
    float a = random(TWO_PI);
    float speed = random(0.5,4);
    velocity = new PVector(cos(a), sin(a));
    velocity.mult(speed);
    lifespan = 255;   
    part.resetMatrix();
    part.translate(x, y); 
  }
  
  boolean isDead() {
    if (lifespan < 0) {
     return true;
    } else {
     return false;
    } 
  }
  

  public void update(int colourR, int colourG, int colourB, int colourO) {
    lifespan = lifespan - 1;
    velocity.add(gravity);
    
    part.setTint(color(colourR, colourG, colourB, colourO));
    part.translate(velocity.x, velocity.y);
  }
}
