class Bee {

  PVector position;
  PVector velocity;
  PVector acceleration;
  int r;
  int bR = 30;
  int brightness;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  float diameterX;
  float diameterY;

  PImage[] images;
  int imageCount;
  int frame;

  // Constructor initialize all values
  Bee(float tempDiameterX, float tempDiameterY, String imagePrefix, int count) {
    diameterX = tempDiameterX;
    diameterY = tempDiameterY;

    position = new PVector(random(629, 630), random(649, 650));
    r = r + separationB;
    maxspeed = 5;
    maxforce = 0.2;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);

    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + nf(i, 2) + ".png";
      images[i] = loadImage(filename);
    }
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void hover(ArrayList<Bee> bees) {
    PVector separateForce = separate(bees);
    PVector seekForce = seek(new PVector(630, 650));
    separateForce.mult(2);
    seekForce.mult(1);
    applyForce(separateForce);
    applyForce(seekForce);
  }

  void applyBehaviors(ArrayList<Bee> bees) {
    PVector separateForce = separate(bees);
    PVector seekForce = seek(new PVector(mouseX, mouseY));
    separateForce.mult(2);
    seekForce.mult(1);
    applyForce(separateForce);
    applyForce(seekForce);
  }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force

    return steer;
  }

  // Separation
  PVector separate (ArrayList<Bee> bees) {
    float desiredseparation = r*2;
    PVector sum = new PVector();
    int count = 0;
    
    for (Bee other : bees) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(maxspeed);
      
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    return sum;
  }


  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    frame = (frame+1) % imageCount;
    image(images[frame], position.x, position.y, diameterX, diameterY);
    noFill();
  }

  void boundaries() {
    PVector desired = null;

    if (position.x < d) {
      desired = new PVector(maxspeed, velocity.y);
    } else if (position.x > width -d) {
      desired = new PVector(-maxspeed, velocity.y);
    } 

    if (position.y < d) {
      desired = new PVector(velocity.x, maxspeed);
    } else if (position.y > height-d) {
      desired = new PVector(velocity.x, -maxspeed);
    } 

    if (desired != null) {
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
  }

  boolean overlaps(Bee other) {
    float d = dist(position.x, position.y, other.position.x, other.position.y);
    
    if (d < bR + other.bR) {
      return true;
    } else {
      return false;
    }
  }

  void changeColour(int colourR, int colourG, int colourB, int colourO) {
    tint(colourR, colourG, colourB, colourO);
  }
}
