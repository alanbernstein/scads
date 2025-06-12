include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn=64;
e=.1;
k1 = sqrt(3)/2;  // od = id / k1, for hexagons
inch = 25.4;

// measurements of Wera 1/4" sockets
w = 0.25 * inch; // width of mount
d = 3;           // diameter of detent
hh = 3;          // height of detent (bottom)
h = hh + d/2;    // height of detent (center)
yy = 0.5;        // depth of detent (estimate)

wera_diams = [13, 13, 13, 13, 13, 14.5, 16, 17, 18]; // outer diams of all 9 sockets

module detent(a=0) {
 zrot(a) sphere(d=d);
}

// https://cults3d.com/en/3d-model/tool/snap-on-socket-rail-aufsteckschiene-fuer-steckschluessel-einsaetze-1-2-zoll
module peg(x) {
    r = inch/16;
    up((w+1)/2) rounded_prism(rect(w), height=w+1, joint_top=r, joint_bot=-r, joint_sides=r, k=0.5);
}

module arch(cube_dim) {
    union() {
        cube(cube_dim, anchor=BOT);
        up(cube_dim[2]) xrot(90) down(cube_dim[1]/2) cylinder(d=cube_dim[0], h=cube_dim[1]);
    }
}

module neg(w3=4) {
    t = 0.5;
    w2 = 4;
    h = 4.5;
    union() {
        difference() {
            arch([w2, w+2, h]);
            arch([w2-2*t, w+2+2, h]);
        }
        arch([w2, w3, h]);
    }
}

module mount1(v1,v2=yy) {
    // v1 = spacing between vertical segments
    // v2 = detent depth
    difference() {
        union() {
            peg(v1);
            translate([0, w/2-(d/2-v2), h]) detent(90);
            translate([0, -w/2+(d/2-v2), h]) detent(90);
        }
        neg(v1);
    }
}
// mount1(4.0, 0.5);

function positions(d, s=2) = [for(i=[0:len(d)-1]) sum([for(j=[0:i-1]) d[j]+s])];

module wera_socket_holder(poses) {
    union() {
        down(1.5)
        difference() {
            right(128.5/2+12/2) rounded_prism(rect([128.5+12+12, 12]),
                height=3, joint_top=1, joint_bot=1, joint_sides=6, k=.5);
            down(2) cylinder(d1=inch/4/k1-.25, d2=inch/4/k1, h=5);
        }
        for(i=[0:len(poses)-1]) {
            translate([12+poses[i], 0, 0]) mount1(4, 0.5);
        }
    }
}

wera_poses = positions(wera_diams);
//wera_socket_holder(wera_poses);


/*******************************
// parameter grid loop
*******************************/
S = 15; // spacing
Sx = S; Sy = S;
Wx = 6; Wy = 6; Wy_ = 2;  // Wy_ is a bit of extra height for labels
xvec = [4, 4.5, 5];     // parameter values along x axis
yvec = [0.3, 0.4, 0.5]; // parameter values along y axis
Nx = len(xvec);
Ny = len(yvec);

module parameter_grid() {
    difference() { 
        union() {
            // base plate
            translate([-Wx, -Wy, -1]) cube([(Nx-1)*Sx + 2*Wx, (Ny-1)*Sy + 2*Wy + Wy_, 1]);
            // Nx x Ny grid of objects
            for(nx=[0:Nx-1]) {
                for(ny=[0:Ny-1]) {
                    translate([nx*Sx, ny*Sy, 0]) mount1(xvec[nx], yvec[ny]);
                }
            }
        }
        // object labels
        for(nx=[0:Nx-1]) {
            for(ny=[0:Ny-1]) {
                #translate([nx*Sx, ny*Sy+6, .8-1]) linear_extrude(1) text(str(xvec[nx], ", ", yvec[ny]), size=2, valign="center", halign="center", anchor=TOP);
            }
        }
    }
}

//translate([-w/2, -w/2, w]) cube([w, w, w]);

parameter_grid();
