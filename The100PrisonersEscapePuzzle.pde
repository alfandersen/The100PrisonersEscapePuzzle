/*
Rules: 100 Prisoners Escape Puzzle
  http://datagenetics.com/blog/december42014/index.html
  
Inspiration: The Demonetization Game
  https://www.youtube.com/watch?v=kOnEEeHZp94
  
Author: Alf Andersen
  https://github.com/alfandersen
  
About:
  Prisoners are numbered 0-99 and their numbers are randomly randomly added to the 100 boxes.
  Each prisoner starts by picking the box of their own number.
  If they don't find their own number inside they pick the box with the number that was found.
  This repeats until they find their own number.
  When a prisoner finds themself, then a loop is formed (because their number would point back the to box they first picked).
  
  The game is won if the longest loop contains 50 or less opened boxes, 
  hence all prisoners found their own number by opening 50 or less boxes.
  
  The diagram shows a counter of the longest loop in each game.
  
  It is expected that 
    "31.18% of the time, the length of the maximum chains formed will be less than 50 boxes
    and so every prisoner will be able to find his ticket before hitting the 50 box limit."
    - http://datagenetics.com/blog/december42014/index.html
*/

int boxCount = 100;
int speedMultiplier = 100;

IntList boxes = new IntList();
int[] maxLoopCounter = new int[boxCount];

int gamesPlayed = 0;
int gamesWon = 0;

color bgColor = color(15,30,45);
color winColor = color(100,255,100);
color loseColor = color(255,100,100);

void setup() {
  size(1600,800);
  for(int prisoner = 0; prisoner < boxCount; prisoner++){
    boxes.append(prisoner);
  }
  strokeWeight(8); //<>//
}

void draw() {
  playRounds(speedMultiplier);
  paintDiagram();
  showStats();
}

void playRounds(int rounds) {
  for(int round = 0; round < rounds; round++) {
    playSingle();
  }
}

void playSingle(){
  boxes.shuffle();
  int maxLoop = 0;
  for(int prisoner = 0; prisoner < boxes.size(); prisoner++) {
    int next = boxes.get(prisoner);
    int opened = 1;
    while(next != prisoner) {
      next = boxes.get(next);
      opened++;
    }
    maxLoop = opened > maxLoop? opened : maxLoop;
  }
  maxLoopCounter[maxLoop-1]++;
  gamesPlayed++;
  gamesWon += maxLoop <= boxCount/2 ? 1 : 0; 
}

void paintDiagram() {
  background(bgColor);
  textSize(12);
  for(int i = 0; i < maxLoopCounter.length; i++) {
    stroke(maxLoopCounter[i] > 0 ? i < boxCount/2 ? winColor : loseColor : bgColor);
    line((i+.5)*width/boxCount, height, (i+.5)*width/boxCount, height-maxLoopCounter[i]);
    text(""+(i+1), (i+.5)*width/boxCount-10, height-maxLoopCounter[i] - 10);
    
    if(maxLoopCounter[i] > height - 50) {
      noLoop();
    }
  }
}

void showStats(){
  textSize(20);
  text(String.format("Games Played: %6d", gamesPlayed), 20, 40);
  text(String.format("Games Won   : %6d", gamesWon),    20, 70);
  text(String.format("Win Ratio      : %6.2f %s", (100.*gamesWon)/gamesPlayed, "%"), 20, 100);
}
