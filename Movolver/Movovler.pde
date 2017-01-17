//Sam Nosenzo
//12/3/16
//Final Project for Visual Thinking w/ Aaron Henderson

import geomerative.*;
ArrayList<Mover> movs;
RFont font;
String[] saying = {"NEVER", "STOP", "CHANGING", "EVOLVE"};
String SampleText = "EVOLVE";
RPoint[] pts;
float xtext, ytext;

PVector crowdav;
PVector targav;
PVector initialav;
float initialdist = 0;
float moversize = 15;
int cycle = 0;
int textsize = 250;
int changeCounter = 0;;
int resetCounter = 150;

void setup(){
  //size(800, 800);
  fullScreen();
  //background(223,37, 11);
  background(30);
  movs = new ArrayList<Mover>();
  createTextPoints();
  targav = new PVector();
  for(int i = 0; i < pts.length; i++){
    PVector targ = new PVector(width/2 + pts[i].x, height/2 + pts[i].y);
    targav.add(targ);
    Mover m = new Mover(width/2, 200, moversize, targ);
    movs.add(m);  
  }
  
  targav.x = targav.x / pts.length;
  targav.y = targav.y / pts.length;
  
  /*for(int i = 0; i < pts.length; i++){
    Mover m = new Mover(width/2, 200, moversize, new PVector(width/2 + pts[i].x, height/2 + pts[i].y));
    movs.add(m);  
  }*/
  xtext = width/2;
  ytext = height/2;
  
  crowdav = new PVector();
  initialav = new PVector(width/2, 200);
  initialdist = PVector.sub(targav, initialav).mag();
  
}


void draw(){
  //background(223, 37, 11);
  noStroke();
  fill(70,3);
  rect(0, 0, width, height);
  
  fill(prim[cycle%prim.length], 40);
  //noFill();
  
  beginShape(POLYGON);
  float currcrowdx = 0;
  float currcrowdy = 0;
  for(int i = 0; i < movs.size(); i++){
    Mover m = movs.get(i);
    currcrowdx+=m.loc.x;
    currcrowdy+=m.loc.y;
    m.update();
    m.display();
    /*if(i > 0){
      
    }*/
    curveVertex(m.loc.x, m.loc.y);
  }
  
  //noStroke();
  strokeWeight(1);
  float d = PVector.sub(targav, crowdav).mag();
  float mapping = map(d, 0, initialdist, 255, 0);
  stroke(mapping, 100);
  //stroke(sec1[(cycle+3)%sec1.length]);
  //noStroke();
  endShape();
  
  currcrowdx = currcrowdx / movs.size();
  currcrowdy = currcrowdy / movs.size();
  crowdav.x = currcrowdx;
  crowdav.y = currcrowdy;
  /*
  fill(255, 0, 0);
  ellipse(crowdav.x, crowdav.y, 20, 20);
  fill(0, 255, 0);
  ellipse(targav.x, targav.y, 20, 20);
  
  pushMatrix();
  translate(xtext, ytext);
  for(int i = 0; i < pts.length; i++){
    //ellipse(pts[i].x, pts[i].y, 3, 3);  
  }
  popMatrix();*/
  if( d < 2.5){
    changeCounter++;
    if(changeCounter == resetCounter){
      createTextPoints();
      setTargets(random(textsize, width-textsize), random(textsize/2, height));
      changeCounter = 0;
      //saveFrame("evolve" + random(10, 20) + ".png");
    }
    if(changeCounter == resetCounter/2){
      
    }
  } else if (d < 400){
    if(random(1) < .03){
      //saveFrame("evolve" + random(10) + ".png");
    }
  }
    
  
}

void createTextPoints(){
  RG.init(this);
  font = new RFont("Helvetica.ttf", textsize, RFont.CENTER);
  RCommand.setSegmentLength(15);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  
  if(saying[cycle%4].length() > 0) {
    RGroup grp;
    grp = font.toGroup(saying[cycle%4]);
    pts = grp.getPoints();
  }
  if(!movs.isEmpty()){
    ArrayList<Mover> temp = new ArrayList<Mover>();
    
    if(pts.length > movs.size()){
      for(int i = movs.size(); i < pts.length; i++){
        Mover m = new Mover(xtext, ytext, moversize, new PVector());
        movs.add(m);
      }
    } else if(pts.length < movs.size()){
      for(int i = movs.size()-1; i >= pts.length; i--){
        movs.remove(i);
      }
    }
  }
    //movs.clear();
  
  cycle++;
  
}

void setTargets(float x, float y){
  xtext = x;
  ytext = y;
  initialav = targav;
  targav = new PVector(0, 0);
  for(int i = 0; i < pts.length; i++){
    Mover m = movs.get(i);
    PVector targ = new PVector(x + pts[i].x, y + pts[i].y);
    targav.add(targ);
    m.setTarget(targ);
  }
  targav.x = targav.x / pts.length;
  targav.y = targav.y / pts.length;
}

void keyPressed(){
  if(key == 'c'){
    //if(cycle < 4){
      createTextPoints();
      setTargets(random(textsize, width-textsize), random(textsize/2, height+100));
    //}
    //else {
      //setTargets(random(textsize*2, width-textsize*2), random(textsize/2, height-textsize/2));
      //cycle++;
    //}
  }
}