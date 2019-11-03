
class blockGenerator{
    float top;
    ArrayList<gameBlock> blockList;
    ArrayList<ArrayList<gameBlock>> largeList;
    boolean levelOver = false;
    float bottom;
    float[] lanes;
    float numLanes;
    int blockScore;
public blockGenerator(float numLanes, float top, float bottom){
    //largeList = new ArrayList();
    this.lanes = new float[int(numLanes)];
     blockList = new ArrayList();

    this.bottom = bottom;
    this.top= top -(1/numLanes);
    this.numLanes= numLanes;
    float laneCentre = (-1 - (1/numLanes));
    laneCentre += 2/numLanes;
    for (int i = 0; i < numLanes; i++) {
        this.lanes[i] = laneCentre;
        laneCentre += (2 / numLanes);
      
    }

}
public boolean nextLevel(){
  return levelOver && blockList.size() <=0;
   
  }
  
 
public void drawBlocks(boolean playerPhase){
    for (int i = 0; i< blockList.size(); i++) {
        blockList.get(i).drawMe(playerPhase);
    }
}
public void run(float speed, boolean playerPhase){
  if(!levelOver){
    fillArray();
  }
  updateBlockPos(speed);
  drawBlocks(playerPhase);
  cleanUpArrayList();
}
public void fillArray(){
  
  if(blockList.size()< numLanes*10){
      this.generate();
  }
}

private void generate(){
if(blockList.size()<=0){
  
    for (int i= 0; i< lanes.length; i++){

    PVector newPos = new PVector(lanes[i], top);
    
    int c = int(random(0,2));
    boolean trueBlue = (c == 0);
  
    gameBlock newBlock = new gameBlock(newPos, 2/numLanes, trueBlue); 
    blockList.add(newBlock);
    gameBlock voidBlock = new gameBlock(new PVector(newBlock.pos.x, newBlock.pos.y+ 2/numLanes), 
                                          newBlock.w, newBlock.trueBlue, true);
    blockList.add(voidBlock);
    
    }
}else{
  
    gameBlock prev = blockList.get(blockList.size()-1);
     float y = prev.pos.y + (prev.h);
    for (int i= 0; i< lanes.length; i++){
    PVector newPos = new PVector(lanes[i], y);
    
    int c = int(random(0,2));
    boolean trueBlue = (c == 0);
  
    gameBlock newBlock = new gameBlock(newPos, 2/numLanes, trueBlue); 
    blockList.add(newBlock);
    gameBlock voidBlock = new gameBlock(new PVector(newBlock.pos.x, newBlock.pos.y+ 2/numLanes), 
                                          newBlock.w, newBlock.trueBlue, true);
    blockList.add(voidBlock);
    
    }
}
}

public void updateBlockPos(float speed){
    for (int i = 0; i < blockList.size(); i++) {
        blockList.get(i).updatePos(speed);
    }
}
public void cleanUpArrayList(){
    for (int i = 0; i < blockList.size(); i++) {
           if(blockList.get(i).pos.y+ blockList.get(i).h/2  <= bottom){ 
             if(!blockList.get(i).empty){
             blockScore += 10;
             }
             blockList.remove(i);
             i--;
           }
    }
}
public int getBlockScore(){
  int out = blockScore;
  blockScore = 0;
  return out;
}

  public void clearBlocks() {
    blockList.clear();
  }
}
