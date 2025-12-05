float highWaySpeedLimit = 50;
ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();

void setup() {
  size(1200, 900);
  smooth(4);

  // Apply magnification
  laneW = laneWBase * scaleF;
  R_ring = R_ringBase * scaleF;

  roadHalfWidth = laneW * 6 / 2.0;

  // Roundabout 4-lane radius: inner -> outer
  ringRadius = new float[4];
  for (int i=0; i<4; i++) {
    ringRadius[i] = R_ring + (i - 1.5) * laneW;  // Lane 1 is the innermost lane, and Lane 4 is the outermost lane.
  }
}

void draw() {
  background(25);
  translate(width/2, height/2);

  drawApproaches();
  drawRoundabout();
  drawAllEntrySplines();

  
  // Update and display all vehicles

}
