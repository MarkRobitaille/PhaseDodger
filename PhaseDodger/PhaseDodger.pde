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
float gameSpeed;
float level;

// Player variables
PVector[] playerPiece;
PVector playerTranslation;
float playerScale;

boolean moveRight;
boolean moveLeft;
boolean playerPhase; // False is pink, true is blue
boolean playerAlive;


void setup() {

  size(800, 800, P3D);
  //surface.setResizable(true); // Make it work maximized?
  ortho(-1, 1, 1, -1);
  
  // Game state variables
  gameMode = 0; // CHANGE TO 1 (TITLE SCREEN) ONCE IMPLEMENTED
  phaseHold = false; // Default is swap phase with space
  
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
  playerPhase = false; 
  playerAlive = true;
}

void draw() {
  resetMatrix();
  ortho(-1, 1, 1, -1);
  background(255,255,255);
  
  if (gameMode == 0) { // Playing game
    // Process things here
    updatePlayer();
    
    // CHECK FOR COLLISIONS
    
    //// Find player's hitbox details (hitbox is circle) 
    //PVector hitboxPos = new PVector();
    //hitbox = playerTranslation.copy();
    //hitbox.y -= 0.025;
    //float hitboxRadius = playerScale/2;
    
    //boolean hit = false; 
    
    //for (int i=0; i<gameBlocks.size() && !hit; i++) {
    //  hit = checkHitRect(hitboxPos, hitboxRadius, gameBlocks.get().pos, gameBlocks.get().w, gameBlocks.get().h);
    //}
    
    //playerAlive = !hit;
    
    // Draw things here
    
    drawPlayer();
    
    // If player is dead, pause block movement, player turns red, lose life, start again?
    
    // Draw UI last
    
    
    // Update score (count and remove blocks off screen)
    
  } else if (gameMode == 1) { // Main menu
  
  } else { // Game over screen
    
  }
}

// Return true if player's circular hitbox overlapped with rectangle
boolean checkHitRect(PVector playerPos, float playerRadius, PVector rectPos, float rectWidth, float rectHeight) {
  boolean hit = true;
  
  float distX = Math.abs(playerPos.x - rectPos.x);
  float distY = Math.abs(playerPos.y - rectPos.y);
  
  if (distX > (playerRadius + rectWidth/2) || distY > (playerRadius + rectHeight/2)) {
    // Player is safely out of range
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
      }
    } else { // WASD keys and space bar
      switch(key) {
        case 'a':
          moveLeft = true;
          break;
        case 'd':
          moveRight = true;
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
