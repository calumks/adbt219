class Player extends Obj {
  HashMap<String, Powerup> powerups;
  Player() {
    pos = new PVector(gWidth/2, gHeight/2);
    speed = 1.5;
    radius = 10;
    colour = color(0, 0, 255);
    powerups = new HashMap<String, Powerup>();
  }
  
  void keepInCanvas() {
    if (player.pos.x < gMin + player.radius) {
      player.pos.x = gMin + player.radius;
    }
    if (player.pos.y < gMin + player.radius) {
      player.pos.y = gMin + player.radius; 
    }
    if (player.pos.x > gWidth + gMin - player.radius) {
      player.pos.x = gWidth + gMin -  player.radius; 
    }
    if (player.pos.y > gHeight + gMin - player.radius) {
      player.pos.y = gHeight + gMin -  player.radius; 
    }
  }
  
  void display() {
    fill(colour);
    circle(pos.x, pos.y, radius*2);
    
    if (powerups.containsKey("speed")) {
      println("test");
      speed = 2; 
    } else {
      speed = 1.5; 
    }
    
    // Display powerups
    int i = 0;
    Iterator pIter = powerups.entrySet().iterator();
    while (pIter.hasNext()) {
      Map.Entry pair = (Map.Entry) pIter.next();
      Powerup powerup = (Powerup) pair.getValue();
      if (frameCount % 60 == 0) {
        powerup.timer--;
      }
      if (powerup.timer <= 0) {
        pIter.remove();
      }
      textSize(20);
      fill(powerup.colour);
      text(powerup.id + " (" + powerup.timer + ")", 200, gHeight + gMin + 40 + i * 25);
      ++i;
    }
  }
}
