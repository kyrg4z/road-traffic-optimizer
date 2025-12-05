class Vehicle {
  // initialize width and height in child classes since they're different 
  // dimensions initialized here but set in child classes.
  float vW;
  float vH;
  
  int approachArm; // 1, 2, 3, 4 which is top, right, bottom, left. What arm vehicle approaches
  int currentLane; // Which lane it is on
  int destinationArm; // Where vehicle exits. The final destination
  
  String turnType; // just
  String state; // state of the vehicle - approaching, entering, circulating, exiting
  
  
  PVector pos; //position 
  PVector vel;
  PVector acc;
  float vRotation; 
  
  
  float vSpeed;
  float vAggression;
  float vAcceleration;
  float vDeceleration;
  float minSpeed;
  float maxSpeed;
  
  color vColor;

  boolean crash; // if the vehicle craahed
  int crashTime; // when it happened
  
  float pathProgress; // how far is it from the end.
  float angularPosition; // angle (rotation) on the roundabout.
  boolean yieldRequired; // stop for other vehicle, decelerate 
  ArrayList<PVector> currentPath;
  
  
  Vehicle(int arm, int lane, int destArm, String turn, 
          float x, float y, float accel, float decel, 
          float min, float max, float aggression, color col) {
    
    this.approachArm = arm;
    this.currentLane = lane;
    this.destinationArm = destArm;
    this.turnType = turn;
    this.state = "Approaching";
    
    this.pos = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.vRotation = arm * HALF_PI;  // Initial facing direction
    
    this.vSpeed = 0;
    this.vAggression = aggression;
    this.vAcceleration = accel;
    this.vDeceleration = decel;
    this.minSpeed = min;
    this.maxSpeed = max;
    
    this.vColor = col;
    this.crash = false;
    this.crashTime = 0;
    
    this.pathProgress = 0;
    this.angularPosition = 0;
    this.yieldRequired = false;
    this.currentPath = new ArrayList<PVector>();
  }
  
  void moveOnIntresection(){
    // if roundabout
    // direction and lane 
    
    
    // if 4 way 
    
  }
  
  void moveFromIntersection(){
    
  }
  
  void accelerate(){
    if (crash) return; // crash should be handled by method crash 
    
    // Determine target speed based on state and aggression
    float targetSpeed = getTargetSpeed();
    
    // Calculate acceleration direction (forward along heading)
    PVector accelDir = PVector.fromAngle(vRotation);
    accelDir.mult(vAcceleration);
    
    // Only accelerate if below target speed
    if (vSpeed < targetSpeed) {
      vel.add(accelDir);
    }
    
    // limit the speed
    if (vel.mag() > targetSpeed) {
      vel.setMag(targetSpeed);
    }
    
    vSpeed = vel.mag();

    //PVector dVel = PVector.mult(this.vAcceleration, 0.1);
    //this.vel.add(dVel);
    
    //PVector dPos = PVector.mult(this.vel, 0.1);
    //this.pos.add(dPos);
  }
  
  float getTargetSpeed() {
    float baseMax;
    if (vAggression > 0.7) {
        baseMax = maxSpeed;
    } else {
        baseMax = maxSpeed * 0.8;
    }
    
    switch(state) {
      case "APPROACHING":
        return baseMax;
      
      case "ENTERING":
        if (yieldRequired) {
          return 0;
        }
        return baseMax * 0.5;
      
      case "CIRCULATING":
      
        int ringLane = getRingLane(); // curved lane 
        float radius = ringRadius[ringLane];
        float maxCurveSpeed = sqrt(0.4 * radius); 
        return min(baseMax * 0.7, maxCurveSpeed);
      
      case "EXITING":
        return baseMax * 0.8;
      
      default:
        return baseMax;
    }
  }
  
  
  
  void decelerate() {
    if (vel.mag() > minSpeed) {
      // Deceleration opposite to velocity direction
      PVector decelDir = vel.copy();
      decelDir.normalize();
      decelDir.mult(-vDeceleration);
      
      vel.add(decelDir);
      
      // It shouldn't go below min speed
      if (vel.mag() < minSpeed) {
        vel.setMag(minSpeed);
      }
    }
    
    vSpeed = vel.mag();
  }
  
  float getBrakingDistance(float targetSpeed) {
    // v² = u² + 2as  →  s = (v² - u²) / 2a
    float distSq = (targetSpeed*targetSpeed - vSpeed*vSpeed) / (2 * vDeceleration);
    return max(0, distSq); // make it positive
  }
  
  
  void crashMovement() {
    
  
  }
  
  
  void updatePosition(){
    if (!crash){
      pos.add(vel);
    } 
  }
  
  void updateSpeed() {
  // Automatic speed control based on state
    float target = getTargetSpeed();
    
    if (vSpeed < target - 0.5) {
      accelerate();
    } else if (vSpeed > target + 0.5) {
      decelerate();
    }
    
    // Yield logic
    if (yieldRequired && state == "ENTERING") {
      decelerate();
    }
  }
  
  //void checkYield() {
  //  if (state != "ENTERING") {
  //    yieldRequired = false;
  //    return;
  //  }
    
  //  // Check for vehicles from the left
  //  for (Vehicle other : allVehicles) {
  //    if (other == this) continue;
      
  //    if (other.state == "CIRCULATING") {
  //      float dist = PVector.dist(pos, other.pos);
  //      if (dist < 80) {  // Within yield zone
  //        yieldRequired = true;
  //        return;
  //      }
  //    }
  //  }
  //  yieldRequired = false;
  //}
  
  void update() {
  // State machine dispatcher
  switch(state) {
    case "APPROACHING":
      moveOnApproach();
      break;
    
    case "ENTERING":
      moveOnEntrySpline();
      break;
    
    case "CIRCULATING":
      moveOnRoundabout();
      break;
    
    case "EXITING":
      moveOnExitSpline();
      break;
    
    case "DEPARTED":
      // Vehicle has left - could be removed
      break;
  }
  
  // Update physics
  updateSpeed();
  updatePosition();
  checkCollisions();  // With other vehicles
  }
  
  // void moveOnApproach() {}
  
  // void moveOnEntrySpline() {}
  
  // void moveOnRoundabout() {}
  
  // void moveOnExitSpline() {}
  
  
}

































//class Car extends Vehicle {
//  float vW;  
//  float vH; 
//  Car(float vR, float vS, float vA, float vAc, float vD, float min, float max, float vY,float vX, color vCol, boolean cr, int cTime) {
//    super(vR, vS, vA, vAc, vD, min, max, vY, vX, vCol, cr, cTime); 
//    this.vW = 30;
//    this.vH = 15;
    
//  }  
  
//  void drawCar(){
//    fill(255);
//    rect(0, 0, this.vW, this.vH);
//  }
  

//}










//class Truck extends Vehicle {
//  float vW;  
//  float vH; 
  
//  Truck(float vR, float vS, float vA, float vAc, float vD, float min, float max, float vY,float vX, color vCol, boolean cr, int cTime) {
//    super(vR, vS, vA, vAc, vD, min, max, vY, vX, vCol, cr, cTime); 
//    this.vW = 50;
//    this.vH = 25;
//  }
  
//  void drawTruck(){
//      rect(0, 0, this.vW, this.vH);
//  }
  
//  void accelerate(){
  
//  }
  
//  void deccelerate(){
  
//  }
  
//}













//class Public extends Vehicle {
//  float vW;  
//  float vH; 
  
//  Public( float vR, float vS, float vA, float vAc, float vD, float min, float max, float vY,float vX, color vCol, boolean cr, int cTime) {
//    super(vR, vS, vA, vAc, vD, min, max, vY, vX, vCol, cr, cTime); 
//    this.vW = 60;
//    this.vH = 20;
//  }
  
//  void drawPublic(){
//      rect(0, 0, this.vW, this.vH);
  
//  }
  
  
//  void accelerate(){
  
//  }
  
//  void deccelerate(){
  
//  }
  
//}
