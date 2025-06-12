echo(version());
include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
include <libs/BOSL2/shapes2d.scad>;
include <utils.scad>;
$fn=128;
e = .05;
A = LEFT+FRONT+BOTTOM;


f = 1;

d = 110; // depth of medicine cabinet
w1 = 33+f; // little bandaid
h1 = 78;
w2 = 35+f; // middle bandaid
h2 = 95;
w3 = 40+f; // big bandaid
h3 = 96;

t = 0.5;
r = 5;

x1 = 35;  // depth of a single section
x2 = d-4*t-2*x1;  // depth of the last section

z = 8;

H1 = 60; // main height of box
H2 = 40; // height of inner walls
H3 = H1+25; // height of handle

module holder() {
 difference() {
  union() {
   // main bulk
   cuboid([t+w1+t+w2+t+w3+t, d, H1], anchor=A, rounding=r);
   // little handle bits
   translate([t+w1, t+x1, 0]) cuboid([w2+2*t, t, H3], anchor=A, rounding=w2/2+t, edges=[TOP+LEFT, TOP+RIGHT]);
   translate([t+w1, t+x1+t+x1, 0]) cuboid([w2+2*t, t, H3], anchor=A, rounding=w2/2+t, edges=[TOP+LEFT, TOP+RIGHT]);   
  }
  
  // left column
  // subtract bulk for storage areas
  translate([t, t, t]) cuboid([w1, x1, h1], anchor=A, rounding=r-t, 
            edges=[BOTTOM+LEFT, BOTTOM+FRONT, LEFT+FRONT]);
  translate([t, t+x1+t, t]) cuboid([w1, x1, h1], anchor=A, rounding=r-t,
            edges=[BOTTOM+LEFT]);
  translate([t, t+x1+t+x1+t, t]) cuboid([w1, x2, h1], anchor=A, rounding=r-t,
            edges=[BOTTOM+LEFT, BOTTOM+BACK, BACK+LEFT]);
  
  // make divider walls smaller
  translate([t, t, H2]) cuboid([w1, d-2*t, h1], anchor=A, rounding=r-t,
            except=[]);
   
  // cutouts for weight savings   
  translate([t+z, -1, t+z]) cuboid([w1-2*z, 3, H1-2*z], anchor=A, rounding=w1/2-z,
            except=[FRONT, BACK]);
  translate([t+z, d-1, t+z]) cuboid([w1-2*z, 3, H1-2*z], anchor=A, rounding=w1/2-z,
            except=[FRONT, BACK]);
  translate([t+z, 1, t+z]) cuboid([w1-2*z, d-4, H2-2*z], anchor=A, rounding=w1/2-z,
            except=[FRONT, BACK]);

  // middle column
  translate([t+w1+t, t, t]) cuboid([w2, x1, h2], anchor=A, rounding=r-t,
            edges=[BOTTOM+FRONT]);
  translate([t+w1+t, t+x1+t, t]) cuboid([w2, x1, h2], anchor=A, rounding=r-t,
            edges=[]);
  translate([t+w1+t, t+x1+t+x1+t, t]) cuboid([w2, x2, h2], anchor=A, rounding=r-t,
            edges=[BOTTOM+BACK]);
  //#translate([t+w1+t, t+x1+t+1, H2]) cuboid([w2, d-t-x1-t-4, h2], anchor=A, rounding=r-t,
  //         except=[]);
  
  translate([t+w1+t+z, -1, t+z]) cuboid([w2-2*z, 3, H1-2*z], anchor=A, rounding=w2/2-z,
            except=[FRONT, BACK]);
  
  translate([t+w1+t+z, d-1, t+z]) cuboid([w2-2*z, 3, H1-2*z], anchor=A, rounding=w2/2-z,
            except=[FRONT, BACK]);
  //translate([t+w1+t+z, t+x1+t+x1-1, t+z]) cuboid([w2-2*z, x1, H2-2*z], anchor=A, rounding=w2/2-z,
  //          except=[FRONT, BACK]);
  translate([t+w1+t+z, t+x1-1, t+z]) cuboid([w2-2*z, x1+4, H3-2*z], anchor=A, rounding=w2/2-z,
            except=[FRONT, BACK]);

  // right column
  translate([t+w1+t+w2+t, t, t]) cuboid([w3, x1, h3], anchor=A, rounding=r-t,
            edges=[BOTTOM+FRONT, BOTTOM+RIGHT, RIGHT+FRONT]);
  translate([t+w1+t+w2+t, t+x1+t, t]) cuboid([w3, x1, h3], anchor=A, rounding=r-t,
            edges=[BOTTOM+RIGHT]);
  translate([t+w1+t+w2+t, t+x1+t+x1+t, t]) cuboid([w3, x2, h3], anchor=A, rounding=r-t,
            edges=[BOTTOM+RIGHT, BOTTOM+BACK, BACK+RIGHT]);
  
  translate([t+w1+t+w2+t, t, H2]) cuboid([w3, d-2*t, h3], anchor=A, rounding=r-t,
            except=[]);
  translate([t+w1+t+w2+t+z, -1, t+z]) cuboid([w3-2*z, 3, H1-2*z], anchor=A, rounding=w3/2-z,
            except=[FRONT, BACK]);
  translate([t+w1+t+w2+t+z, d-1, t+z]) cuboid([w3-2*z, 3, H1-2*z], anchor=A, rounding=w3/2-z,
            except=[FRONT, BACK]);
  translate([t+w1+t+w2+t+z, -1, t+z]) cuboid([w3-2*z, d-4, H2-2*z], anchor=A, rounding=w3/2-z-.5, // not sure why this .5 is needed...
            except=[FRONT, BACK]);
  
  // weight cutouts on the left/right
  translate([-t, t+z, t+z]) cuboid([t+w1+t+w2+t+w3+t+2, x1-2*z, H1-2*z], anchor=A, rounding=x1/2-z, except=[LEFT, RIGHT]);
  translate([-t, t+w1+t+z, t+z]) cuboid([t+w1+t+w2+t+w3+t+2, x1-2*z, H1-2*z], anchor=A, rounding=x1/2-z, except=[LEFT, RIGHT]);
  translate([-t, t+w1+t+w2+t+z, t+z]) cuboid([t+w1+t+w2+t+w3+t+2, x1-2*z, H1-2*z], anchor=A, rounding=x1/2-z, except=[LEFT, RIGHT]);

 }
}

holder();