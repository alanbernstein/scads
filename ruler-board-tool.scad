include <libs/BOSL2/geometry.scad>;
include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn=1024;
e=.1;
k1 = sqrt(3)/2;  // od = id / k1, for hexagons
 

 t1 = 18; // thickness of ruler board
 
 d1 = 8.5; // pencil diameter (bic mechanical)
 
 d2 = 5.1+.25; // diameter of rod
 d3 = 3.9; // inner diameter of rod
 
 t2 = 0.5; // thickness of straightedge
 w2 = 31;
 
 x1 = 35; // full width
 x2 = 10; // width of solid section
 h = 25; // full height
 
 module tool_old() {
  difference() {
   cube([x1, t1+2*2, h], rounding=2, anchor=FRONT+LEFT+BOTTOM);
   left(e) back(2) down(e) cube([x1-x2, t1, h+2*e]); // hole for board
   #up(1) back(t1/2+2) right(x1-x2/2) cylinder(d=d2, h=h*2); // vertical rod holder
   #fwd(25) up(h/2) right(x1-x2/2) xrot(-90) cylinder(d=d2, h=h*2);  // horizontal rod holder
   // pencil holder
   up(h/2-d2/2) right(x1-x2-10/2) back(t1+2*1) cuboid([10,5,3], rounding=1.5, edges = "Y"); // ruler cutout
 }
}


module tool(ff=.2) {
  ff1 = ff; // fudge factor for width of board
  ff2 = ff; // fudge factor for width of board
  difference() {
   cuboid([x1, t1+2*2, h], rounding=2, anchor=FRONT+LEFT+BOTTOM);
   #left(e) back(2) down(e) linear_extrude(h+2*e) polygon([[0, ff1], [x1-x2, 0+ff2], [x1-x2, t1-ff2], [0, t1-ff1]]);
   //#left(e) back(2) down(e) cube([x1-x2, t1, 5+2*e]); // hole for board
   up(1) back(d2) right(x1-x2/2) cylinder(d=d2, h=h*2); // vertical rod holder
   #fwd(25) up(h/2) right(x1-x2/2) xrot(-90) cylinder(d=d2, h=h*2);  // horizontal rod holder
   up(h/2-d2/2) right(x1-x2-10/2) back(t1+2*1) cuboid([10,5,3], rounding=1.5, edges = "Y"); // ruler cutout

   up(1) back(t1-2) right(x1-x2/2) cylinder(d=d1, h=h*2); // pencil holder 
   
   }
}


module fit_test(ff=.2) {
  ff1 = ff; // fudge factor for width of board
  ff2 = ff; // fudge factor for width of board
  difference() {
   cube([x1, t1+2*2, 5], rounding=2, anchor=FRONT+LEFT+BOTTOM);
   #left(e) back(2) down(e) linear_extrude(5+2*e) polygon([[0, ff1], [x1-x2, 0+ff2], [x1-x2, t1-ff2], [0, t1-ff1]]);
   //#left(e) back(2) down(e) cube([x1-x2, t1, 5+2*e]); // hole for board
   up(1) back(t1/2+2) right(x1-x2/2) cylinder(d=d2, h=h*2); // vertical rod holder

   }
}

module cap(l=5) {
 union() {
  up(l) difference() {
   sphere(d=d2);
   cube([10, 10, 10], anchor=TOP);
  }
  difference() {
   cylinder(d=d3, h=l);
   down(e) cube([1, 5, l+e], anchor=BOTTOM);
  }
 }
}

//cap();

//fwd(0) fit_test(.2);
tool();