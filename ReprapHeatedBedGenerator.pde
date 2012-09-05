


boolean record;
int h=880;//height of PCB in mm
int w=900;//width of PCB in mm
int heatWidth=810; //width of heated section
int heatHeight=810; //height of heated section
float linewidth=8; //width of traces in mm - increase this to decrease resistance, and vice versa
float traceSpacing = 3;
float jump = linewidth*4+traceSpacing*4; //traces are 1/4 this distance apart vertically - increase this to decrease resistance, and vice versa. also, thicker traces need a larger value here
float offset = linewidth+traceSpacing; //this is the side to side offset to keep the traces apart on the left and right sides. increase this when thick traces get too close together
float voltage = 24.0f; //supply voltage. used to calculate current and power draw


float copperWeight = 1; //oz/sqft. used for calculating resistance and power/current draw

int viewPadding=100; //extra pixels for the view in Processing, to keep it clean. Probably leave this at 100
float totalDistance=0; //this is used to calculate the distance of the traces. leave at zero.

XML xml;
XML signal1;
XML outline;

void setup() {
size(w+viewPadding,h+viewPadding,P3D);
smooth();

  
   xml = loadXML("board.xml");
 //  println(xml.getName());
   
   signal1 = xml.getChild("drawing/board/signals/signal");
   
   outline = xml.getChild("drawing/board/plain");
   translate(viewPadding/2,viewPadding/2);
   beginShape();
   makeWire(0,0,w,0,linewidth,20,outline);
   makeWire(w,0,w,h,linewidth,20,outline);
   makeWire(w,h,0,h,linewidth,20,outline);
   makeWire(0,h,0,0,linewidth,20,outline);
   endShape(); 
   
   float thing = heatHeight%jump;
   println(thing);
   //jump+=thing/(heatHeight/jump);
   
   totalDistance=0; //we want to ignore the distance from the outline of the board
   
  // println(signal1.getString("name"));
   
   noLoop();
  
} 


float makeWire(float X1, float Y1, float X2, float Y2, float lineWidth, int layer, XML parent)
{
  vertex(X1,h-Y1); //Processing and Eagle have inverted vertical axes, so we flip the view in processing in the Y direction
  vertex(X2,h-Y2);
  //String xmlString = "<wire x1=\""+X1+"\" y1=\""+Y1+"\" x2=\""+X2+"\" y2=\""+Y2+"\" width=\""+linewidth+"\" layer=\""+layer+"\"/>";
 // println(xmlString);
  XML wire = new XML("wire");
  wire.setFloat("x1",X1);
  wire.setFloat("y1",Y1);
  wire.setFloat("x2",X2);
  wire.setFloat("y2",Y2);
  wire.setFloat("width",linewidth);
  wire.setInt("layer",layer);
  
  parent.addChild(wire);
  float distance=sqrt((X2-X1)*(X2-X1)+(Y2-Y1)*(Y2-Y1));
  totalDistance+=distance;
  return distance;
}


void draw() {

 
translate(viewPadding/2,viewPadding/2);
float oX=(w-heatWidth)/2;
float oY=(h-heatHeight)/2-(heatHeight%jump)/2;
strokeWeight(linewidth);
noFill();
beginShape(LINES);


float lastI=0;
for(float i=jump;i<heatHeight-jump;i+=jump)
{
  makeWire(oX+0,oY+i,oX+heatWidth-offset,oY+i,linewidth,1,signal1);
  makeWire(oX+heatWidth-offset,oY+i,oX+heatWidth-offset,oY+i+jump/4,linewidth,1,signal1);
  makeWire(oX+heatWidth-offset,oY+i+jump/4,oX+0,oY+i+jump/4,linewidth,1,signal1);
  makeWire(oX+0,oY+i+jump/4,oX+0,oY+i+jump,linewidth,1,signal1);
  lastI=i+jump;
}

  makeWire(oX+0,oY+lastI,oX+heatWidth,oY+lastI,linewidth,1,signal1);
   makeWire(oX+heatWidth,oY+lastI,oX+heatWidth,oY+lastI-jump/4,linewidth,1,signal1);

for(float i=lastI;i>jump;i-=jump)
{
  makeWire(oX+heatWidth,oY+i-jump/4,oX+offset,oY+i-jump/4,linewidth,1,signal1);
  makeWire(oX+offset,oY+i-jump/4,oX+offset,oY+i-2*jump/4,linewidth,1,signal1);
  makeWire(oX+offset,oY+i-2*jump/4,oX+heatWidth,oY+i-2*jump/4,linewidth,1,signal1);
  if(i!=2*jump)
  makeWire(oX+heatWidth,oY+i-2*jump/4,oX+heatWidth,oY+i-jump-jump/4,linewidth,1,signal1);
}

float oldOY=oY;

oY=(h-heatHeight)/2;
makeWire(oX+heatWidth,oldOY+jump+2*jump/4,oX+heatWidth,oY+jump-jump/2,linewidth,1,signal1);
makeWire(oX+heatWidth,oY+jump-jump/2,oX,oY+jump-jump/2,linewidth,1,signal1);

endShape(); 
println(totalDistance+" mm of wire");

float resistance = 0.000017f*totalDistance/(linewidth*copperWeight*0.035f)*(1 + (0.0039*(100 - 25)));//resistance at 100C
//via http://circuitcalculator.com/wordpress/2006/01/24/trace-resistance-calculator/

println(resistance+" ohm resistance");
float current = voltage/resistance;
println(current+" Amps drawn at "+voltage+" Volts");
println(voltage*current+" watts drawn");

PrintWriter output = createWriter( "result.brd" );

output.print(xml.toString(2));
output.close();


}
