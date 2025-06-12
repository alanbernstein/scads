include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn=64;
e=.1;
k1 = sqrt(3)/2;  // od = id / k1, for hexagons


// measurements of Wera 1/4" sockets
w = 0.25 * 25.4; // width of the 
d = 3;           // diameter of the detent
hh = 3;          // height of the bottom of the detent
h = hh + d/2;    // height of the center of the detent
yy = 0.5;           // detent depth (guess)


module detent1(a=0) {
 zrot(a) sphere(d=d);
}

module detent2(a=0) {
 zrot(a) xrot(90) translate([0, 0, -d/2]) cylinder(d=d, h=d);
}

module peg1() {
    // simple cube
 cube([w, w, w+1], anchor=BOT); 
}

module peg2(v1) {
    // cube with diagonal cutouts
 difference() {
  cube([w, w, w+1], anchor=BOT); 
 neg2(v1);
 }
}

module neg2(thickness) {
  zrot(45) cube([10, thickness, 20], anchor=BOT);
  zrot(-45) cube([10, thickness, 20], anchor=BOT);
}

module peg3(t=1) {
    // arch with detents
    // t = thickness
    difference() {
        union() {
            cube([w, w, w+1], anchor=BOT);
            up(w+1) xrot(90) down(w/2) cylinder(d=w, h=w);
        }
        neg3(t);
    }
}
module neg3(t) {
    union() {
        cube([w-2*t, w+2, w+1], anchor=BOT);
        up(w+1) xrot(90) down(w/2+1) cylinder(d=w-2*t, h=w+2);
    }
}

//peg3();
//detent2();

module peg4(x) {
    r = 25.4/16;
    // https://cults3d.com/en/3d-model/tool/snap-on-socket-rail-aufsteckschiene-fuer-steckschluessel-einsaetze-1-2-zoll
    difference() {
        up((w+1)/2)rounded_prism(rect(w), height=w+1, joint_top=r, joint_bot=-r, joint_sides=r, k=0.5);
        // neg4(0);
    }
}

module neg4(w3=4) {
    t = 0.5;
    w2 = 4;
    h = 4.5;
    union() {
        difference() {
            union() {
                cube([w2, w+2, h], anchor=BOT);
                up(h) xrot(90) down((w+2)/2) cylinder(d=w2, h=w+2);
            }
            union() {
                cube([w2-2*t, w+2+2, h], anchor=BOT);
                up(h) xrot(90) down((w+2+2)/2) cylinder(d=w2-2*t, h=w+2+2);
            }
        }
        union() {
            cube([w2, w3, h], anchor=BOT);
            up(h) xrot(90) down(w3/2) cylinder(d=w3, h=3);
        }
    }
}

//fwd(-20) neg4(0);

module mount1(v1,v2=yy) {
    // v1 = spacing between vertical segments
    // v2 = detent depth
    difference() {
        union() {
            peg4(v1);
            // translate([w/2-(d/2-v2), 0, h]) detent1(0);
            // translate([-w/2+(d/2-v2), 0, h]) detent1(0);
            translate([0, w/2-(d/2-v2), h]) detent1(90);
            translate([0, -w/2+(d/2-v2), h]) detent1(90);
        }
        neg4(v1);
    }
}

//mount1(1.0, 0.5);


// parameter grid loop
S = 15; // spacing
Sx = S; Sy = S;
Wx = 6; Wy = 6; Wy_ = 2;  // Wy_ is a bit of extra height for labels
// xvec = [0.5, 1, 1.5];  // parameter values along x axis
// yvec = [0.3, 0.4, 0.5]; // parameter values along y axis

xvec = [4, 4.5, 5];
yvec = [0.3, 0.4, 0.5];

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

//parameter_grid();

wera_diams = [13, 13, 13, 13, 13, 14.5, 16, 17, 18];
function positions1(d, s=0.1) = [
    for(i=[0:len(d)-1]) 
        sum([for(j=[0:i-1]) (d[j]+d[j+1])/2+max(d[j],d[j+1])*s])
];

function positions(d, s=2) = [for(i=[0:len(d)-1]) sum([for(j=[0:i-1]) d[j]+s])];


module wera_socket_holder(poses) {
    union() {
        down(1.5)
        difference() {
            right(128.5/2+12/2) rounded_prism(rect([128.5+12+12, 12]),
                height=3, joint_top=1, joint_bot=1, joint_sides=6, k=.5);
            down(2) cylinder(d1=25.4/4/k1-.25, d2=25.4/4/k1, h=5);
        }
        for(i=[0:len(poses)-1]) {
            translate([12+poses[i], 0, 0]) mount1(4, 0.5);
        }
    }
}


wera_poses = positions(wera_diams);
wera_socket_holder(wera_poses);


module adapter_test() {
    difference() {
        rounded_prism(rect([12, 12]),
            height=3, joint_top=1, joint_bot=1, joint_sides=6, k=.5);
            down(2) cylinder(d1=25.4/4/k1-.25, d2=25.4/4/k1+.25, h=5);        
    }
}

//adapter_test();