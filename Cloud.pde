class Cloud {
  PVector location;
  PVector velocity;
  float diameterX;
  float diameterY;
  
  Cloud(float tempX, float tempY, float tempDiameterX, float tempDiameterY) {
    diameterX = tempDiameterX;
    diameterY = tempDiameterY;
    
    location = new PVector(tempX, tempY);
    velocity = new PVector(0.09, 0);
    location.add(velocity);
  }
  
  void edges() {
    if (location.x > width)  location.x = 0;
    if (location.x < 0)      location.x = width;
    if (location.y > height) location.y = 0;
    if (location.y < 0)      location.y = height;
  }
  
  void update() {
    location.add(velocity);
    
  }
  
  void display() {
    imageMode(CENTER);
    image(cloud, location.x, location.y, diameterX, diameterY);
  }
  
}
