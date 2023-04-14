import processing.data.TableRow;

Table dataset;
int graphMargin = 50;
float maxValue;
String title = "Time series";
HashMap<String, Float> dataPoints = new HashMap<String, Float>();

void setup() {
  size(800, 600);
  dataset = loadTable("/Users/badaramoniavinash/Downloads/BarGraphProject.csv.csv", "header");
  maxValue = 0.0;
  for (TableRow row : dataset.rows()) 
  {
    String date = row.getString("Date");
    float value = row.getFloat("Daily minimum temperatures");
    maxValue = max(maxValue, value);
    dataPoints.put(date, value);
  }
}

void draw() {
  background(255);
  textAlign(CENTER, CENTER);
  textSize(12);
  
  drawAxisLabels();
  drawTickMarks();
  drawBars();
  drawTitle();
  handleInteraction();
}

void drawAxisLabels() {
  // X-axis label
  textSize(12);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Date", width / 2, height - graphMargin / 2);

  // Y-axis label
  pushMatrix();
  translate(graphMargin / 2, height / 2);
  rotate(-PI / 2);
  text("Daily minimum temperatures", 0, 0);
  popMatrix();
}

void drawTickMarks() {
  int numTicks = dataPoints.size();
  float xTickSpacing = (width - 2 * graphMargin) / (float) numTicks;
  float yTickSpacing = (height - 2 * graphMargin) / 5.0;

  textSize(10);
  textAlign(CENTER, CENTER);

  int tickCounter = 0;
  for (String date : dataPoints.keySet()) {
    float x = graphMargin + tickCounter * xTickSpacing;
    float y = height - graphMargin;

    // X-axis tick marks
    stroke(0);
    line(x, y, x, y + 5);
    fill(0);
    text(date, x, y + 10);

    if (tickCounter < 5) {
      // Y-axis tick marks
      float tickValue = maxValue * (5 - tickCounter) / 5;
      y = graphMargin + tickCounter * yTickSpacing;
      x = graphMargin;

      stroke(0);
      line(x, y, x - 5, y);
      fill(0);
      textAlign(RIGHT, CENTER);
      text(nf(tickValue, 0, 1), x - 10, y);
    }

    tickCounter++;
  }
}

void drawBars() {
  int numBars = dataPoints.size();
  float barWidth = (width - 2 * graphMargin) / (float) numBars - 1;

  fill(66, 134, 244);
  noStroke();
  int barCounter = 0;
  for (String date : dataPoints.keySet()) {
    float value = dataPoints.get(date);
    float barHeight = (height - 2 * graphMargin) * value / maxValue;
        float x = graphMargin + barCounter * (barWidth + 1);
    float y = height - graphMargin - barHeight;

    rect(x, y, barWidth, barHeight);
    barCounter++;
  }
}

void drawTitle() {
  textSize(16);
  fill(0);
  textAlign(CENTER, CENTER);
  text(title, width / 2, graphMargin / 2);
}

void handleInteraction() {
  int numBars = dataPoints.size();
  float barWidth = (width - 2 * graphMargin) / (float) numBars - 1;

  int barCounter = 0;
  for (String date : dataPoints.keySet()) {
    float x = graphMargin + barCounter * (barWidth + 1);
    float value = dataPoints.get(date);
    float barHeight = (height - 2 * graphMargin) * value / maxValue;
    float y = height - graphMargin - barHeight;

    if (mouseX >= x && mouseX <= x + barWidth && mouseY >= y && mouseY <= height - graphMargin) {
      fill(255);
      textAlign(CENTER, BOTTOM);
      text(nf(value, 0, 1), x + barWidth / 2, y - 5);
      break;
    }
    barCounter++;
  }
}
