import java.awt.Robot;
Robot rbt;

//color pallette
color black = #000000;
color white = #FFFFFF;
color dullBlue = #7092BE;

//map variables
int gridSize;
PImage map;

//textures
PImage mossyStone;
PImage sand;

boolean skipFrame;

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ;
float leftRightHeadAngle, upDownHeadAngle;

void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 9*height/10;
  eyeZ = height/2;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  upX = 0;
  upY = 1;
  upZ = 0;
  leftRightHeadAngle = radians(90);
  noCursor();
  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  map = loadImage("map.png");
  gridSize = 100;

  mossyStone = loadImage("Mossy_Stone_Bricks.png");
  sand = loadImage("Sand.png");
  textureMode(NORMAL);
}

void draw() {
  background(0);
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);
  drawFloor(-2000, 2000, height, gridSize); //floor
  drawFloor(-2000, 2000, height-gridSize*4, gridSize); //ceiling
  drawMap();
  drawFocalPoint();
  controlCamera();
}

void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, sand, gap);
    x += gap;
    if (x >= end) {
      x = start;
      z += gap;
    }
  }
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == dullBlue) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, mossyStone, gridSize);
      }
      if (c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, sand, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, sand, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, sand, gridSize);
      }
    }
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void controlCamera() {
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);
  if (wkey) {
    eyeX += cos(leftRightHeadAngle)*10;
    eyeZ += sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX -= cos(leftRightHeadAngle)*10;
    eyeZ -= sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX -= cos(leftRightHeadAngle + PI/2)*10;
    eyeZ -= sin(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyeX -= cos(leftRightHeadAngle - PI/2)*10;
    eyeZ -= sin(leftRightHeadAngle - PI/2)*10;
  }

  if (skipFrame == false) {
    leftRightHeadAngle += (mouseX - pmouseX)*0.01;
    upDownHeadAngle += (mouseY - pmouseY)*0.01;
  }
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;

  if (mouseX > width-2) {
    rbt.mouseMove(3, mouseY);
    skipFrame = true;
  } else if (mouseX < 2) {
    rbt.mouseMove(width-3, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false ;
  }
}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
