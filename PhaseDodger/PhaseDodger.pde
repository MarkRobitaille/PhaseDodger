// Game mode
int gameMode; // For now default to right in the game, change once title screen is made
// Setting for phase controls
boolean phaseHold; // If true, player must hold space key to change phase

// Player variables
PVector[] playerPiece;
PVector playerTranslation;
boolean moveRight;
boolean moveLeft;
boolean playerPhase; // False is pink, true is blue

// Colors
color bluePhase = color(135,206,250);
color pinkPhase = color(255,192,203);

// UI variables
int highScore;
int currentScore;
int lives;

void setup() {

  size(800, 800, P3D);
  //surface.setResizable(true); // Make it work maximized?
  ortho(-1, 1, 1, -1);
  
  // Game state variables
  gameMode = 0; // CHANGE TO 1 (TITLE SCREEN) ONCE IMPLEMENTED
  phaseHold = false; // Default is swap phase with space

  // Initialize UI Variables
  highScore = 0;
  currentScore = 0;
  lives = 3;
  textMode(SHAPE); //Makes text not fuzzy
  
  // Player variables
  // Set up starting player location
  playerPiece = new PVector[3];
  playerPiece[0] = new PVector(0,1);
  playerPiece[1] = new PVector(-1,-1);
  playerPiece[2] = new PVector(1,-1);
  // Player movement
  playerTranslation = new PVector(0, -0.8);
  moveRight = false;
  moveLeft = false;
  playerPhase = false; 
}

void draw() {
  resetMatrix();
  ortho(-1, 1, 1, -1);
  background(255,255,255);
  
  if (gameMode == 0) { // Playing game
    // Process things here
    updatePlayer();
    
    // Draw things here
    drawPlayer();
    
    // Draw UI last
    drawUI();
    
  } else if (gameMode == 1) { // Main menu
  
  } else { // Game over screen
    
  }

  
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
  if (moveLeft && !moveRight) { // Moving left
    playerTranslation.x -=0.01;
  } else if (moveRight && !moveLeft) { // Moving right
    playerTranslation.x +=0.01;
  }
}

void drawPlayer() {
  // Translate to player location, draw player, resetMatrix at the end
  translate(playerTranslation.x, playerTranslation.y);
  scale(0.1, 0.1);
  strokeWeight(10);
  if (playerPhase) {
    fill(bluePhase);
  } else {
    fill(pinkPhase);
  }
  
  triangle(playerPiece[0].x, playerPiece[0].y, 
  playerPiece[1].x, playerPiece[1].y, 
  playerPiece[2].x, playerPiece[2].y);
  
  strokeWeight(1);
  resetMatrix();
}

void drawUI() {
  scale(0.005, 0.005); //Scale UI down from the default (1,1) so it fits on screen
  scale(1, -1); //Flip it 
  fill(0);
  textAlign(LEFT);
  text("High Score: " + highScore, -190, -180);
  text("Score: " + currentScore, 120, -180);
  textAlign(CENTER);
  text("LEVEL 1", 0, -180);
  if (playerPhase) {
   fill(bluePhase);
  } else {
   fill(pinkPhase);
  }
  if (lives > 0) { //Assuming we have more than one life at the moment, let's draw the icons for them
    for (int i = 0; i < lives; i++) {
      triangle(-25 + (i*15), -170, -30 + (i*15), -160, -20 + (i*15), -160); //little player-life triangles offset by i
    }
  }
}