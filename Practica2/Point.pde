public class Point {

  float x;
  float y;
  
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public float distance(Point p) {
    return sqrt(pow(p.x - this.x,2)+pow(p.y - this.y,2));
    
  }
}
