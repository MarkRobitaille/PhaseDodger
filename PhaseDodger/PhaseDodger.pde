// CONSTANTS

final float playerSpeed = 0.03;
final boolean debug = false;

// Colors
color bluePhase = color(135,206,250);
color pinkPhase = color(255,192,203);

// VARIABLES

// Game settings
int gameMode; // For now default to right in the game, change once title screen is made
// Setting for phase controls
boolean phaseHold; // If true, player must hold space key to change phase
float [] gameSpeedArr = {0.014,0.016,0.017,0.018,0.019,0.02,0.0201,0.0204,0.021};
// Enemy variables
ArrayList<gameEnemy> gameEnemies;

int[] levelArray = {100, 500, 1000, 2000, 4000, 8000, 16000, 32000,64000};
blockGenerator gen;

// Player variables
PVector playerTranslation;
float playerScale;
boolean moveRight;
boolean moveLeft;
boolean moveUp;
boolean moveDown;
boolean playerPhase; // False is pink, true is blue
boolean playerAlive;
PVector hitboxPos;
float hitboxRadius;

// Player death
int deathTimer;
int deathStep;
float playerRotation;

// UI variables
int highScore;
int currentScore;
int lives;
int level;
int timer;
boolean newHighScore;
int gameOverStep;
PFont font;
PImage splashImg;
//PImage alienImg;
PImage[] enemyImgArray;
PImage[] blueShip;
PImage[] pinkShip;

 String scoreString[];
void setup() {

 //alienImg = loadImage("data/enemy.png");
  enemyImgArray = new PImage[6];
  enemyImgArray[0] = loadImage("data/enemy.png");
  enemyImgArray[1] = loadImage("data/enemy2.png");
  enemyImgArray[2] = loadImage("data/enemy3.png");
  enemyImgArray[3] = loadImage("data/enemy4.png");
  enemyImgArray[4] = loadImage("data/enemy5.png");
  enemyImgArray[5] = loadImage("data/enemy6.png");

  blueShip = new PImage[3];
  blueShip[0] = loadImage("data/playerblueleft.png");
  blueShip[1] = loadImage("data/playerblue.png");
  blueShip[2] = loadImage("data/playerblueright.png");
  pinkShip = new PImage[3];
  pinkShip[0] = loadImage("data/playerpinkleft.png");
  pinkShip[1] = loadImage("data/playerpink.png");
  pinkShip[2] = loadImage("data/playerpinkright.png");
  
  scoreString = loadStrings("highscore.txt");
   

  size(800,800, P3D);
  surface.setResizable(true); // Make it work maximized?
  ortho(-1, 1, 1, -1);
  hint(DISABLE_OPTIMIZED_STROKE);
  smooth(4);
  
  // Game state variables
  gameMode = 1;
  phaseHold = false; // Default is swap phase with space

  // Initialize UI Variables
  highScore = int(scoreString[0]);
  currentScore = 0;
  lives = 3;
  level = 1;
  //gameSpeed = level-1;
  //textMode(SHAPE); //Makes text not fuzzy
  font = loadFont("JoystixMonospace-Regular-20.vlw");
  splashImg = loadImage("SplashLogo.png");
  newHighScore = false;
  gameOverStep = 0;
  
  // Player variables
  // Set up starting player location
  playerScale = 0.1;
  // Player movement
  playerTranslation = new PVector(0.0, -0.8);
  moveRight = false;
  moveLeft = false;
  moveUp = false;
  moveDown = false;
  playerPhase = false;
  // Initialize hitbox for player
  hitboxPos = new PVector();
  hitboxPos = playerTranslation.copy();
  hitboxPos.y -= 0.025;
  hitboxRadius = playerScale/3;
  // Player Death/Life variables
  playerAlive = true;
  deathTimer = 0;
  deathStep = 0;
  playerRotation = 0.0;
  
  // Enemy variables
  gameEnemies = new ArrayList();
  gen = new blockGenerator(level + 1 , 1, -1);
}

void draw() {
  resetMatrix();
  ortho(-1, 1, 1, -1);
  background(0,0,0);
  if (width>height) {
    scale((float)height/(float)width, 1);
  }else {
    scale(1, (float)width/(float)height);
  }
  
  fill(255,255,255);
  rect(-1, -1, 2, 2);
  
  if (gameMode == 0) { // Playing game
    if (playerAlive) {
      noStroke();
      gen.run(gameSpeedArr[level-1]);
      currentScore += gen.getBlockScore();
      changeLevel();
      
      // Update entities
      updatePlayer();
      addEnemy();
      updateEnemies();
      
      // CHECK FOR COLLISIONS
  
      // Find player's hitbox details (hitbox is circle) 
      hitboxPos = playerTranslation.copy();
      hitboxPos.y -= 0.025;
      
      boolean hit = false; 
      
      // Check for collisions against enemies
      hit = checkEnemyCollisions(hitboxPos, hitboxRadius);
  
      // Check for collisions against blocks
      for (int i=0; i<gen.blockList.size() && !hit; i++) {
        gameBlock currBlock = gen.blockList.get(i);
        hit = checkHitRect(hitboxPos, hitboxRadius, currBlock.pos, currBlock.w, currBlock.h, currBlock.trueBlue,currBlock.empty);
      }
      
      playerAlive = !hit;
      
      // Draw things here
      drawEnemies();
      
      stroke(0);
      drawPlayer();
      
      // If player is dead, pause block movement, player turns red, lose life, start again?
      if (!playerAlive) {
        deathTimer=millis();
      }
      
      // Draw UI last
      resetMatrix();
      if (width>height) {
        scale((float)height/(float)width, 1);
      }else {
        scale(1, (float)width/(float)height);
      }
      drawUI();
    } else if (deathStep == 0) {
      playerRotation+=0.2;
      noStroke();
      gen.drawBlocks();
      drawEnemies();
      stroke(0);
      drawPlayer();
      resetMatrix();
      if (width>height) {
        scale((float)height/(float)width, 1);
      }else {
        scale(1, (float)width/(float)height);
      }
      drawUI();
      if (deathTimer + 2000 < millis()) {
        if (lives-1 <= 0) {
          resetAfterDeath();
          gameMode = 4;
          timer = millis();
          newHighScore = currentScore > highScore;
          if(newHighScore){
            scoreString[0] = Integer.toString(currentScore);
            saveStrings("data/highScore.txt", scoreString);
          }
        } else {
          deathTimer=millis();
          deathStep++;
        }
      }
    } else if (deathStep == 1) {
      drawUI();
      if (deathTimer + 4000 < millis()) {
        resetAfterDeath();
      } 
    }
  } else if (gameMode == 1) { // Main menu
    ortho(-400,400,400,-400);
  //  if (width>height) {
  //  scale((float)height/(float)width, 1);
  //}else {
  //  scale(1, (float)width/(float)height);
  //}
    scale(1,-1);
    fill(0);
    textFont(font, 20);
    textAlign(LEFT);
    imageMode(CORNER);
    image(splashImg, -300, -200);

    text("HIGHSCORE: " + highScore, floor(-textWidth("HIGHSCORE" + highScore)/2 + 0.5), -360);
    text("PHASE TYPE", floor(-textWidth("PHASE TYPE")/2 + 0.5), 100);
    text("SWAP", -150, 200);
    text("HOLD", 150-textWidth("HOLD"), 200);
    text("PRESS SPACE TO START", floor(-textWidth("PRESS SPACE TO START")/2 + 0.5), 300);

    strokeWeight(2);
    if (phaseHold) {
      line(150-textWidth("HOLD"), 210, 150, 210);
    } else {
      line(-150, 210, textWidth("SWAP")-150, 210);
    }
    strokeWeight(1);
  } else if (gameMode == 2) { // pause screen
    noStroke();
    gen.drawBlocks();
    drawEnemies();
    stroke(0);
    drawPlayer();
    drawUI();
  } else if (gameMode == 4) { // Game over screen
    if (gameOverStep == 0) {
      drawUI();
      if (timer + 1000 < millis()) {
        gameOverStep += 1;
        timer = millis();
      }
    } else {
      drawUI();
    }
  }
}

// Return true if player's circular hitbox overlapped with rectangle
boolean checkHitRect(PVector playerPos, float playerRadius, PVector rectPos, float rectWidth, float rectHeight, boolean trueBlue,boolean empty) {
  boolean hit = true;
  
  float distX = Math.abs(playerPos.x - rectPos.x);
  float distY = Math.abs(playerPos.y - rectPos.y);
  if(empty){
    //block is empty
    hit =false;
  }else if (distX > (playerRadius + rectWidth/2) || distY > (playerRadius + rectHeight/2)) {
    // Player is safely out of range
    hit = false;
  }else if(playerPhase == trueBlue){
    //player matches the color
    hit = false;
  }
 
  return hit;
}
  
void keyPressed() {
  if (gameMode == 0) { // Playing game
    if (key == CODED) { // Arrow keys
      switch(keyCode) {
        case LEFT:
          moveLeft = true;
          break;
        case RIGHT:
          moveRight = true;
          break;
        case UP:
          if (debug) {
            moveUp = true;
          }
          break;
        case DOWN:
          if (debug) {
            moveUp = true;
          }
          break;
      }
    } else { // WASD keys and space bar
      switch(key) {
        case 'a':
          moveLeft = true;
          break;
        case 'd':
          moveRight = true;
          break;
        case 'w':
          if (debug) {
            moveUp = true;
          }
          break;
        case 's':
          if (debug) {
            moveDown = true;
          }
          break;
        case ' ':
          if (phaseHold) {
            playerPhase = true;
          } else {
            playerPhase = !playerPhase;
          }
          break;
        case 'p':
          gameMode = 2;
          break;
        case 'm':
          lives -= 1;
          break;
      }
    }
  } else if (gameMode == 1) { // Main menu
    if (key == CODED) { // Arrow keys
      switch(keyCode) {
        case LEFT:
          phaseHold = false;
          break;
        case RIGHT:
          phaseHold = true;
          break;
      }
    } else { // WASD keys and space bar
      switch(key) {
        case 'a':
          phaseHold = false;
          break;
        case 'd':
          phaseHold = true;
          break;
        case ' ':
          gameMode = 0;
          break;
      }
    }
  } else if (gameMode == 2) { //paused
    switch(key) {
      case 'p':
        gameMode = 0;
        break;
      case ' ':
        gameMode = 0;
        break;
    }

  } else if (gameMode == 4) { // Game over screen
    if (gameOverStep == 4) { //if we're currently incrementing the score onscreen
      highScore = currentScore;
      gameOverStep += 1;
    } else if (gameOverStep >= 5 || (gameOverStep >= 2 && !newHighScore)) { //if we're past the score going up stage
      resetGame();
    } else { 
      gameOverStep += 1;
    }
  }
}

void keyReleased() {
  if (gameMode == 0) { // Playing game
    if (key == CODED) { // Arrow keys
      switch(keyCode) {
        case LEFT:
          moveLeft = false;
          break;
        case RIGHT:
          moveRight = false;
          break;
        case UP:
          if (debug) {
            moveUp = false;
          }
          break;
        case DOWN:
          if (debug) {
            moveDown = false;
          }
          break;
      }
    } else { // WASD keys and space bar
      switch(key) {
        case 'a':
          //playerTranslation.x -=0.01;
          moveLeft = false;
          break;
        case 'd':
          //playerTranslation.x +=0.01;
          moveRight = false;
          break;
        case 'w':
          if (debug) {
            moveUp = false;
          }
          break;
        case 's':
          if (debug) {
            moveDown = false;
          }
          break;
        case ' ':
          if (phaseHold) {
            playerPhase = false;
          }
          break;
      }
    }
  } else if (gameMode == 1) { // Main menu
  
  } else { // Game over screen
    
  }
}

void updatePlayer() {
  if (moveLeft && !moveRight && playerTranslation.x - playerSpeed>=-1 + playerScale) { // Moving left
    playerTranslation.x -= playerSpeed;
  } else if (moveRight && !moveLeft && playerTranslation.x + playerSpeed <=1 - playerScale) { // Moving right
    playerTranslation.x += playerSpeed;
  }
  
  if (debug) {
    if (moveUp && !moveDown && playerTranslation.y + playerSpeed <=1 - playerScale) { // Moving left
      playerTranslation.y += playerSpeed;
    } else if (moveDown && !moveUp && playerTranslation.y - playerSpeed>=-1 + playerScale) { // Moving right
      playerTranslation.y -= playerSpeed;
    }
  }
}

void drawPlayer() {
  // Translate to player location, draw player, resetMatrix at the end
  
  translate(playerTranslation.x, playerTranslation.y);
  rotate(playerRotation);
  scale(playerScale, playerScale);
  
  imageMode(CENTER);
  if (playerPhase) { // (playerPhase && playerAlive) { // Then in else have red ship?
    if ((moveLeft && moveRight) || (!moveLeft && !moveRight) || !playerAlive) { // Not moving left or right
      image(blueShip[1], 0, 0, 2, 2);
    } else if (moveLeft) { // Moving left
      image(blueShip[0], 0, 0, 2, 2);
    } else { // Moving right
      image(blueShip[2], 0, 0, 2, 2);
    }
  } else {
    if ((moveLeft && moveRight) || (!moveLeft && !moveRight) || !playerAlive) { // Not moving left or right
      image(pinkShip[1], 0, 0, 2, 2);
    } else if (moveLeft) { // Moving left
      image(pinkShip[0], 0, 0, 2, 2);
    } else { // Moving right
      image(pinkShip[2], 0, 0, 2, 2);
    }
  }
  
  //if(!playerAlive) {
  //  fill(255,0,0);
  //}
  
  resetMatrix();
  strokeWeight(1);
  if (debug) {
    fill(0);
    ellipse(hitboxPos.x, hitboxPos.y, hitboxRadius*2, hitboxRadius*2);
  }
}

void resetAfterDeath() {
  playerRotation=0.0;
  deathTimer=0;
  deathStep=0;
  lives--;
  playerAlive=true;
  gen.clearBlocks();
  gameEnemies.clear();
}

public void changeLevel(){
  if(level < levelArray.length){
  if(currentScore >= levelArray[level -1]){
    gen.levelOver = true;
  }
  }
  if(gen.nextLevel()){
    level++;
    gen.levelOver = false;
    gen = new blockGenerator(level+1, 1,-1) ;
}
}

// ENEMY METHODS

void addEnemy() {
  
  // Find level value
  int levelValue = 0; // if less than 5 levels
  if (level>=10 && level<20) {
    levelValue = 1;
  } else if (level>=30) {
    levelValue = 2;
  }
  
  //System.out.println(levelValue);
  
  if (gameEnemies.size()<levelValue+1 && Math.random()>0.985-(5*levelValue)) {
    PVector startLocation = new PVector((float)Math.random()*2.0-1.0,  1.25);
    int alienIndex = int(random(enemyImgArray.length));
    gameEnemies.add(new gameEnemy(startLocation, playerTranslation, enemyImgArray[alienIndex])); 
  }
}

void updateEnemies() {
  for (int i=0; i<gameEnemies.size(); i++) {
    gameEnemy currEnemy = gameEnemies.get(i);
    currEnemy.update(0.0065);
    if (currEnemy.isOffScreen() || currEnemy.hitPlayer) {
      gameEnemies.remove(currEnemy);
      currentScore+=20;
    }
  }
}

void drawEnemies() {
  for (int i=0; i<gameEnemies.size(); i++) {
    gameEnemies.get(i).drawMe(debug);
  }
}

boolean checkEnemyCollisions(PVector playerPos, float playerRadius) {
  boolean hit = false;
  for (int i=0; i<gameEnemies.size() && !hit; i++) {
    gameEnemy currEnemy = gameEnemies.get(i);
    if (currEnemy.checkCircleCollision(playerPos,playerRadius)) {
      hit = true;
    }
  }
  return hit;
}
  
// UI METHODS

void drawUI() {
  ortho(-400,400,400,-400);
  //if (width>height) {
  //  scale((float)height/(float)width, 1);
  //}else {
  //  scale(1, (float)width/(float)height);
  //}
  scale(1, -1); //Flip it 
  fill(0);
  textFont(font, 20);
  textAlign(LEFT);

  if (gameMode == 0 || gameMode == 2 || (gameMode == 4 && gameOverStep == 0)) {
    //For the high score and current score, we want the number of digits to be constant so we figure out how many digits they are and then add the required number of zeroes to the front
    String hsString = new Integer(highScore).toString(); 
    int hsLen = hsString.length();
    for (int i = 0; i < 6 - hsLen; i++) {
      hsString = "0" + hsString;
    }

    text("HighScore: " + hsString, -380, -360);

    String csString = new Integer(currentScore).toString();
    int csLen = csString.length();
    for (int i = 0; i < 6 - csLen; i++) {
      csString = "0" + csString;
    }
    text("Score: " + csString, 380-textWidth("Score: " + csString), -360);

    text("LEVEL " + level, floor(-textWidth("LEVEL " + 1)/2 + 0.5), -360);

    PImage lifeImage;
    if (playerPhase) {
     lifeImage = blueShip[1];
    } else {
     lifeImage = pinkShip[1];
    }
    
    int shipSize = 20;
    int padding = 10;
    
    scale(1, -1);
    
    int totalLength = ((lives-1) * (shipSize+padding)) - padding;
    if (lives > 0) { //Assuming we have more than one life at the moment, let's draw the icons for them
      for (int i = 0; i < lives-1; i++) {
        image(lifeImage, (-totalLength/2 + shipSize/2) + (i*(padding + shipSize)), 330, 20, 20);
        
        //triangle((-totalLength/2 + shipSize/2) + (i*(padding + shipSize)), -340, //coords for point one (top)
        //-totalLength/2 + (i*(padding + shipSize)), -320, //coords for bottom left
        //(-totalLength/2 + shipSize) + (i*(padding + shipSize)),-320); //coords for bottom right
      }
    }
    
    scale(1, -1);

    // If you want 

    //if (playerPhase) {
    // fill(bluePhase);
    //} else {
    // fill(pinkPhase);
    //}

    //int triWidth = 20;
    //int triHeight = 20;
    //int padding = 10;
    //int totalLength = ((lives-1) * (triWidth+padding)) - padding;
    //if (lives > 0) { //Assuming we have more than one life at the moment, let's draw the icons for them
    //  for (int i = 0; i < lives-1; i++) {
    //    triangle((-totalLength/2 + triWidth/2) + (i*(padding + triWidth)), -340, //coords for point one (top)
    //    -totalLength/2 + (i*(padding + triWidth)), -320, //coords for bottom left
    //    (-totalLength/2 + triWidth) + (i*(padding + triWidth)),-320); //coords for bottom right
    //  }
    //}

    fill(0);
    
    if (deathStep==1 && lives!=2) {
      text((lives-1)+" LIVES REMAINING", floor(-textWidth("_ LIVES REMAINING")/2 + 0.5), 0);
    } else if (deathStep==1) {
      text((lives-1)+" LIFE REMAINING", floor(-textWidth("_ LIFE REMAINING")/2 + 0.5), 0);
    } if (gameMode == 2 && second()%2 == 0) { //if we're paused, flash pause in the middle of the screen
      text("PAUSED", floor(-textWidth("PAUSED")/2 + 0.5), 0);
    }
  } else { //GAME OVER
    fill(255, 0, 0);
    text("GAME OVER", floor(-textWidth("GAME OVER")/2 + 0.5), -100);
    fill(0);
    if (gameOverStep == 1 && timer + 1000 < millis()) {
      gameOverStep += 1;
      timer = millis();
    }
    if (gameOverStep >= 2) {
      text("YOUR SCORE: " + currentScore, floor(-textWidth("YOUR SCORE: " + currentScore)/2 + 0.5), 0);
      if (gameOverStep == 2 && timer + 1000 < millis() && newHighScore) {
        gameOverStep +=1;
        timer = millis();
      }
    }
    if (gameOverStep >= 3 && newHighScore) {
      text("NEW HIGHSCORE!", floor(-textWidth("NEW HIGHSCORE!")/2 + 0.5), 100);
      if (gameOverStep == 3 && timer + 1000 < millis()) {
        gameOverStep += 1;
        timer = millis();
      }
    }
    if (gameOverStep == 4 && newHighScore) {
      if (highScore < currentScore) {
        highScore += 1;
      } else {
        gameOverStep += 1;
      }
    }
    if (gameOverStep >= 4 && newHighScore) {
      String scoreString = new Integer(highScore).toString(); 
      int scoreLen = scoreString.length();
      for (int i = 0; i < 6 - scoreLen; i++) {
        scoreString = "0" + scoreString;
      }

      text(scoreString, floor(-textWidth(scoreString)/2 + 0.5), 200);
    }
    
    text("PRESS SPACE TO CONTINUE", floor(-textWidth("PRESS SPACE TO CONTINUE")/2 + 0.5), 300);
  } 
}

void resetGame() {
  gen = new blockGenerator(2, 1, -1);
  gameMode = 1; 

  currentScore = 0;
  lives = 3;
  level = 1;

  newHighScore = false;
  gameOverStep = 0;
  
  // Player variables
  // Set up starting player location
  playerScale = 0.1;
  // Player movement
  playerTranslation = new PVector(0.0, -0.8);
  moveRight = false;
  moveLeft = false;
  moveUp = false;
  moveDown = false;
  playerPhase = false; 
  playerAlive = true;
  
  // Enemy variables
  gameEnemies = new ArrayList();
}
