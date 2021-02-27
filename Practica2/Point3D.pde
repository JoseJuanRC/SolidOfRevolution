public class Point3D extends Point{
  float z;
  
  public Point3D(float x, float y, float z) {
    super(x,y);
    this.z = z;
  }
  
  public String toString() { return "X: " + this.x + " Y: " + this.y + " Z: " + this.z + "\n";}
}
