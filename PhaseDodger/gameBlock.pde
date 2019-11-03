
class gameBlock{
 color blue = color(135,206,250);
 color pink = color(255,192,203);
PVector pos; 
float w;
float h;
boolean trueBlue;
boolean empty;

public gameBlock (PVector pos, float size, boolean blockColor){
this.pos= pos; this.w = size; this.trueBlue = blockColor; this.h = size; empty = false;
//System.out.println(this.pos);
}
public gameBlock (PVector pos, float size, boolean blockColor, boolean empty){
this.pos= pos; this.w = size; this.trueBlue = blockColor; this.h = size; this.empty = empty;
}
public void drawMe(){
    
    float xoff = w/2;
    float yoff = h/2;
    if(!empty){
    //noStroke();
    if(trueBlue){
        fill(this.blue);
    }else{
        fill(this.pink);
    }
    }else{
        noStroke();
        noFill();
    }
    beginShape(QUADS);
    vertex(pos.x - xoff, pos.y + yoff, pos.z);
    vertex(pos.x + xoff, pos.y + yoff, pos.z);
    vertex(pos.x + xoff, pos.y - yoff, pos.z);
    vertex(pos.x - xoff, pos.y - yoff, pos.z); 
    endShape(); 
    
}

public void updatePos(float speed){

this.pos.set(pos.x, pos.y- speed);
}
 boolean hitTest(float x, float y) { //checks if the x, y values are in the bounds of the square.
    float xVal = pos.x;
    float yVal = pos.y;
    return (x >= xVal - w/2 && x <= xVal + w/2 && y >= yVal - h/2 && y<= yVal + h/2);
    
  }
}
