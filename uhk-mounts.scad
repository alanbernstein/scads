include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn = 128;
in2mm = 25.4;

/////////////////////////
// UHK model (bottom, 2D)

// very approximate
perimeter_l = [
  [0, 0],
  [135, 0],
  [135, 114],
  [108, 114],
  [104, 132],
  [0, 114],
];

perimeter_r = [
  [0, 0],
  [-154, 0],
  [-154, 114],
  [-154+33, 114],
  [-154+33+4, 132],
  [0, 114],
];

// screw holes
// origin = bottom left corner of exterior
l1 = [-(7.5 + 96), 7.4, 0]; // bottom-right (viewed from above)
l2 = [-(7.5), 7.4 + 23.5, 0]; // bottom-left
l3 = [-(7.5), 7.4 + 23.5 + 55, 0]; // top-left
l4 = [-(7.5 + 94), 7.4 + 23.5 + 55 + 22.5, 0]; // top-right
// origin = bottom right corner of exterior
r1 = [(7.6), 7.4 + 23.5, 0]; //  # bottom-right (viewed from above)
r2 = [(7.6 + 115), 7.4, 0]; // bottom-left
r3 = [(7.6 + 103), 7.4 + 23.5 + 59 + 18.5, 0]; // top-left
r4 = [(7.6), 7.4 + 23.5 + 59, 0]; // top-right

// foot holes
l5 = l1 + [-21, 2, 0];
l6 = l2 + [-2, -21.5, 0];
l7 = l3 + [-2, 18.5, 0];
l8 = l4 + [-23, -4.5, 0];

r5 = r1 + [2, -21.5, 0]; // TODO measure these
r6 = r2 + [21, 2, 0];
r7 = r3 + [21+12, -4.5, 0];
r8 = r4 + [2, 18.5, 0];

lc = [-(3 + 5 / 16) * in2mm, (2 + 1 / 4) * in2mm, 0];
rc = [(3 + 3 / 8) * in2mm, (2 + 1 / 4) * in2mm, 0];
reset_pos = [8.5, 20, 0];
screw_hole_diam = 5;
foot_hole_diam = 6;
reset_diam = 3;

module uhk_screw_holes_L() {
    translate(l1) circle(d=screw_hole_diam);
    translate(l2) circle(d=screw_hole_diam);
    translate(l3) circle(d=screw_hole_diam);
    translate(l4) circle(d=screw_hole_diam);
}

module uhk_foot_holes_L() {
    translate(l5) circle(d=foot_hole_diam);
    translate(l6) circle(d=foot_hole_diam);
    translate(l7) circle(d=foot_hole_diam);
    translate(l8) circle(d=foot_hole_diam);
}

module uhk_center_hole_L(d=centroid_diam) {
    translate(lc) circle(d=centroid_diam);
}

module uhk_screw_holes_R() {
    translate(r1) circle(d=screw_hole_diam);
    translate(r2) circle(d=screw_hole_diam);
    translate(r3) circle(d=screw_hole_diam);
    translate(r4) circle(d=screw_hole_diam);
}

module uhk_foot_holes_R() {
    #translate(r5) circle(d=foot_hole_diam);
    #translate(r6) circle(d=foot_hole_diam);
    #translate(r7) circle(d=foot_hole_diam);
    #translate(r8) circle(d=foot_hole_diam);
}

module uhk_center_hole_R(d=centroid_diam) {
    translate(rc) circle(d=centroid_diam);
}

module reset_hole() {
    translate(reset_pos) circle(d=reset_diam);  
}

module left_bottom() {
  difference() {
    linear_extrude(2)
    difference() {
      polygon(round_corners(perimeter_l, radius=2));
      scale([-1, 1, 1]) uhk_screw_holes_L();
      scale([-1, 1, 1]) uhk_foot_holes_L();
      back(13) right(14) rect([108, 87], rounding=3, anchor=LEFT+FRONT);
    }
   up(1) linear_extrude(2) #right(30) back(105) 
   zrot(5) text("LEFT (up)");
  }
}
// left(135+5) left_bottom();

module right_bottom() {
  difference() {
    linear_extrude(2)
    difference() {
      polygon(round_corners(perimeter_r, radius=2));
      scale([-1, 1, 1]) uhk_screw_holes_R();
      scale([-1, 1, 1]) uhk_foot_holes_R();
      back(13) left(14) // TODO measure
      rect([108+19, 87], rounding=3, anchor=RIGHT+FRONT);
    }
   up(1) linear_extrude(2) #left(30) back(108) 
   zrot(-5) text("RIGHT (up)", anchor=RIGHT);
  }
}
// right(154+5) right_bottom();

module all_uhk_holes() {
  #uhk_screw_holes_L();
  #uhk_screw_holes_R();
  uhk_foot_holes_L();
  uhk_foot_holes_R();
  reset_hole();
}
// all_uhk_holes();

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

// naive attempt at a 2D-based minimal-material connection between the center and the four screws
module base_profile_1L() {
  union() {
    capsule(lc, l1, R2, R1);  // bottom right (viewed from above)
    capsule(lc, l2, R2, R1);  // bottom left
    capsule(lc, l3, R2, R1);  // top left
    capsule(lc, l4, R2, R1);  // top right
  }
}
module base_profile_1R() {
  union() {
    capsule(rc, r1, R2, R1);  // bottom right (viewed from above)
    capsule(rc, r2, R2, R1);  // bottom left
    capsule(rc, r3, R2, R1);  // top left
    capsule(rc, r4, R2, R1);  // top right
  }
}

// design to extrude into a tented stand, while leaving screw holes accessible
module base_profile_2L() {
  union() {
    capsule(l2, l3, R1, R1); // right-side holes
    capsule(l1, l4, R1, R1); // left-side holes
    capsule((l1+l4)/2, (l2+l3)/2, R1, R1);
    // capsule();
  }
}
module base_profile_2R() {
  union() {
    capsule(r2, r3, R1, R1); // right-side holes
    capsule(r1, r4, R1, R1); // left-side holes
    capsule((r1+r4)/2, (r2+r3)/2, R1, R1);
  }
}

// base_profile_2L();
// base_profile_2R();

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

// linear_extrude(1/8*in2mm) {
//   translate([80, 60]) 
//   base_1L();
//   base_1R();
// }

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
// base_2L();
// base_2R();

// base 3: angled extrusion for 45-degree tent mount, easy-access screw holes
module base_3L() {
  union() {
    linear_extrude(6)
    difference() {
      // TODO fillets
      base_profile_2L();
      uhk_screw_holes_L();
    }
    up(6)
    intersection() { yrot(45) cube(300, anchor=TOP+RIGHT); // TODO use a "cut" bosl2 function  
      linear_extrude(130) {
        capsule((l1+l4)/2, (l2+l3)/2, 2, 2);
        capsule(l1+0.25*(l4-l1), l1+0.75*(l4-l1), R1, R1); // left-side holes
      }
    }
  }
}

module base_3R() {
  union() {
    linear_extrude(6)
    difference() {
      // TODO fillets
      base_profile_2R();
      uhk_screw_holes_R();
    }
    up(6)
    intersection() { yrot(-45) cube(300, anchor=TOP+LEFT);        
      linear_extrude(130) {
        capsule((r1+r4)/2, (r2+r3)/2, 2, 2);
        #capsule(r2+0.25*(r3-r2), r2+0.75*(r3-r2), R1, R1); // left-side holes
      }
    }
  }
}

// base_3L();
// color("red") base_3R();

// idea 4: topologically optimized support - use fusion, build123d, or cadquery

// idea 5: randomly-positioned network of nodes, joined as metaballs or similar, with 
//         one node for each screw/foot hole, flattened and with a screw/foot hole
//         one node for each foot that actually rests on the table
//         a few extra nodes on the interior of the hull defined by the above
//         edges defined to draw connections between them

module base_5L() {
  pts = [
    l5, l6, l7, l8,  // screw holes
    l6+[0,0,-100], l7+[0, 0, -100], // bottom
    // TODO generate 4-8 random points inside the hull
    // or less random: 1 near the center of each small face, 2 near the center of the large face
    // simplest thing that moves the supports out of the way of the screw holes
    // OR just use the feet to secure, don't need screw holes to go all the way through

  ];

  // minimal
  edges1 = [
    [0, 1], [1, 2], [2, 3], [3, 0], // connect screws via hull
    [0, 4], [3, 5], // side legs
    [1, 4], [2, 5], // hypot legs
    [4, 5], // connect feet
    // TODO connect to more interior nodes
  ];

  edges2 = [
    [0, 1], [1, 2], [2, 3], [3, 0], // connect screws via hull
    [0, 4], [3, 5], // side legs
    [1, 4], [2, 5], // hypot legs
    [4, 5], // connect feet
    // TODO connect to more interior nodes
  ];

  edges = edges1;

  for(i=[0:len(pts)-1]) {
    translate(pts[i]) sphere(r=6);
    %translate(pts[i]+[12, 12, 0]) text(str(i));
  }

  for(i=[0:len(edges)-1]) {
    // TODO metaball or hyperboloid instead of cylinder
    edge = edges[i];
    p0 = pts[edge[0]];
    p1 = pts[edge[1]];
    dp = p1 - p0;
    norm = sqrt(dp*dp);

    translate(p0)
      rot(from=[0, 0, 1], to=dp)
        zcyl(d=4, h=norm, anchor=BOTTOM);
  }
}

bottom_half(400) base_5L();