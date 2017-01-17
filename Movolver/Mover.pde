
//slightly based off of the vehicle class in the Nature of code
//tooking the seek function and added a noise function and a few modifications
//and the update function too i guess

//essentially what it does is it creates an object that starts at a location and noisely
//steers itself to its target location
//The display function makes the size of the root based on it's distance from the point


class Mover{
  
  //initialization of variable
  PVector loc, vel, acc;
  //stores the path. was going to do something with this
  //could just run a while loop and have it appear at once
  //but I like watching it grow
  ArrayList<PVector> path;
  //This list allows the roots to have smaller offshoots of the same object essentially
  PVector targ;
  //start of the noise function
  float nx = random(200000); 
  //current size and initial size are stored
  float size, initSize;
  float maxspeed = 3;
  float maxforce = 2;
  float id;
  float noisestart;
  float currdist;
  
  
  Mover(float x, float y, float sz, PVector tgt){
    loc = new PVector(x, y);
    vel = new PVector();
    acc = new PVector();
    size = sz;
    targ = tgt.copy();
    initSize = sz;
    path = new ArrayList<PVector>();
    
    //randomizes the noise function a bit more
    noisestart = random(0, TWO_PI);
    //initial distance from point
    id = dist(loc.x, loc.y, targ.x, targ.y);
  }
  
  void update(){
    //always seeks the target if the distance from it is greater than 10
    ///if(dist(loc.x, loc.y, targ.x, targ.y) > 10){
    if(dist(loc.x, loc.y, targ.x, targ.y) > 3){

      seek(targ);
    }
    //physics stuff
    vel.add(acc);
    vel.limit(maxspeed);
    loc.add(vel);
    path.add(loc);
    acc.mult(0);
  }
  
  void display(){
    //display offshoots (if any)
    //display main root  
    strokeWeight(size);
    float strke = 0;
    strke =  map(currdist, 0, id, 255, 0);
    stroke(comp[(cycle+cycle-1)%sec2.length]);
    
    point(loc.x, loc.y);
  }
  
  void applyForce(PVector force){
    acc.add(force);
  }
  void setTarget(PVector target){
    targ = target;
    id = dist(loc.x, loc.y, targ.x, targ.y);
    
  }
    
  
  void seek(PVector target){
    PVector desired = PVector.sub(target, loc);
    //store current distance
    
    float d = desired.mag();
    currdist = d;
    //map size of the root to the distance
    size = map(d, 0, id, 0, initSize);
    desired.normalize();

    /*if (d < 20) {
      float m = map(d,0,100,0,maxspeed);
      desired.setMag(m);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxforce);
      applyForce(steer);
      return;
    } else {*/
      desired.setMag(maxspeed);
    //} //scale vector to maxspeed;
    //get current direction of target
    float angle = target.heading();
    //add noise to the angle
    angle+=map(noise(nx), 0, 1, -noisestart, TWO_PI-noisestart);
    PVector steer = PVector.sub(desired, vel); //Reynolds formula for steering force
    //create force vector from the noise angle and give it a little strength
    PVector offset = PVector.fromAngle(angle);
    offset.mult(2);
    //add the noise vector to the original steering vector
    steer.add(offset);
    steer.limit(maxforce);
    
    
    applyForce(steer); //apply the force as the object acceleration
    nx+=.5;
  }
  
}