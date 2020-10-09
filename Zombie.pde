class Zombie extends Obj {
  int level;
  Zombie(int level) {
    if (random(1) > 0.5) {
      pos = new PVector(random(gWidth), random(1) > 0.5 ? gMin : gHeight);
    } else {
      pos = new PVector(random(1) > 0.5 ? gMin : gWidth, random(gHeight));
    }
    speed = random(0.9, 1.1);
    radius = 10;
    this.level = level;
    setLevelColour();
  }
  
  /**
   * Run when a zombie is attacked
   */
  void attacked() {
    println("test");
    points += 10;
    --level;
    setLevelColour();
    zombieHit.play();
  }

  private void setLevelColour() {
    if (level == 1) {
      colour = color(255);
    } else if (level == 2) {
      colour = color(150); 
    } else if (level == 3) {
      colour = color(80); 
    } else {
      colour = color(0); 
    }
  }
}
