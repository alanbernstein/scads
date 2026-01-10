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

module uhk_screw_holes_L() {
    translate(l1) circle(d=screw_hole_diam);
    #translate(l2) circle(d=screw_hole_diam);
    translate(l3) circle(d=screw_hole_diam);
    translate(l4) circle(d=screw_hole_diam);
}

module uhk_center_hole_L(d=centroid_diam) {
    translate(lc) circle(d=centroid_diam);
}

module uhk_screw_holes_R() {
    #translate(r1) circle(d=screw_hole_diam);
    translate(r2) circle(d=screw_hole_diam);
    translate(r3) circle(d=screw_hole_diam);
    translate(r4) circle(d=screw_hole_diam);
}

module uhk_center_hole_R(d=centroid_diam) {
    translate(rc) circle(d=centroid_diam);
}

module reset_hole() {
    translate(reset_pos) circle(d=reset_diam);  
}

/////////////////////////////////////////////////////
// base-mount models
module capsule(p1, p2, r1, r2) {
  hull() {
    translate(p1) circle(r1);
    translate(p2) circle(r2);
  }
}

R1 = 7.5; // radius of mount profile around screw hole
R2 = 12.5; // minimum radius of profile around center hole

// naive attempt at a minimal-material connection between the center and the four screws
module base_profile_1L() {
  union() {
    capsule(lc, l1, R2, R1);
    capsule(lc, l2, R2, R1);
    capsule(lc, l3, R2, R1);
    capsule(lc, l4, R2, R1);
  }
}
module base_profile_1R() {
  union() {
    capsule(rc, r1, R2, R1);
    capsule(rc, r2, R2, R1);
    capsule(rc, r3, R2, R1);
    capsule(rc, r4, R2, R1);
  }
}

///////////////////////////////////////////////////////
// base 1: simple flat, thin extrusion of profile_type1
SCS_tap_diam = 5.31; // https://sendcutsend.com/guidelines/tapping/
// centroid_diam = SCS_tap_diam;
centroid_diam = 5.5; // a bit of slop for an m5 thread
module base_1L() {
  difference() {
    base_profile_1L();
    uhk_screw_holes_L();
    uhk_center_hole_L();
  }
}
module base_1R() {
  difference() {
    base_profile_1R();
    uhk_screw_holes_R();
    uhk_center_hole_R();
    reset_hole();
  }
}
//linear_extrude(1/4*in2mm)
//translate([80, 60]) 
// base_1L();
// base_1R();

// base 2: angled extrusion for 45-degree tent mount
module base_2L() {

  intersection() {
    linear_extrude(130)
      right(l2[0]+R1) // adjust to ANCHOR=RIGHT
        difference() {
          base_profile_1L();
          uhk_screw_holes_L();
        }
    #yrot(45) cube(300, anchor=TOP+RIGHT);        
  }
}

module base_2R() {
  intersection() {
    linear_extrude(130)
      left(r1[0]-R1)  // adjust to ANCHOR=LEFT
        difference() {
          base_profile_1R();
          uhk_screw_holes_R();
        }
    #yrot(-45) cube(300, anchor=TOP+LEFT);
  }
}

// translate([80, 60]) 
base_2L();
base_2R();

