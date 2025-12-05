class TrafficLight{
  PVector pos = new PVector(X, Y);
  int direction;
  
  String state;
  float timer;
  
  // durations in seconds
  int greenDuration = 6;
  int yellowDuration = 3;
  int redDuration = 5;
  
  float lightSize;
  
  TrafficLight(PVector position, int dir) {
    pos = position;
    direction = dir;
    state = "RED";
    timer = redDuration;
  }
  
  void update(){
    // track how much time has passed. 
    
    // so it should always start as red time + yellow time + green time 
    
    timer -= 1.0 / frameRate;
    
    // Change state when timer runs out
    if (timer <= 0) {
      if (state.equals("GREEN")) {
        state = "YELLOW";
        timer = yellowDuration;
      } else if (state.equals("YELLOW")) {
        state = "RED";
        timer = redDuration;
      } else if (state.equals("RED")) {
        state = "GREEN";
        timer = greenDuration;
      }
    }
  }
  
  void drawTrafficLight() {
      translate(pos.x, pos.y);
      int m = millis();
      noStroke();
      //fill(m 255);
      //circle(25, 25, 50, 50);
   
  }
}
