import java.util.Calendar;

float radius = 1;
float addRadius = 0.007; //線と線の間隔（数字が小さいと狭い）
float thickness = 10; //線の太さ
PVector[] vertex = {};
PVector center;
float[] hRad, hAng;
float tr;
int vc = 0;
int vc2 = 0;
int rotNum;

//色
color bgcol = #92A8D1; //背景色
color col = #F7CAC9; //線の色

void setup() {
  frameRate(360);
  size(800, 800);
  background(bgcol);
  noStroke();

  center = new PVector(width/2, height/2);

  //ハートの頂点を配列に代入
  float lowy = 0;
  float highy = center.y;
  for (float ang = 0; ang < 360-1; ang+=0.5) {
    float theta = radians(ang);
    float x = center.x + 16 * sin(theta) * sin(theta) * sin(theta);
    float y = center.y + (-1) * (13 * cos(theta) - 5 * cos(2 * theta) -2 * cos(3*theta) - cos(4*theta));
    vertex = (PVector[])append(vertex, new PVector(x, y));
    if (ang == 180) {  //ハートの一番低いy位置
      lowy = y;
    }
    if (y < highy) { //ハートの一番高いy位置
      highy = y;
    }
  }

  //配列に入れたハートの頂点のradius, angleを計算
  PVector hcenter = calcMidPoint(center.x, lowy, center.x, highy); //ハートの中心点を計算
  hRad = new float[vertex.length];
  hAng = new float[vertex.length];
  for (int i = 0; i < vertex.length; i++) {
    hAng[i] = atan2(vertex[i].y - hcenter.y, vertex[i].x - hcenter.x);
    hRad[i] = (vertex[i].y - hcenter.y) / sin(hAng[i]);
  }
  tr = hcenter.y - center.y;

  //ハートを何周描くか
  rotNum = vertex.length * 4 + vertex.length/2; //4周半
}

void draw() {
  translate(0, tr);

  if (vc2 < rotNum) {
    vc = vc%vertex.length;

    float hx = center.x + ((hRad[vc]*radius) * cos(hAng[vc]));
    float hy = center.y + ((hRad[vc]*radius) * sin(hAng[vc]));

    fill(col);
    ellipse(hx, hy, thickness, thickness);

    radius += addRadius;
    vc += 1;
    vc2 += 1;
    
  }
}

//辺の中点を計算する
PVector calcMidPoint(float end1x, float end1y, float end2x, float end2y) {
  float mx, my;
  if (end1x > end2x) {
    mx = end2x + ((end1x - end2x)/2);
  } else {
    mx = end1x + ((end2x - end1x)/2);
  }
  if (end1y > end2y) {
    my = end2y + ((end1y - end2y)/2);
  } else {
    my = end1y + ((end2y - end1y)/2);
  }
  PVector cMP = new PVector(mx, my);
  return cMP;
}

void keyPressed() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.png");
  if (key == ' '){ //redraw
    fill(bgcol);
    rect(0, 0, width, height);
    vc = 0;
    vc2 = 0;
    radius = 1;
  }
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
