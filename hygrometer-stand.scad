use <./utils.scad>; 
$fn=128;
e=0.1;

module hygrometer() {
 union() {
  cylinder(d=57.5, h=8);
  cylinder(d=51.5, h=16);
 }
}

module fit_test() {
 difference() {
  translate([0, 0, e]) cylinder(d=60, h=15);
  hygrometer();
 }
}

//fit_test();

W = 60; // external diameter of circular section

r1 = 1.5;
l1 = 20;

module vent_hole() {
  #translate([l1, 0, 10])
   rotate([0, 90, 0]) 
    linear_extrude(height=(l1*(2.2-1)), scale=[1, 2.2])
     translate([0, -l1/2, 0])
      pill2D(r=r1, l=l1);
 
}

module stand() {
 difference() {
  union() {
   translate([0, 0, e]) cylinder(d=W, h=15);
   translate([-W/2, -W/2, e]) cube([W/2, W, 15]);
  }
  hygrometer();
  vent_hole();
  rotate([0, 0, 120]) vent_hole();
  rotate([0, 0, 240]) vent_hole();
 }
}

stand();