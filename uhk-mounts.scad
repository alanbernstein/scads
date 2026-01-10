include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn=128;

in2mm = 25.4;

l1 = [-(7.5+96),  7.4, 0]; // bottom-right (viewed from above)
l2 = [-(7.5),     7.4+23.5, 0]; // bottom-left
l3 = [-(7.5),     7.4+23.5+55, 0]; // top-left
l4 = [-(7.5+94),  7.4+23.5+55+22.5, 0]; // top-right

r1 = [(7.6),      7.4+23.5, 0]; //  # bottom-right (viewed from above)
r2 = [(7.6+115),  7.4, 0]; // bottom-left
r3 = [(7.6+103),  7.4+23.5+59+18.5, 0]; // top-left
r4 = [(7.6),   7.4+23.5+59, 0]; // top-right

lc = [-(3+5/16)*in2mm, (2+1/4)*in2mm, 0];
rc = [(3+3/8)*in2mm, (2+1/4)*in2mm, 0];
reset_switch = [8.5, 20, 0];


centroid_diam = 5.31; // https://sendcutsend.com/guidelines/tapping/
screw_hole_diam = 5;
reset_diam = 3;

rad = 7.5;
D = 12.5;


module left() {
 difference() {
  union() {
   capsule(lc, l1, D, rad);
   capsule(lc, l2, D, rad);
   capsule(lc, l3, D, rad);
   capsule(lc, l4, D, rad);  
  }
  translate(l1) circle(d=screw_hole_diam);
  translate(l2) circle(d=screw_hole_diam);
  translate(l3) circle(d=screw_hole_diam);
  translate(l4) circle(d=screw_hole_diam);
  translate(lc) circle(d=centroid_diam);
 }
}
 
module right() {
difference() {
union() {
  capsule(rc, r1, D, rad);
  capsule(rc, r2, D, rad);
  capsule(rc, r3, D, rad);
  capsule(rc, r4, D, rad);
}
 translate(r1) circle(d=screw_hole_diam);
 translate(r2) circle(d=screw_hole_diam);
 translate(r3) circle(d=screw_hole_diam);
 translate(r4) circle(d=screw_hole_diam);
 translate(rc) circle(d=centroid_diam);
 translate(reset_switch) circle(d=reset_diam);
 }
}

//linear_extrude(1/4*in2mm)
translate([80, 60]) left();
right();

module capsule(p1, p2, r1, r2) {
    hull() {
        translate(p1) circle(r1);
        translate(p2) circle(r2);
    }
}