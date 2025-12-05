import g4p_controls.*;

int numLanes = 5;  // abc + de = 5 lanes total

// Baseline values
float laneWBase = 14;
float R_ringBase = 170;

float scaleF = 1.5;   // Magnification factor: 1.5 -> 50% larger

float laneW;          // Actual lane width (calculated in setup based on scaleF)
float R_ring;         // Actual center radius of the roundabout

float approachLength = 300; // Approach road length

float roadHalfWidth;
float[] ringRadius;         // The radius of the 4 roundabout lanes

void setup() {
  size(1200, 900);
  smooth(4);
  createGUI();

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
}


// Draw 4 approaches (top, bottom, left, and right).
void drawApproaches() {
  for (int arm=0; arm<4; arm++) {
    drawOneApproach(arm);
  }
}

void drawOneApproach(int arm) {
  float ang = arm * HALF_PI;
  PVector u = new PVector(cos(ang), sin(ang));    // Radial vector
  PVector t = new PVector(-sin(ang), cos(ang));   // Tangential vector
  
  float distApproach = roadHalfWidth * 2;

  float r0 = R_ring + distApproach + approachLength;
  float r1 = R_ring + distApproach;

  // Draw 6 boundaries (5 lanes -> 6 edge lines)
  stroke(255);
  strokeWeight(2);
  for (int i=0; i<=5; i++) {
    float off = -roadHalfWidth + i*laneW;
    drawLineAlong(u, t, r0, r1, off);
  }

  // Draw dashed lines in the center of each lane (the spacing scales with the lane width).
  stroke(255,160);
  strokeWeight(1);
  for (int i=0; i<5; i++) {
    float off = -roadHalfWidth + (i+0.5)*laneW;
    drawDashed(u, t, r0, r1, off);
  }
}

void drawLineAlong(PVector u, PVector t, float r0, float r1, float off) {
  PVector A = new PVector(u.x*r0 + t.x*off, u.y*r0 + t.y*off);
  PVector B = new PVector(u.x*r1 + t.x*off, u.y*r1 + t.y*off);
  line(A.x, A.y, B.x, B.y);
}

void drawDashed(PVector u, PVector t, float r0, float r1, float off) {
  // Make the spacing of the dashed lines correlate with the lane width
  float dashSpacing = laneW;       // Interval between each dash
  float dashLen = laneW * 0.5;     // Length of each dash
  for (float r = r0; r > r1; r -= dashSpacing) {
    float r2 = max(r - dashLen, r1);
    PVector A = new PVector(u.x*r + t.x*off, u.y*r + t.y*off);
    PVector B = new PVector(u.x*r2 + t.x*off, u.y*r2 + t.y*off);
    line(A.x, A.y, B.x, B.y);
  }
}


// Roundabout (4 lanes) boundary + center dashed line
void drawRoundabout() {
  // Draw roundabout (4 lanes) boundary
  noFill();
  stroke(200);
  strokeWeight(2);

  float outer = ringRadius[3] + laneW/2;
  float inner = ringRadius[0] - laneW/2;

  for (float r = inner; r <= outer+0.1; r += laneW) {
    ellipse(0, 0, r*2, r*2);
  }

  // The lane center dashed lines (4 lanes) are drawn in finer, continuous segments.
  stroke(255,180);
  strokeWeight(1);
  for (int i=0; i<4; i++) {
    float r = ringRadius[i];
    for (float th=0; th<TWO_PI; th+=0.09) {
      float th2 = th + 0.045;
      line(r*cos(th), r*sin(th), r*cos(th2), r*sin(th2));
    }
  }
}

// Draw lane lines in all four directions.
void drawAllEntrySplines() {
  // Draw the right side (original direction, 0 degrees).
  drawRightEntrySplines();
  
  // Draw the diagram below (rotated 90 degrees clockwise).
  pushMatrix();
  rotate(HALF_PI); // Rotate 90 degrees
  drawRightEntrySplines();
  popMatrix();
  
  // Draw the left side (rotated 180 degrees clockwise).
  pushMatrix();
  rotate(PI);
  drawRightEntrySplines();
  popMatrix();
  
  // Draw the top (rotated 270 degrees clockwise).
  pushMatrix();
  rotate(PI + HALF_PI);
  drawRightEntrySplines();
  popMatrix();
}

// The original function draws the lane lines on the right.
void drawRightEntrySplines() {
  // Left lane (closest to the center)
  noFill();
  stroke(255, 0, 0);
  strokeWeight(2);
  beginShape();
  curveVertex(400, 0);
  curveVertex(380, 0);
  curveVertex(290, -3);
  curveVertex(230, -20);
  curveVertex(201, -70);
  curveVertex(201, -70);
  endShape();
  beginShape();
  curveVertex(400, 0 - laneW/2);
  curveVertex(380, 0 - laneW/2);
  curveVertex(290, -3 - laneW/2);
  curveVertex(235, -20 - laneW/2);
  curveVertex(210, -76);
  curveVertex(210, -76);
  endShape();
  beginShape();
  curveVertex(400, 0 - laneW);
  curveVertex(380, 0 - laneW);
  curveVertex(290, -3 - laneW);
  curveVertex(240, -20 - laneW);
  curveVertex(219, -83);
  curveVertex(219, -83);
  endShape();
  
  // Middle lane (go straight forward)
  beginShape();
  curveVertex(400, 0 - laneW * 1.5);
  curveVertex(380, 0 - laneW * 1.5);
  curveVertex(290, -3 - laneW * 1.5);
  curveVertex(246, -20 - laneW * 1.5);
  curveVertex(227.5, -92);
  curveVertex(227.5, -92);
  endShape();
  beginShape();
  curveVertex(400, 0 - laneW * 2);
  curveVertex(380, 0 - laneW * 2);
  curveVertex(290, -3 - laneW * 2);
  curveVertex(252, -20 - laneW * 2);
  curveVertex(236, -98);
  curveVertex(236, -98);
  endShape();
  
  // Right lane (turn right)
  beginShape();
  curveVertex(400, 0 - laneW * 2);
  curveVertex(380, 0 - laneW * 2);
  curveVertex(330, -3 - laneW * 2);
  curveVertex(280, -20 - laneW * 2);
  curveVertex(257, -100);
  curveVertex(257, -100);
  endShape();
  beginShape();
  curveVertex(400, 0 - laneW * 2.5);
  curveVertex(380, 0 - laneW * 2.5);
  curveVertex(330, -3 - laneW * 2.5);
  curveVertex(285, -20 - laneW * 2.5);
  curveVertex(265, -108);
  curveVertex(265, -108);
  endShape();
  beginShape();
  curveVertex(400, 0 - laneW * 3);
  curveVertex(380, 0 - laneW * 3);
  curveVertex(330, -3 - laneW * 3);
  curveVertex(290, -20 - laneW * 3);
  curveVertex(273, -118);
  curveVertex(273, -118);
  endShape();
}

void mousePressed() {
  // Print the coordinates of the mouse click
  println("Mouse clicked at: " + mouseX + ", " + mouseY + "  (button: " + mouseButton + ")");
}
