use <utils.scad>;
include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
$fn=128;
r2 = sqrt(2);
hex_in2out = 2/sqrt(3);
slop = 0.5;


// child carrier rear mount
d1 = 5; // mounting holes
d2 = 4.32; // tappable M5x0.8 holes

// child carrier screw spacing
h1 = 97; // four screws behind backrest
w1 = 129.5; 
w2 = 60; // bottom clamp

l1 = 2.5 * 25.4; // water bottle cage hole spacing

H = 150;
W = 200;
t = 3;

module screw_hole_2d(d) {
    circle(d=d);
}

module screw_hole(d) {
    down(3) cylinder(d=d, h=10);
}

module bottle_cage_hole_2d() {
    fwd(l1/2) screw_hole_2d(d2);
    fwd(-l1/2) screw_hole_2d(d2);
}

module bottle_cage_hole() {
    fwd(l1/2) screw_hole(d2);
    fwd(-l1/2) screw_hole(d2);
}

module pill2(r=1, l=2, h=.5) {
    //translate([0, -l/2, 0])
    linear_extrude(height=h) {
        #translate([-r, 0, 0]) square([r*2, l]);
        circle(r, $fn=64);
        translate([0, l, 0]) circle(r, $fn=64);
    }
}

module pill2d(r=1, l=2) {
    translate([-r, 0, 0]) square([r*2, l]);
    circle(r, $fn=64);
    translate([0, l, 0]) circle(r, $fn=64);
}


module back_plate() {
    difference() {
        cuboid([W, H, t], rounding=12, edges="Z");
        // backrest mount holes
        left(w1/2) fwd(h1/2) screw_hole(d1);
        left(w1/2) fwd(-h1/2) screw_hole(d1);
        left(-w1/2) fwd(h1/2) screw_hole(d1);
        left(-w1/2) fwd(-h1/2) screw_hole(d1);

        // bottle cage holes
        bottle_cage_hole();
        left(W/2-(W-w1)/4) bottle_cage_hole();
        right(W/4+w1/4) bottle_cage_hole();

        // bottom rail
        left(12) fwd(H/2-6-6) down(3) zrot(90) pill2(r=5, l=50, h=10);
        right(12) fwd(H/2-6-6) down(3) zrot(-90) pill2(r=5, l=50, h=10);
    }
}
// back_plate();

module back_plate_2d() {
    // $20.69 on sendcutsend
    difference() {
        translate([-W/2, -H/2]) rounded_square2([W, H], r=12);
        // backrest mount holes
        left(w1/2) fwd(h1/2) screw_hole_2d(d1);
        left(w1/2) fwd(-h1/2) screw_hole_2d(d1);
        left(-w1/2) fwd(h1/2) screw_hole_2d(d1);
        left(-w1/2) fwd(-h1/2) screw_hole_2d(d1);

        // bottle cage holes
        bottle_cage_hole_2d();
        left(W/2-(W-w1)/4) bottle_cage_hole_2d();
        right(W/4+w1/4) bottle_cage_hole_2d();

        // bottom rail
        left(12) fwd(H/2-6-6) zrot(90) pill2d(r=5, l=50);
        right(12) fwd(H/2-6-6) zrot(-90) pill2d(r=5, l=50);
    }
}

// back_plate_2d();

d3 = 19.3; // inner rail (metal)
d4 = 28;  // outer rail (foam)
xx = 87;  // outside-outside spacing between rails
module rails() {
    xcyl(d=d3, h=100);
    fwd(xx-d3/2-d4/2) xcyl(d=d4, h=100);
}
// down(d3/2+1) rails();

m5_thread_diam = 5;
m5_head_diam = 9;
m5_washer_diam = 11;
m5_nut_height = 5;
m5_nut_in_diam = 7.8;
m5_nut_out_diam = m5_nut_in_diam * hex_in2out;
echo(m5_nut_out_diam);

module rail_clamp(l=1) {
    zz = 5; // min wall thickness (extra diameter beyond rail)
    dx = xx-d3/2-d4/2;
    difference() {
        union() {
            cuboid([dx+d4/2+zz, d4+2*zz, l], anchor=RIGHT, rounding=d4/2+zz, edges=[LEFT+FRONT, LEFT+BACK]);
            fwd((d4+2*zz)/2) cylinder(d=(d4+2*zz-d3)/2, h=l, anchor=FRONT);
            back((d4+2*zz)/2) cylinder(d=(d4+2*zz-d3)/2, h=l, anchor=BACK);
        }
        // rail voids
        zcyl(d=d3, h=100);
        left(dx) zcyl(d=d4, h=100);

        // inner void
        left(d3/2+zz) cuboid([xx-d3-d4-zz*2, d4, l+2], anchor=RIGHT, rounding=6, edges="Z");

        // 3.5x12 slot
        //#left(dx/2) back((d4+2*zz)/2-6) down(6) 
        left(d3/2+zz+(xx-d3-d4-zz*2)/2) 
        up((12-3.5)/2) 
        xrot(-90)
        // zrot(90) 
        pill2(r=3.5/2, l=12-3.5, h=l+12);

        // bolt hole
        #fwd(20) left(d3/2+zz+(xx-d3-d4-zz*2)/2) ycyl(d=m5_thread_diam, h=50);
        // bolt_wall_thickness = 5;
        // #left(dx/2) back(bolt_wall_thickness) ycyl(d=m5_washer_diam, h=d4+2*zz); 
    }
}
// rail_clamp(l=1);  // fit test
//offset3d(3)
rail_clamp(l=20);

module comiso_speaker() {
    hvec = [0, 3, 23, 51, 52];
    dvec = [35, 44, 50, 44, 0];  // last diameter is the peak of the speaker grill

    // solid of rotation defined by heights and diameters
    // TODO
    cylinder(d=50, h=51);
}
// comiso_speaker();

module speaker_mount() {
    Nslits = 4; // actually 2x this
    difference() {
        // exterior
        down(5) cylinder(d=50+5*2, h=61);  // TODO toroidal filleted corners
        comiso_speaker();
        // top opening
        up(50) cylinder(d=35, h=10); // TODO make it a cone
        // side slits
        for(i=[0:Nslits]) {
            zrot(180*i/Nslits)
            up(5) back(40) xrot(90) pill2(r=3, l=40, h=80);
        }
        
        // xrot(20) #back(37) down(6) rails(); // for oblique-upright mount
        back(30) left(30) up(20) yrot(90) rails();
    }
}

// speaker_mount();  // printing orientation

// fwd(61-5) // accomodate height of speaker mount
// left(d3/2+5 + (xx-d3-d4)/2-5) fwd((d4+2*5)/2) // position at center clamp
// xrot(-90) speaker_mount();  // assembly orientation
