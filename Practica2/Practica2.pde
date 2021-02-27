PShape figure;

ArrayList<Point> pointList;
Point3D[][] finalForm;

boolean showSolidOfRevolution, intro = true;
PShape revolutionObject;

float incRotationAngle = 5;
float maxRotationAngle = 360;

int xObjectPosition = 0, yObjectPosition = 0;
int yObjectOffset;

PFont f;

Boolean mouseClick = false;

void setup() {
  size(800,800,P3D);
  
  reset();
  yObjectOffset = height/2;
  drawIntro();
}

void draw() {
  if (!intro) {
    if (mouseClick) mouseClick();
    background(0);
    if (showSolidOfRevolution) {
    revolutionObject.translate(mouseX-xObjectPosition, (mouseY-yObjectOffset)-yObjectPosition);// mouseY-height/2);
    xObjectPosition+=mouseX-xObjectPosition;
    yObjectPosition+=(mouseY-yObjectOffset)-yObjectPosition;
    shape(revolutionObject);
    } else {
      line(width/2,0,width/2,height);
      if (pointList.size() != 0) 
        drawPerfilPoints();
    }
  }
  
}

// Ventana de inicio
void drawIntro() {
  intro = true;
  background(0);
  textAlign(CENTER);
  f = createFont("Arial",62,true); 
  textFont(f);
  text("Solidos de revolución",width/2,height/8); 
  
  textAlign(CENTER);
  f = createFont("Arial",28,true); 
  textFont(f);
  text("Controles",width/2,height/3.8); 
  textAlign(LEFT);
  f = createFont("Arial",24, true); 
  textFont(f);
  text("Teclas:",width/20,height/3);
  f = createFont("Arial",20, true); 
  textFont(f);
  text("Enter:     Se crea la figura",width/20,height/2.4);
  text("R/r:        Resetea el juego",width/20,height/2.18);  
  text("D/d:        Borra último punto añadido",width/20,height/2);  

  textAlign(CENTER);
  f = createFont("Arial",28,true); 
  textFont(f);
  text("Utilización",width/2,height/1.7); 
  f = createFont("Arial",18,true); 
  textFont(f);
  text("Pulsa con el ratón a la izquierda del eje central para definir el perfil de la figura\n (Se deben definir un mínimo de 2 puntos)",width/2,height/1.5); 
  
  
  textAlign(CENTER);
  f = createFont("Arial",16,true); 
  textFont(f);
  text("Pulsa enter para jugar",width/2,height/1.25); 
}

void drawNewPoint() {
  if (pointList.size()>1) {
    Point p1 = pointList.get(pointList.size()-2);
    Point p2 = pointList.get(pointList.size()-1);
    
    line(p1.x,p1.y,p2.x,p2.y);
  } 
  // Si es la primera dibujamos solo un punto
  else {
    Point p1 = pointList.get(pointList.size()-1);
    point(p1.x,p1.y);
  }
}

void create_figure() {
  
  finalForm = new Point3D[pointList.size()][(int) (maxRotationAngle/incRotationAngle)];
  
  for (int angle = 0; angle<maxRotationAngle; angle+=incRotationAngle) {
    for(int pointIndex = 0; pointIndex < pointList.size(); pointIndex++) {
      Point p = pointList.get(pointIndex);
      float x1 = p.x - width/2; // Consideramos el eje de rotación en la mitad de la pantalla 
      float y1 = p.y;
      float z1 = 0;
      
      finalForm[pointIndex][(int) (angle/incRotationAngle)] = new Point3D(
                                  (x1* cos(radians(angle)) - z1*sin(radians(angle))),
                                  y1,
                                  (x1* sin(radians(angle)) - z1*cos(radians(angle))));
    }
  }
  
  draw_solid_revolution();
}

void draw_solid_revolution() {
  showSolidOfRevolution = true;
  
  revolutionObject = createShape();
  revolutionObject.beginShape(TRIANGLES);
  
  revolutionObject.fill(255);
  revolutionObject.stroke(80,0,160);
  revolutionObject.strokeWeight(2);

  createVertex();

  revolutionObject.endShape();  
  
  xObjectPosition = mouseX; 
  yObjectPosition = mouseY-height/2;
  
  revolutionObject.translate(xObjectPosition,yObjectPosition);
  
  yObjectOffset = (getHighestPoint() + getLowestPoint())/2;
}


// Metodos para encontrar el valor más alto/bajo de Y. Como siempre rotamos el eje Y con mirar el array sin rotas sería suficiente
int getHighestPoint() {
  int highest = -1;
  for (Point p: pointList) {
    if (p.y > highest) highest = (int) p.y;
  }
  return highest;
}

int getLowestPoint() {
  int lowest = height+1;
  for (Point p: pointList) {
    if (p.y < lowest) lowest = (int) p.y;
  }
  return lowest;
}

// Creamos la malla de triangulos
void createVertex() {
  int numberOfPoints = pointList.size();
  int numberOfRotations = (int) (maxRotationAngle/incRotationAngle);
  
  // Creamos los triangulos entre los puntos de una capa con su capa inferior
  for (int i = 0; i<numberOfPoints-1; i++) {
    for (int j = 0; j<numberOfRotations; j++) {
      Point3D p1 = finalForm[i][j];
      Point3D p2 = finalForm[i][(j+1) % numberOfRotations];
      Point3D p3 = finalForm[i+1][j];
      revolutionObject.vertex(p1.x, p1.y, p1.z);
      revolutionObject.vertex(p2.x, p2.y, p2.z);
      revolutionObject.vertex(p3.x, p3.y, p3.z);
    }
  }
  
  // Creamos los triangulos entre los puntos de una capa con su capa superior
  for (int i = 1; i<numberOfPoints; i++) {
    for (int j = 0; j<numberOfRotations; j++) {
      Point3D p1 = finalForm[i][j];
      Point3D p2 = finalForm[i][(j+1) % numberOfRotations];
      Point3D p3 = finalForm[i-1][(j+1) % numberOfRotations];
      revolutionObject.vertex(p1.x, p1.y, p1.z);
      revolutionObject.vertex(p2.x, p2.y, p2.z);
      revolutionObject.vertex(p3.x, p3.y, p3.z);
    }
  }
  
  // Creamos los triangulos entre los puntos de la capa inferior con el origen
  Point3D p3 = new Point3D(0,finalForm[numberOfPoints-1][0].y,0);
  for (int j = 0; j<numberOfRotations; j++) {
    Point3D p1 = finalForm[numberOfPoints-1][j];
    Point3D p2 = finalForm[numberOfPoints-1][(j+1) % numberOfRotations];
    revolutionObject.vertex(p1.x, p1.y, p1.z);
    revolutionObject.vertex(p2.x, p2.y, p2.z);
    revolutionObject.vertex(p3.x, p3.y, p3.z);
  }
  
  // Creamos los triangulos entre los puntos de la capa superior con el origen
  p3 = new Point3D(0,finalForm[0][0].y,0);
  for (int j = 0; j<numberOfRotations; j++) {
    Point3D p1 = finalForm[0][j];
    Point3D p2 = finalForm[0][(j+1) % numberOfRotations];
    revolutionObject.vertex(p1.x, p1.y, p1.z);
    revolutionObject.vertex(p2.x, p2.y, p2.z);
    revolutionObject.vertex(p3.x, p3.y, p3.z);
  }
}

// Limpiamos la pantalla
void reset() {
  showSolidOfRevolution = false;
  pointList = new ArrayList<Point>();
  
  background(0);

  stroke(255,255,255,100);
  strokeWeight(2);  
  
  
  drawIntro();
}

void mouseReleased() {
  mouseClick = false;
}
void mousePressed() {
  mouseClick = true;
}

// Añadimos más puntos a la figura
void mouseClick() {
  if (!intro && !showSolidOfRevolution && mouseX>=width/2) {
    Point tmp = new Point(mouseX, mouseY);
    // Añadimos el punto si la distancia con el anterior es de más de 15
    if (pointList.size() == 0 || tmp.distance(pointList.get(pointList.size()-1)) > 15) {
      pointList.add(tmp);
      drawNewPoint();
    }
  }
}

// Borramos el último punto
void deleteLastPoint() {
  if (!showSolidOfRevolution && pointList.size() > 0) {
    pointList.remove(pointList.size()-1);
    background(0);
    line(width/2,0,width/2,height);
    if (pointList.size() != 0) drawPerfilPoints();
  }
}

// Método para dibujar los puntos del perfil
void drawPerfilPoints() {
  Point p = pointList.get(0);
  
  for (int i = 1; i<pointList.size(); i++) {
    Point aux = pointList.get(i);
    line(p.x,p.y, aux.x, aux.y);
    p = aux;
  }
}

// Controlamos las que se pulsan
void keyPressed() {
  
  if (keyCode == ENTER) {
    // Start Game
    if (intro) intro = false;
    // Create figure
    else if (pointList.size()>1) create_figure();
  } 
  
  // Reset
  else if (!intro && (key == 'r' || key == 'R')) {
    reset();
  }
  
  // Delete last point
  else if (!intro && (key == 'd' || key == 'D')) {
    deleteLastPoint();
  }
}
