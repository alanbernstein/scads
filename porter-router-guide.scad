include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn=32;
inch = 25.4;

// 6911 base measurements
d1 = 8;   // insert hole diam
d2 = 5.75*inch; // outermost diameter of base face
x1 = 68;  // edge-edge hole dist
y1 = 17;  // depth of insert
y2 = 16;  // distance between outer diameter and guide-mount face 
z1 = 16;  // edge-bottom distance (router base face)
z2 = 5;   // edge-bottom distance (router base top)

module radius_guide(L=120, W=12, rr=3, Dbit_in=0.5, Dmin_in=5, Dmax_in=13, Dstep_in=0.5) {
    // attachment for porter cable 6911 router base (similar to 42690 edge guide)
    // L = additional length beyond router mount seciton
    // W = width of guide 
    // rr = fillet radius
    // Dbit_in = diameter of router bit
    // Dmin_in, Dmax_in, Dstep_in = min, max, step for multiple cut diameters
    /*
      D  
        |        p0     p1   p2  p3 ...
      C |________.______.____.___.__.__.
      B |___    /
        |      /
        |     /
        |    /
        |   /
      A_|_ /
        | /\ A'
        |/
        O

        O = center of router bit
        A, A' = edge of router bit
        B = vertical face of guide-mount holes
        C = centerline of printed guide goes through it
        D = outer edge of router base (irrelevant here)
        pn = guide rod hole #n

        OA, OA' = Rbit
        A'pn = Rcut
        OD = d2/2 (router base face outer diam)
        BD = y2 (distance between outer diameter and guide-mount hole face)
        Cpn = x-component of right triangle (X : the thing we're solving for)
        OC = y-component of right triangle (Y = d2/2 - y2 + W/2 = 63mm)
        Opn = hypotenuse of right triangle (R = Rcut + Rbit)

        X*X + Y*Y = R*R
        X = sqrt((Rcut+Rbit)^2 - Y^2)
    */

    Rbit_in = Dbit_in*inch/2;
    Rcut = [ for (d = [Dmin_in:Dstep_in:Dmax_in]) d * inch/2 ];
    hole_pos = [ for (r = Rcut) sqrt(abs((r + Rbit_in)^2 - (d2/2 - y2 + W/2)^2))];

    difference() {
        union() {
            right(x1/2) ycyl(d=d1, h=y1, rounding2=2, anchor=LEFT+FRONT);
            left(x1/2) ycyl(d=d1, h=y1, rounding2=2, anchor=RIGHT+FRONT);
            left(x1/2+d1+rr) cuboid([x1+d1*2+L+rr, W, d1+z2*2], rounding=rr, anchor=LEFT+BACK);
            right(x1/2+d1+4) down((z1-z2)/2) cuboid([L, 12, d1+z1+z2], rounding=rr, anchor=LEFT+BACK);
        }
        for(n=[0:len(hole_pos)-1]) {
           right(hole_pos[n]) fwd(W/2) down((z1-z2)/2) 
           #cyl(d1=3.3, d2=3.4, h=d1+z1+z2+2);
        }
    }
    %back(57) down(z1+d1/2) cyl(d=Dbit_in*inch, h=25, anchor=TOP); // router bit for reference
}
xrot(180) radius_guide();

module hole_fit_test(L=30) {
    // L = length
    rod_diams = [1.5, 2.0, 3.0]; // metal rods that i have
    difference() {
        #right(x1/2+d1+4) down((z1-z2)/2) cuboid([L, 21, d1+z1+z2], rounding=3, anchor=LEFT+BACK);
        hole_pos = [51, 56, 61, 66, 71];
        diam_delta = [-.1, 0, .1, .2, .3];
        for(n=[0:4]) {
            right(hole_pos[n]) fwd(12/2) cyl(d=rod_diams[0]+diam_delta[n], h=50);
            right(hole_pos[n]) fwd(12) cyl(d=rod_diams[1]+diam_delta[n], h=50);
            right(hole_pos[n]) fwd(12*1.5) cyl(d=rod_diams[2]+diam_delta[n], h=50);
        }
    }
}
// hole_fit_test();
