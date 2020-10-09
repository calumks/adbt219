import java.util.ListIterator;
import java.util.Iterator;
import java.util.Map;
import processing.sound.*;
SoundFile gunShot;
SoundFile shotgunShot;
SoundFile zombieHit;
SoundFile zombie;
SoundFile zombie2;
SoundFile zombie3;
Player player;
ArrayList<Zombie> zombies;
ArrayList<Bullet> bullets;
ArrayList<Powerup> powerups;
Flower[] flowers;
boolean keyW, keyS, keyA, keyD;
boolean mPressed;
int bulTimer;
int gLevel;
int gWidth = 960;
int gHeight = 850;
int gMin = 20;
boolean gameOver;
int points;
void setup() {
  size(1000, 1000);
  points = 0;
  gameOver = false;
  mPressed = false;
  bulTimer = 0;
  gLevel = 0;
  keyA = keyS = keyW = keyD = false;
  zombies = new ArrayList<Zombie>();
  bullets = new ArrayList<Bullet>();
  powerups = new ArrayList<Powerup>();
  flowers = new Flower[15];
  player = new Player();
  for(int i =0; i < flowers.length; i++) {
    flowers[i] = new Flower(); 
  }
  gunShot = new SoundFile(this, "gun_shot.wav");
  gunShot.amp(0.2);
  shotgunShot = new SoundFile(this, "shotgun_shot.wav");
  shotgunShot.amp(0.2);
  zombieHit = new SoundFile(this, "zombie_hit.wav");
  zombie = new SoundFile(this, "zombie.wav");
  zombie2 = new SoundFile(this, "zombie2.wav");
  zombie3 = new SoundFile(this, "zombie3.wav");
  cursor(CROSS);
}

void draw() {
  background(200);
  fill(50, 150, 50);
  rect(20, 20, 960, 850);

  // Increase the level every 5 seconds
  if (frameCount % (60*5) == 0) {
    ++gLevel; 
  }
  
  // Show level
  fill(0);
  textSize(30);
  text("Level: " + gLevel, 50, gHeight + gMin + 50); 
  
  // Show points
  textSize(20);
  text("Points:", 50, gHeight + gMin + 75); 
  fill(255, 255, 0);
  text(points, 120, gHeight + gMin + 75); 

  // Show flowers
  for(int i =0; i < flowers.length; i++) {
    flowers[i].display();
  }
  
  // Show player
  player.display();
  
  // Show and move zombies towards the player
  for (int i = 0; i < zombies.size(); i++) {
    zombies.get(i).display();
    float a = atan2(player.pos.y - zombies.get(i).pos.y, player.pos.x - zombies.get(i).pos.x);
    zombies.get(i).move(new PVector(cos(a), sin(a)));
    
    // if zombie collides with player game over
    if (zombies.get(i).collidesWith(player) || gameOver) {
      gameOver = true;
      textSize(30);
      String gameOverText = "Game over. Press space to play again.";
      fill(255,0,0);
      text(gameOverText, width/2 - textWidth(gameOverText)/2, height/2);
    }
  }
  
   // Show and move bullets
  ListIterator<Bullet> bIter = bullets.listIterator();
  while (bIter.hasNext()) {
   
    // Show bullet and move it
    Obj bullet = bIter.next();
    bullet.move();
    bullet.display();
    
    // Remove bullets outside the canvas
    if (! bullet.withinCanvas()) {
      bIter.remove();
      continue;
    }
    
    // Find collisions with zombies
    ListIterator<Zombie> zIter = zombies.listIterator();
    while(zIter.hasNext()) {
      Zombie zombie = zIter.next();
      if (bullet.collidesWith(zombie)) {   
        // Remove bullet and attack zombie
        zombie.attacked();
        if (zombie.level < 1) {
          zIter.remove();     
        }
        bIter.remove();  
        break;
      }
    }
  }
  
  // Display powerups and check for collisions
  ListIterator<Powerup> pIter = powerups.listIterator();
  while (pIter.hasNext()) {
    Powerup powerup = pIter.next();
    powerup.display();
    
    // Player picks up powerup
    if (player.collidesWith(powerup)) {
      powerup.timer = 20;
      player.powerups.put(powerup.id, powerup);
      pIter.remove();
    }
    
    // Remove powerup on timer <= 0
    if (powerup.timer <= 0) {
      pIter.remove(); 
    }
    
    if (frameCount % 60 == 0) {
      powerup.timer--;      
    }
  }
  
  // Play zombie sound every 10 seconds
  if (frameCount % (60*10) == 0) {
    float random = random(1);
    if (random < 0.333) {
      zombie.play(); 
    } else if (random < 0.666) {
      zombie2.play();
    } else {
      zombie3.play();
    }
  }
  
  // Don't run after this point if game over
  if (gameOver) {
    return;
  }
  
  // Create new powerupps at increasing frequency and 3 seconds after the game starts
  if (frameCount % max(60*20 - gLevel*20, 60*5) == 0 || frameCount == 60*3) {
    float random = random(1);
    if (random < 0.25) {
      powerups.add(new Powerup("3 bullets"));
    } else if (random < 0.5)  {
      powerups.add(new Powerup("2 bullets"));      
    } else if (random < 0.75) {
      powerups.add(new Powerup("machine gun")); 
    } else {
      powerups.add(new Powerup("speed"));
    }
  }
  
  // Shoot bullets
  if (mPressed && bulTimer < 1) {
    if(player.powerups.containsKey("2 bullets") || player.powerups.containsKey("3 bullets")) {
      float a = atan2(mouseY - player.pos.y, mouseX - player.pos.x) + 0.1;
      float b = atan2(mouseY - player.pos.y, mouseX - player.pos.x) - 0.1;

      Bullet bulletA = new Bullet();
      Bullet bulletB = new Bullet();
      bulletA.pos = new PVector(player.pos.x, player.pos.y);
      bulletB.pos = new PVector(player.pos.x, player.pos.y);
      
      bulletA.move(new PVector(cos(a), sin(a)));
      bulletB.move(new PVector(cos(b), sin(b)));

      bullets.add(bulletA);
      bullets.add(bulletB);
      shotgunShot.play();
    }
    if (! player.powerups.containsKey("2 bullets") || player.powerups.containsKey("3 bullets")) {
      // Create new bullet and fire in direction of the mouse
      Bullet bullet = new Bullet();
      bullet.pos = new PVector(player.pos.x, player.pos.y);
      float a = atan2(mouseY - player.pos.y, mouseX - player.pos.x);
      bullet.move(new PVector(cos(a), sin(a)));
      bullets.add(bullet); 
    }
    
    if (!player.powerups.containsKey("2 bullets") && ! player.powerups.containsKey("3 bullets")) {
      gunShot.play(); 
    }
    
    // Set timer before another bullet can be fired
    if (player.powerups.containsKey("machine gun")) {
      bulTimer = 5; 
    } else {
      bulTimer = 15;      
    }
  } else {
    bulTimer--; 
  }
  
  // Create a new zombie
  if (frameCount % max(1, (60 - gLevel/2)) == 0) {
    int zlevel = 1;
    
    // Increase zLevel if gLevel is higher
    for (int i = 10; i < gLevel; i += 10) {
      if (random(1) > 0.5) {
        ++zlevel;         
      }
    }
    
    Zombie zombie = new Zombie(zlevel);
    zombies.add(zombie);
  }
  
  // Move player
  if (keyA) {
    player.move(new PVector(-player.speed, 0));
  }
  if (keyD) {
    player.move(new PVector(player.speed, 0));
  }
  if (keyS) {
    player.move(new PVector(0, player.speed));
  }
  if (keyW) {
    player.move(new PVector(0, -player.speed));
  }
  
  player.keepInCanvas();
}

void keyPressed() {
   if (key == 'a') {
     keyA = true; 
   }
   if (key == 'd') {
     keyD = true; 
   }
   if (key == 'w') {
     keyW = true; 
   }
   if (key == 's') {
     keyS = true; 
   }
   if (gameOver && key == ' ') {
      setup();
   }
}

void keyReleased() {
  if (key == 'a') {
     keyA = false; 
   }
   if (key == 'd') {
     keyD = false; 
   }
   if (key == 'w') {
     keyW = false; 
   }
   if (key == 's') {
     keyS = false; 
   }
}

void mousePressed() {
  mPressed = true;
}

void mouseReleased() {
 mPressed = false; 
}
