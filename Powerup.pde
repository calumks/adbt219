class Powerup extends Obj {
  String id;
  int timer = 10;
  
  Powerup(String id) {
     pos = new PVector();
     pos.x = random(gMin, gWidth - gMin);
     pos.y = random(gMin, gHeight - gMin);
     this.id = id;
     
     if (id == "2 bullets") {
       colour = color(255, 255, 0); 
     } else if (id == "3 bullets") {
       colour = color(255, 0, 0); 
     } else if (id == "machine gun") {
       colour = color(0, 0, 255); 
     } else if (id == "speed") {
       colour = color(255, 20, 147); 
     }
  }
  
  void display() {   
    fill(colour);
    square(pos.x, pos.y, 10);
  }
}
