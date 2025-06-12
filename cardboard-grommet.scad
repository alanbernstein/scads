include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn=64;
e=.1;
k1 = sqrt(3)/2;  // od = id / k1, for hexagons

t1 = 7;  // cardboard thickness
t2 = 2;  // grommet thickness beyond cardboard
d1 = 5;  // diameter of grommet hole
d2 = 15; // diameter of hole cut in cardboard (larger for more robustness)
d3 = 21; // outer diameter of grommer

d_minor = t1 + t2*2;
OD = d1 + d_minor*2;


module grommet_solid() {
    difference() {
        union() {
        difference() {
                cylinder(d=d3, h=d_minor, anchor=CENTER);
                cylinder(d=d1+d_minor, h=d_minor+2, anchor=CENTER);
            }
            torus(od=OD, id=d1); // inner strain-relief rounded edge
            up(t1/2) torus(od=d3+2*t2, r_min=t2); // outer rounded edge "polish"
            up(-t1/2) torus(od=d3+2*t2, r_min=t2);
        }

        //
        difference() {
            cylinder(d=d3+10, h=t1, anchor=CENTER);
            cylinder(d=20, h=t1+2, anchor=CENTER);
        }
    }
}

d4 = 20; // diameter of ring where the two parts are split
module grommet1() {
    difference() {
        grommet_solid();
        up(t1/2-e) cylinder(d=d3+10, h=t2+1, anchor=BOTTOM);
        up(0) cylinder(d=d4-2, h=20, anchor=CENTER);
    }
}

module grommet2() {
    difference() {
        grommet_solid();
        down(t1/2) difference() {
            up(0) cylinder(d=d3+10, h=12);
            up(0) cylinder(d=d4-2, h=12+2);
        }
    }
}

// difference() {
//     grommet1();
//     down(15) cube([30, 30, 30]);
// }

// fwd(-35) difference() {
//     grommet2();
//     down(15) cube([30, 30, 30]);
// }

grommet1();
fwd(-35) grommet2();