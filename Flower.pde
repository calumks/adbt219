class Flower {
  PVector pos = new PVector();
  color colour;
  
  Flower() {
     pos.x = random(gMin, gWidth - gMin);
     pos.y = random(gMin, gHeight - gMin);
     colour = color(255, 255, random(1) > 0.5 ? 255: 0);
  }
  
  void display() {
    noStroke();
    fill(colour);
    rect(pos.x, pos.y - 5, 5, 15);
    rect(pos.x - 5, pos.y, 15, 5);
    fill(200, 200, 0);
    square(pos.x, pos.y, 5);
    stroke(1);
  }
}
