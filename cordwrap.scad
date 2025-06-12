//include <libs/BOSL2/std.scad>;
//include <libs/BOSL2/rounding.scad>;
//include <libs/BOSL2/shapes2d.scad>;
include <utils.scad>;
$fn=128;
e = .05;

// replica of the downloaded one
h1=20;
l1=30;
h2=50;
l2=35;
h3=10; 

// quad wrap for tent guidelines
h1 = 20;
l1 = 15;
h2 = 50;
l2 = 20;
h3 = 10;


module profile_base(r=3) {
    pts = [
        [l1+l2+l1, h3],
        //here
        [l1+l2, 0],
        [l1, 0],
        // here
        [0, h3],
        [0, h1],
        [l1, h1],
        [l1, h1+h2],
        [0, h1+h2],
        [0, h1+h2+h1-h3],
        
        [l1, h1+h2+h1],
        [l1+l2, h1+h2+h1],
        
        
        [l1+l2+l1, h1+h2+h1-h3],
        [l1+l2+l1, h1+h2],
        [l1+l2, h1+h2],
        [l1+l2, h1],
        [l1+l2+l1, h1],
        //l1+l2+l1 + 1j*(0),
    ];
    polygon(pts);
}

module cordslot() {
 union() {
  circle(d=5);
  //translate([-3/2, 0]) square([2, 10]);
 }
}

module profile() {
 x1 = 5;
 y1 = 5;
 x2 = 2.5;
 offset(0) offset(-0)
 difference() {
  profile_base();
  translate([l1-x2, h1/2]) rotate([0, 0, 180-45]) cordslot();
  translate([l1-x2, h1+h2+h1/2]) rotate([0, 0, 45]) cordslot();
  translate([l1+l2+x2, h1/2]) rotate([0, 0, 180+45]) cordslot();
  translate([l1+l2+x2, h1+h2+h1/2]) rotate([0, 0, -45]) cordslot();
  translate([l1+x1, h1+y1]) circle(d=5);
  translate([l1+l2-x1, h1+h2-y1]) circle(d=5);
  translate([l1+x1, h1+h2-y1]) circle(d=5);
  translate([l1+l2-x1, h1+y1]) circle(d=5);
  translate([l1+l2/2, h3/2]) circle(d=5);
  translate([l1+l2/2, h1+h2+h1-h3/2]) circle(d=5);
 }
}

//minkowski() {
 //sphere(d=1);
 linear_extrude(3) profile();
//}
