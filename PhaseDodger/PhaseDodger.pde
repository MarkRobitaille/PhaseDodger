// CONSTANTS

final float playerSpeed = 0.03;
final boolean debug = true;

// Colors
color bluePhase = color(135,206,250);
color pinkPhase = color(255,192,203);

// VARIABLES

// Game settings
int gameMode; // For now default to right in the game, change once title screen is made
// Setting for phase controls
boolean phaseHold; // If true, player must hold space key to change phase
float gameSpeed;

// Player variables
PVector[] playerPiece;
PVector playerTranslation;
float playerScale;
boolean moveRight;
boolean moveLeft;
boolean moveUp;
boolean moveDown;
boolean playerPhase; // False is pink, true is blue
boolean playerAlive;


// UI variables
int highScore;
int currentScore;
int lives;
int level;
PFont font;
PImage splashImg;
blockGenerator gen;
void setup() {
  gen = new blockGenerator(8, 1, -1);
  size(600, 600, P3D);
  //surface.setResizable(true); // Make it work maximized?
  ortho(-1, 1, 1, -1);
  
  // Game state variables
  gameMode = 1; // CHANGE TO 1 (TITLE SCREEN) ONCE IMPLEMENTED
  phaseHold = false; // Default is swap phase with space

  // Initialize UI Variables
  highScore = 100;
  currentScore = 0;
  lives = 3;
  level = 1;
  textMode(SHAPE); //Makes text not fuzzy
  font = loadFont("JoystixMonospace-Regular-20.vlw");
  splashImg = loadImage("SplashLogo.png");
  
  // Player variables
  // Set up starting player location
  playerPiece = new PVector[3];
  playerPiece[0] = new PVector(0,1);
  playerPiece[1] = new PVector(-1,-1);
  playerPiece[2] = new PVector(1,-1);
  playerScale = 0.1;
  // Player movement
  playerTranslation = new PVector(0.0, -0.8);
  moveRight = false;
  moveLeft = false;
  moveUp = false;
  moveDown = false;
  playerPhase = false; 
  playerAlive = true;
}

void draw() {
  resetMatrix();
  ortho(-1, 1, 1, -1);
  background(255,255,255);
  
  if (gameMode == 0) { // Playing game
    gen.run(0.01);
    updatePlayer();
    
     //CHECK FOR COLLISIONS
    
    // Find player's hitbox details (hitbox is circle) 
    PVector hitboxPos = new PVector();
    hitboxPos = playerTranslation.copy();
    hitboxPos.y -= 0.025;
    float hitboxRadius = playerScale/2;
    
    boolean hit = false; 
    
    for (int i=0; i<gen.blockList.size() && !hit; i++) {
      gameBlock currBlock = gen.blockList.get(i);
      hit = checkHitRect(hitboxPos, hitboxRadius, currBlock.pos, currBlock.w, currBlock.h, currBlock.trueBlue,currBlock.empty);
    }
    
    playerAlive = !hit;
    
    // Draw things here
    stroke(0);
    drawPlayer();
    
    // If player is dead, pause block movement, player turns red, lose life, start again?
    
    // Draw UI last
    
    
    // Update score (count and remove blocks off screen)
    
    drawUI();
  noStroke();
  } else if (gameMode == 1) { // Main menu
    ortho(-400,400,400,-400);
    scale(1,-1);
    fill(0);
    textFont(font, 20);
    textAlign(LEFT);
    image(splashImg, -300, -200);

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
  } else { // Game over screen
    
  }
}

// Return true if player's circular hitbox overlapped with rectangle
boolean checkHitRect(PVector playerPos, float playerRadius, PVector rectPos, float rectWidth, float rectHeight, boolean trueBlue,boolean empty) {
  boolean hit = true;
  
  float distX = Math.abs(playerPos.x - rectPos.x);
  float distY = Math.abs(playerPos.y - rectPos.y);
  if(empty){
    hit =false;
  }else if (distX > (playerRadius + rectWidth/2) || distY > (playerRadius + rectHeight/2)) {
    // Player is safely out of range
    hit = false;
  }else if(playerPhase == trueBlue){
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
  } else { // Game over screen
    
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
            moveUp = false;
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
  scale(playerScale, playerScale);
  strokeWeight(1/playerScale);
  if (playerPhase) {
    fill(bluePhase);
  } else {
    fill(pinkPhase);
  }
  
  if(!playerAlive) {
    fill(255,0,0);
  }
  
  triangle(playerPiece[0].x, playerPiece[0].y, 
  playerPiece[1].x, playerPiece[1].y, 
  playerPiece[2].x, playerPiece[2].y);

  strokeWeight(1);
  resetMatrix();
  
  if (debug) {
    ellipse(playerTranslation.x, playerTranslation.y-0.025, 0.1, 0.1);
  }
}

void drawUI() {
  ortho(-400,400,400,-400);
  scale(1, -1); //Flip it 
  fill(0);
  textFont(font, 20);
  textAlign(LEFT);

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

  noStroke();
  if (playerPhase) {
   fill(bluePhase);
  } else {
   fill(pinkPhase);
  }

  int triWidth = 20;
  int triHeight = 20;
  int padding = 10;
  int totalLength = (lives * (triWidth+padding)) - padding;
  if (lives > 0) { //Assuming we have more than one life at the moment, let's draw the icons for them
    for (int i = 0; i < lives; i++) {
      triangle((-totalLength/2 + triWidth/2) + (i*(padding + triWidth)), -340, //coords for point one (top)
      -totalLength/2 + (i*(padding + triWidth)), -320, //coords for bottom left
      (-totalLength/2 + triWidth) + (i*(padding + triWidth)),-320); //coords for bottom right
    }
  }
  stroke(0);
}
