Cloud c1, c2, c3;
HoneyDrops hDrops;
HoneyDrops hDropsBee;
HoneyDrops hDropsdBee;
PFont fontHeading, fontData;

float[] x = new float[1];
float[] y = new float[1];
float segLength = 1;

ArrayList<Bee> bees;
ArrayList<DonkeyBee> dBees;

int swarm = 9;
int separationB = 65;
int separationDb = 65;
int dSwarm = 9;
int swarmSizeX = 80;
int swarmSizeY = 65;
int swarmDbSizeX = 80;
int swarmDbSizeY = 65;
int beeSize;
int dBeeSize;

boolean showvalues = true;
boolean scrollbar = false;

import processing.sound.*;
SoundFile beeSwarm;

float currR, currB, currG;
float nextR, nextB, nextG;
float easing = 0.01;
int lastChange = 0;
float d = 150;

PImage hive, hive2, tree, cloud, honey, flower;

void setup() {
  size(1600, 900, P2D);
  //frameRate(30);
  beeSwarm = new SoundFile(this, "bee.mp3");
  beeSwarm.loop();
  hive = loadImage("bee_hive.png");
  hive2 = loadImage("bee_hive.png");
  tree = loadImage("tree_branch.png");
  cloud = loadImage("cloud.png");
  honey = loadImage("honey_sprite.png");
  flower = loadImage("flower.png");
  fontHeading = createFont("HennyPenny-Regular.ttf", 60);
  fontData = createFont("HennyPenny-Regular.ttf", 14);
  currR = nextR = 135;
  currB = nextB = 206;
  currG = nextG = 235;
  c1 = new Cloud (0, 50, 600, 300);
  c2 = new Cloud (1300, 400, 300, 90);
  c3 = new Cloud (800, 800, 500, 350);
  hDrops = new HoneyDrops(500);
  hDropsBee = new HoneyDrops(100);
  hDropsdBee = new HoneyDrops(100);
  hint(DISABLE_DEPTH_MASK);

  bees = new ArrayList<Bee>();
  dBees = new ArrayList<DonkeyBee>();

  for (int i = 0; i < dSwarm; i++) {
    dBees.add(new DonkeyBee(swarmDbSizeX, swarmDbSizeY, "", 48));
  }

  for (int i = 0; i < swarm; i++) {
    bees.add(new Bee(swarmSizeX, swarmSizeY, "", 48));
  }
}

void draw() {
  background(currR, currB, currG);
  updateCurrColor();
  if (5000 < millis() - lastChange) { 
    pickNextColor();
    lastChange = millis();
  }

  c1.display();
  c1.update();
  c1.edges();
  c2.display();
  c2.update();
  c2.edges();
  c3.display();
  c3.update();
  c3.edges();

  imageMode(CENTER);
  image(hive, random(500, 502), 415);
  image(hive2, random(1200, 1202), 340);
  image(tree, 602, 20);

  textFont(fontHeading);
  fill(0);
  text("The", 720, 115);
  fill(245, 201, 22);
  text("       Swarm", 720, 115);

  if (showvalues) {
    textFont(fontData);
    textAlign(LEFT);
    fill(0);
    text("Framerate: " + round(frameRate), 20, 340);
    text("Total Donkey Bees: " + dBees.size() + "\nDonkey Bee Size: " + dBeeSize + "\nDonkey Bee Separation: " + separationDb, 20, 370);
    fill(245, 2185, 56);
    text("Total Angry Bees: " + bees.size() + "\nBee Size: " + beeSize + "\nBee Separation: " + separationB, 20, 465);
  }
  fill(245, 2185, 56);
  text("1 - Increases Bee size\n2 - Decreases Bee size\n0 - Resets Bees", 20, 655);
  fill(0);
  text("3 - Increases Donkey Bee size\n4 - Decreases Donkey Bee size\n5 - Resets Donkey Bees\nClick and drag the mouse to attract the bees", 20, 750);
  
  
  for (Bee b : bees) {
    boolean overlapping = false;
    for (Bee other : bees) {
      if (b != other && b.overlaps(other)) {
        overlapping = true;
      }
    }
    if (overlapping) {
      b.changeColour(168, 145, 0, 66);
      hDropsBee.update(168, 145, 0, 255);
      hDropsBee.display();
      hDropsBee.setEmitter(b.position.x, b.position.y);
    } else {
      noTint();
    }
    b.update();
    b.display();
    b.hover(bees);
    b.boundaries();
  }

  noTint();

  for (DonkeyBee dB : dBees) {
    boolean overlapping = false;
    for (DonkeyBee other : dBees) {
      if (dB != other && dB.overlaps(other)) {
        overlapping = true;
      }
    }
    if (overlapping) {
      dB.changeColour(15, 0, 0, 66);
      hDropsdBee.update(15, 0, 0, 255);
      hDropsdBee.display();
      hDropsdBee.setEmitter(dB.position.x, dB.position.y);
    } else {
      noTint();
    }
    dB.update();
    dB.display();
    dB.hover(dBees);
    dB.boundaries();
  }

  noTint();

  beeSize = swarmSizeX + swarmSizeY - 145;
  dBeeSize = swarmDbSizeX + swarmDbSizeY - 145;
}

void dragSegment(int i, float xin, float yin) {
  float dx = xin - x[i];
  float dy = yin - y[i];
  float angle = atan2(dy, dx);  
  x[i] = xin - cos(angle) * segLength;
  y[i] = yin - sin(angle) * segLength;
  segment(x[i], y[i], angle);
}

void segment(float x, float y, float a) {
  pushMatrix();
  translate(x, y);
  rotate(a);
  //line(0, 0, segLength, 0);
  flower.resize(0, 100);
  image(flower, 0, 0);

  popMatrix();
}

void pickNextColor() {
  nextR = random(68, 135);
  nextB = random(142, 206);
  nextG = random(228, 235);
}

void updateCurrColor() {
  // Easing between current and next colors
  currR += easing * (nextR - currR);
  currB += easing * (nextB - currB);
  currG += easing * (nextG - currG);
}

void mouseDragged() {
  for (DonkeyBee dB : dBees) {
    
    dB.applyBehaviors(dBees);
    dB.boundaries();
  }

  for (Bee b : bees) {
    
    b.applyBehaviors(bees);
    b.boundaries();
  }

  dragSegment(0, mouseX, mouseY);
  for (int i=0; i<x.length-1; i++) {
    dragSegment(i+1, x[i], y[i]);
  }

  hDrops.update(255, 255, 0, 255);
  hDrops.display();
  hDrops.setEmitter(mouseX, mouseY);
}

void keyPressed() {
  if (key == '3') {
    for (int i = 0; i < 1; i++) {
      swarmDbSizeX = swarmDbSizeX + 10;
      swarmDbSizeY = swarmDbSizeY + 10;
      separationDb = separationDb + 10;
      dBees.add(new DonkeyBee(swarmDbSizeX, swarmDbSizeY, "", 48));
    }
    for (DonkeyBee dB : dBees) {
      dB.update();
      dB.display();
      dB.hover(dBees);
      dB.boundaries();
    }
    dBees.remove(0);
  }

  if (key == '4') {
    for (int i = 0; i < 1; i++) {
      swarmDbSizeX = swarmDbSizeX - 10;
      swarmDbSizeY = swarmDbSizeY - 10;
      separationDb = separationDb - 10;
      dBees.add(new DonkeyBee(swarmDbSizeX, swarmDbSizeY, "", 48));
    }
    for (DonkeyBee dB : dBees) {
      dB.update();
      dB.display();
      dB.hover(dBees);
      dB.boundaries();
    }
    dBees.remove(0);
  }

  if (key == '1') {
    for (int i = 0; i < 1; i++) {
      swarmSizeX = swarmSizeX + 10;
      swarmSizeY = swarmSizeY + 10;
      separationB = separationB + 10;
      bees.add(new Bee(swarmSizeX, swarmSizeY, "", 48));
    }
    for (Bee b : bees) {
      b.update();
      b.display();
      b.hover(bees);
      b.boundaries();
    }
    bees.remove(0);
  }

  if (key == '2') {
    for (int i = 0; i < 1; i++) {
      swarmSizeX = swarmSizeX - 10;
      swarmSizeY = swarmSizeY - 10;
      separationB = separationB - 10;
      bees.add(new Bee(swarmSizeX, swarmSizeY, "", 48));
    }
    for (Bee b : bees) {
      b.update();
      b.display();
      b.hover(bees);
      b.boundaries();
    }
    bees.remove(0);
  }

  if (key == '0') {
    for (int i = 0; i < swarm; i++) {
      separationB = 65;
      bees.add(new Bee(80, 65, "", 48));
      swarmSizeX = 80;
      swarmSizeY = 65;
      bees.remove(0);
    }
  }

  if (key == '5') {
    for (int i = 0; i < dSwarm; i++) {
      separationDb = 65;
      dBees.add(new DonkeyBee(80, 65, "", 48));
      swarmDbSizeX = 80;
      swarmDbSizeY = 65;
      dBees.remove(0);
    }
  }
}
