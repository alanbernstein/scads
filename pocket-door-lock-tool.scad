include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
include <libs/BOSL2/shapes2d.scad>;
include <utils.scad>;
include <parts.scad>;
$fn=128;
e = .05;

d1 = 31+.25;   // outer diameter
d2 = 17.5;

D1 = 7;
D2 = 2;
W = 5;

module linear_rounder(r=5, l=10, x=2) {
 linear_extrude(l) difference() {
  square(r+x);
  circle(r);
 }
}

module rotate_rounder(r1=5, r2=10, x=2) {
 rotate_extrude() translate([r2, 0, 0]) difference() {
  square(r1+x);
  circle(r1); 
 }
}
//rotate_rounder();

module tool(H=25) {
 difference() {
  union() {
   cylinder(d=d1, h=H);
   sphere(d=d1);
  }
  // carve out knob negative
  translate([-W/2, -d1/2-1, H-7+e])  cube([W, d1+2, 7]);
  translate([0, 0, H-D2-.5+e]) cylinder(d=d2+1, h=D2+.5);
  
  // carve out handle
  translate([20/2+5, 25, 0]) rotate([90, 0, 0]) scale([20/2, 15, 1]) cylinder(r=1, h=50);
  translate([5, -25, -20]) cube([20, 50, 20]);
  translate([-20/2-5, 25, 0]) rotate([90, 0, 0]) scale([20/2, 15, 1]) cylinder(r=1, h=50);
  translate([-20-5, -25, -20]) cube([20, 50, 20]);
 
  // string hole
  translate([-10, 0, -8]) rotate([0, 90, 0]) cylinder(d=5, h=20);
  
  // rounders
  translate([-W/2-2, 20, 25-2]) 
   rotate([90, 0, 0]) 
    linear_rounder(r=2, l=40, x=2);

  scale([-1, 1, 1]) 
   translate([-W/2-2, 20, 25-2]) 
    rotate([90, 0, 0]) 
     linear_rounder(r=2, l=40, x=2);
     
  translate([0, 0, H-2]) rotate_rounder(r1=2, r2=d1/2-2);

 }
}


//tool();
//minkowski() {tool(); sphere(r=1); }


module door_model() {
 union() {
  difference() {
   cylinder(d=50, h=10);
   up(10-D1+.05) cylinder(d=d1, h=D1);
  }
  up(10-D1) cylinder(d=d2, h=D2);
  for(i=[0:0]) {
   rotate([0, 0, 60*i]) translate([-W/2, -d1/2, 2])  cube([W, d1, 8]);
  }
 }
}
//fwd(40) door_model();



// office-garage door
w1 = 91 + 2; // 91 is width, 6 is extra width for spring force
t1 = 10;
h = 40;
t = 4;

// office-utility door
module holder(w, t, h) {
}

union() {
 W = d1+2*t;
 H = t1;
 N = 4;
 difference() {
  union() {
   translate([-w1/2-t+2, -W/2, 0])
    linear_extrude(H)
     difference() {
      spring2d_from_dimensions(t=t, N=N, w=W-t, l=(w1-d1-4)/2+t);
      translate([(w1-d1-4)/2-.5, -1]) square([t+1, W/2+1]);
     }
   translate([d1/2, -W/2, 0])
    linear_extrude(H) 
     difference() {
      spring2d_from_dimensions(t=t, N=N, w=W-t, l=(w1-d1-4)/2+t);
      translate([-.5, W/2]) square([t+1, W/2+1]);
     }
    cylinder(d=d1+2*t, h=H);
  }
  translate([0, 0, -1]) cylinder(d=d1, h=H+2);
 }
}
//linear_extrude(5) spring2d_from_dimensions(4, 8, 30, 51);
//linear_extrude(5) spring2d_from_dimensions(4, 6, 15, 51);