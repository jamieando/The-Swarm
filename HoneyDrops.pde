class HoneyDrops {
  ArrayList<Honey> hDrops;

  PShape particleShape;

  HoneyDrops(int n) {
    hDrops = new ArrayList<Honey>();
    particleShape = createShape(PShape.GROUP);

    for (int i = 0; i < n; i++) {
      Honey h = new Honey();
      hDrops.add(h);
      particleShape.addChild(h.getShape());
    }
  }

  void update(int colourR, int colourG, int colourB, int colourO) {
    for (Honey h : hDrops) {
      h.update(colourR, colourG, colourB, colourO);
    }
  }

  void setEmitter(float x, float y) {
    for (Honey h : hDrops) {
      if (h.isDead()) {
        h.rebirth(x, y);
      }
    }
  }

  void display() {

    shape(particleShape);
  }
}
