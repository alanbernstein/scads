include <libs/BOSL2/geometry.scad>;
include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn=1024;
e=.1;
k1 = sqrt(3)/2;  // od = id / k1, for hexagons
 

w1 = 12; // PD mount square side length

// VUP armband
l1 = 2.5;  // wavy hole thickness
l2 = 7;  // wavy hole spacing

d1 = 28.5;

module curved_pill_2d(t=2.5, d1=28, angle=40) {
 // t = thickness
 // d1 = diameter of inside big circle
 // angle = angle subtended by the centers of the small circles
 c = (d1+t)/2*cos(angle/2);
 s = (d1+t)/2*sin(angle/2);
 union() {
  intersection() {
   difference() {
    circle(d=d1+t*2);
    circle(d=d1);
   }
   polygon([[0, 0], [2*c, 2*s], [2*c, -2*s]]);
  }
  translate([c, s]) circle(d=t);
  translate([c, -s]) circle(d=t);
 }
}


module armband() {
 //cylinder(d=d1, h=2);
 curved_pill_2d(t=2.5, d1=28, angle=40);
 curved_pill_2d(t=2.5, d1=28+(l1+l2)*2, angle=40);
 curved_pill_2d(t=2.5, d1=28+(l1+l2)*4, angle=40);
 scale([-1, 1]) curved_pill_2d(t=2.5, d1=28, angle=40);
 scale([-1, 1]) curved_pill_2d(t=2.5, d1=28+(l1+l2)*2, angle=40);
 scale([-1, 1]) curved_pill_2d(t=2.5, d1=28+(l1+l2)*4, angle=40);
}

//armband();


d2 = 17;  // rubber detent inner diameter
d3 = 25;  // rubber detent outer diameter
d4 = 4;   // PD mount screw thread outer diameter
d5 = 8.5; // PD mount screw head diameter
h5 = 3.5; // PD mount screw head height

num_detents = 24;
c2 = PI*d2;
detent_width = c2 / num_detents;
detent_length = (d3-d2)/2;
echo(detent_width);


difference() {
 union() {
  difference() {
   union() {
    for(i=[0:num_detents]) {
     zrot(i*360/num_detents) right(d2/2) yrot(90)
     cylinder(h=detent_length, r=1.46); 
    }
   }
   down(10-0.95) cylinder(d=d3+1, h=10);
  }
  down(1-0.95) cylinder(d=d3+.1, h=1); 
 }
 //down(1) cylinder(d=d4+.25, h=5);
 #cuboid([12, 12, 4], rounding=1.5, edges="Z");
}