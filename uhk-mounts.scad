include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn = 128;
in2mm = 25.4;


// UHK model (bottom, 2D)
l1 = [-(7.5 + 96), 7.4, 0]; // bottom-right (viewed from above)
l2 = [-(7.5), 7.4 + 23.5, 0]; // bottom-left
l3 = [-(7.5), 7.4 + 23.5 + 55, 0]; // top-left
l4 = [-(7.5 + 94), 7.4 + 23.5 + 55 + 22.5, 0]; // top-right

r1 = [(7.6), 7.4 + 23.5, 0]; //  # bottom-right (viewed from above)
r2 = [(7.6 + 115), 7.4, 0]; // bottom-left
r3 = [(7.6 + 103), 7.4 + 23.5 + 59 + 18.5, 0]; // top-left
r4 = [(7.6), 7.4 + 23.5 + 59, 0]; // top-right

lc = [-(3 + 5 / 16) * in2mm, (2 + 1 / 4) * in2mm, 0];
rc = [(3 + 3 / 8) * in2mm, (2 + 1 / 4) * in2mm, 0];
reset_pos = [8.5, 20, 0];
screw_hole_diam = 5;
reset_diam = 3;

module uhk_screw_holes_left() {
    translate(l1) circle(d=screw_hole_diam);
    translate(l2) circle(d=screw_hole_diam);
    translate(l3) circle(d=screw_hole_diam);
    translate(l4) circle(d=screw_hole_diam);
}

module uhk_center_hole_left(d=centroid_diam) {
    translate(lc) circle(d=centroid_diam);
}

module uhk_screw_holes_right() {
    translate(r1) circle(d=screw_hole_diam);
    translate(r2) circle(d=screw_hole_diam);
    translate(r3) circle(d=screw_hole_diam);
    translate(r4) circle(d=screw_hole_diam);
}

module uhk_center_hole_right(d=centroid_diam) {
    translate(rc) circle(d=centroid_diam);
}

module reset_hole() {
    translate(reset_pos) circle(d=reset_diam);  
}


// base-mount model
module capsule(p1, p2, r1, r2) {
  hull() {
    translate(p1) circle(r1);
    translate(p2) circle(r2);
  }
}

SCS_tap_diam = 5.31; // https://sendcutsend.com/guidelines/tapping/
// centroid_diam = SCS_tap_diam;
centroid_diam = 5.5; // a bit of slop for an m5 thread

R1 = 7.5; // radius of mount profile around screw hole
R2 = 12.5; // minimum radius of profile around center hole

module base_profile_left_v1() {
  union() {
    capsule(lc, l1, R2, R1);
    capsule(lc, l2, R2, R1);
    capsule(lc, l3, R2, R1);
    capsule(lc, l4, R2, R1);
  }
}
module base_profile_right_v1() {
  union() {
    capsule(rc, r1, R2, R1);
    capsule(rc, r2, R2, R1);
    capsule(rc, r3, R2, R1);
    capsule(rc, r4, R2, R1);
  }
}

module base_left_v1() {
  difference() {
    base_profile_left_v1();
    uhk_screw_holes_left();
    uhk_center_hole_left();
  }
}
module base_right_v1() {
  difference() {
    base_profile_right_v1();
    uhk_screw_holes_right();
    uhk_center_hole_right();
    reset_hole();
  }
}

//linear_extrude(1/4*in2mm)
translate([80, 60]) base_left_v1();
base_right_v1();