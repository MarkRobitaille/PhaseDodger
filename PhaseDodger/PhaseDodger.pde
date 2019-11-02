void setup() {

  size(800, 800, P3D);
  //surface.setResizable(true);
  ortho(-1, 1, 1, -1);
}

void draw() {
  resetMatrix();
  ortho(-1, 1, 1, -1);
  background(255,255,255);
  
  
}
