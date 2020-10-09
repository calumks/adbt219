abstract class Obj {
  PVector pos;
  PVector dir;
  float speed;
  float radius;
  color colour;
  
  void display() {
    fill(colour);
    circle(pos.x, pos.y, radius*2); 
  }
  
  void move(PVector dir) {
    this.dir = dir.mult(speed);
    move();
  }
  
  void move() {
    if (!gameOver) {
      pos.add(dir);      
    }
  }
  
  boolean collidesWith(Obj other) {
    return dist(pos.x, pos.y, other.pos.x, other.pos.y) <= radius + other.radius;
  }
  
  boolean withinCanvas() {
    return pos.x < gWidth + gMin && pos.y < gHeight + gMin && pos.y > gMin && pos.x > gMin;
  }
}
