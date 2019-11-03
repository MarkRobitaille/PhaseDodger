final static float enemySize = 0.25;

public class gameEnemy {
  PVector start;
  PVector current;
  PVector goal;
  float progress;
  boolean hitPlayer;
  PImage alienTex;
  
  public gameEnemy(PVector startLocation, PVector playerLocation, PImage img) {
    start = startLocation;
    current = new PVector();
    current = start.copy();
    goal = new PVector(); // To avoid always pointing to the player's location
    goal = playerLocation.copy();
    goal.x *= 1.3;
    goal.y *= 1.3;
    progress=0;
    hitPlayer = false;
    alienTex = img;
  }
  
  public void update(float enemySpeed) {
    progress+=enemySpeed;
    //System.out.println(current);
    //System.out.println(start);
    //System.out.println(goal);
    current.x = lerp(start.x, goal.x, progress);
    current.y = lerp(start.y, goal.y, progress);
    //System.out.println(current);
  }
  
  public void hitPlayer() {
    hitPlayer = true;
  }
  
  public void drawMe() {
    stroke(116,71,105);
    imageMode(CENTER);
    image(alienTex, current.x, current.y,enemySize, enemySize);
    
    stroke(0);
  }
  
  public boolean isOffScreen() {
    if (current.y + enemySize/2 < -1) {
      return true;
    }
    return false;
  }
  
  public boolean checkCircleCollision(PVector playerPos, float playerRadius) {
    boolean hit = false;
    
    if (Math.sqrt(Math.pow(playerPos.x - current.x,2) + Math.pow(playerPos.y - current.y,2))< playerRadius + enemySize/2) {
      //System.out.println("Player position: " + playerPos.x + ", " + playerPos.y);
      //System.out.println("Enemy position: " + current.x + ", " + current.y);
      hit = true;
      hitPlayer = true;
    }
    return hit;
  }
}
