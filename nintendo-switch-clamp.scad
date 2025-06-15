use <./utils.scad>;
use <./libs/Round-Anything/polyround.scad>;
include <libs/BOSL2/std.scad>;
include <libs/BOSL2/shapes3d.scad>;
include <libs/BOSL2/rounding.scad>;

$fn = 128;


// switch dimensions
spring_offset = 0; // make it a bit smaller ot provide spring force to close
h = 101 + spring_offset;
d = 15;
w = 172;
rfront = 2;
rback = 6;
dock_width = 68;

bump_diam_1 = 4;
bump_diam_2 = 2.5;
bump_height = 2.2;
bump_base_base_dist = 36;


module bump() {
    cylinder(d1=bump_diam_1, d2=bump_diam_2, h=bump_height);
    cylinder(d1=bump_diam_1, d2=bump_diam_2, h=bump_height);
}

module bumps() {
    left(-bump_base_base_dist/2 -bump_diam_1/2) bump();
    left(bump_base_base_dist/2 +bump_diam_1/2) bump();
}

module bumps_test() {
    union() {
        translate([0, 0, 1]) bumps();
        translate([-22, -3, 0]) cube([44, 6, 1]);
    }
}

//bumps_test();

// fidlock dimensions
diam = 20;
flange_diam = 33;
thread_depth = 5;
female_thread_depth = 3; // leaves 2mm for the thickness of the back plate


// mount parameters
t = 1.5; // thickness
h1 = 5; // size of overlap on front face
w1 = 40;
w2 = 3; // width of slant section next to fidlock hole
dd = flange_diam+2; // width of flat section around fidlock hole
f = 3;  // size of fidlock part on the interior of the clamp
w3 = 10; // width of flat section above fidlock hole
p = 23+w3; // vertical position of fidlock hole.


function clerp(t) = 3*t*t - 2*t*t*t;   // cubic lerp

module switch_profile_basic() {
    radiipoints = [
        [0, 0, rfront],
        [0, h, rfront],
        [d, h, rback],
        [d, 0, rback],
    ];
    polygonArray = polyRound(radiipoints,128);
    polygon(polygonArray);
}

module switch_profile_fidlock() {
    radiipoints = [
        [0, 0, rfront],
        [0, h, rfront],
        [d, h, rback],
        [d, p+dd/2+w2, 2+t],  //
        [d+f, p+dd/2, 2],   //
        //[d+f, p-dd/2, 2],   //
        //[d+f, p-dd/2-w2, 2],  //
        [d+f, 0, rback],
    ];
    polygonArray = polyRound(radiipoints,128);
    polygon(polygonArray);
}

module switch_profile_fidlock_wiggle() {
    radiipoints = [
        [0, 0, rfront],
        [0, h, rfront],
        [d, h, rback],

        // wiggle
        /*
        [d, h+t-5*3-1, 3],
        [d+t+2, h+t-5*4, 1],
        [d+0, h+t-5*5, 3],
        [d+t+2, h+t-5*6, 1],
        [d+0, h+t-5*7, 3],
        [d+t+2, h+t-5*8, 1],
        [d+0, h+t-5*9+1, 3],
        *///

        [d, p+dd/2+w2, 2+t],  //
        [d+f, p+dd/2, 2],   //
        //[d+f, p-dd/2, 2],   //
        //[d+f, p-dd/2-w2, 2],  //
        [d+f, w3+w2, rback],
        [d, w3, rback],
        [d, 0, rback],
    ];
    polygonArray = polyRound(radiipoints,128);
    polygon(polygonArray);
}
// switch_profile();


module mount_profile_exterior_basic() {
    radiipoints = [
        [-t, -t, t+rfront],
        [-t, h+t, t+rfront],
        [d+t, h+t, t+rback],
        [d+t, -t, t+rback],
    ];
    polygonArray = polyRound(radiipoints,128);
    polygon(polygonArray);    
}

module mount_profile_exterior_fidlock() {
    radiipoints = [
        [-t, -t, t+rfront],
        [-t, h+t, t+rfront],
        [d+t, h+t, t+rback],
        [d+t, p+dd/2+w2 + .7, 2],
        [d+t+f, p+dd/2 + .7, 2+t],
        //[d+t+f, p-dd/2, 2+t],
        //[d+t+f, p-dd/2-w2, 2+t],
        [d+f+t, -t, t+rback],
    ];
    polygonArray = polyRound(radiipoints,128);
    polygon(polygonArray);    
}

module mount_profile_exterior_fidlock_wiggle() {
    radiipoints = [
        [-t, -t, t+rfront],
        [-t, h+t, t+rfront],
        [d+t, h+t, t+rback],
        // wiggle
        /*[d+t+0, h+t-5*3, 1],
        [d+t+5, h+t-5*4, 3],
        [d+t+0, h+t-5*5, 1],
        [d+t+5, h+t-5*6, 3],
        [d+t+0, h+t-5*7, 1],
        [d+t+5, h+t-5*8, 3],
        [d+t+0, h+t-5*9, 1],
        //[d+t+5, h+t-5*10, t],
        //[d+t+0, h+t-5*11, t],
        //[d+t+2, p+dd/2+w2 + .7 + 2, 2],
        */
        [d+t, p+dd/2+w2 + .7, 2],
        [d+t+f, p+dd/2 + .7, 2+t],
        //[d+t+f, p-dd/2, 2+t],
        //[d+t+f, p-dd/2-w2, 2+t],
        //[d+f+t, -t, t+rback],
        
        [d+t+f, w3+w2, t+rback],
        [d+t, w3, t+rback],
        [d+t, -t, t+rback],
        
        //[d+f+t, -t, t+rback],
    ];
    polygonArray = polyRound(radiipoints,128);
    polygon(polygonArray);    
}


module mount_profile() {
    union() {
        difference() {
            mount_profile_exterior_basic();
            switch_profile_basic();
            translate([-t-1, h1-t/2]) square([4, h - 2*h1 + t]);
        }
        translate([-t/2, h1-t/2]) circle(d=t);
        translate([-t/2, h-h1+t/2]) circle(d=t);
    }
}


module mount_profile_test() {
    linear_extrude(2) {
        mount_profile();
    }
}
//mount_profile_test();

module usbc_hole() {
    radiipoints = [
        [-4, 7, 4],
        [-4, -7, 4],
        [4, -7, 4],
        [4, 7, 4],
    ];
    polygonArray = polyRound(radiipoints,128);
    linear_extrude(10) polygon(polygonArray);
}

module vent_hole(l=20) {
    radiipoints = [
        [-3, l/2, 3],
        [-3, -l/2, 3],
        [3, -l/2, 3],
        [3, l/2, 3],
    ];
    polygonArray = polyRound(radiipoints,128);
    linear_extrude(10) polygon(polygonArray);    
}


module linear_rounder(r=5, l=10, x=2) {
 linear_extrude(l) difference() {
  square(r+x);
  circle(r);
 }
}


module switch_mount_v1() {
    difference() {
        linear_extrude(w1) {
            mount_profile();
        }
        // fidlock hole
        #translate([d-5, p, w1/2]) rotate([0, 90, 0]) cylinder(d=diam+0.25, h=20);
        
        // usbc hole
        translate([d/2, h-2, w1/2]) rotate([-90, 0, 0]) usbc_hole();

        // vent hole
        #translate([d/2+1, -4, 10+t]) rotate([-90, 0, 0]) vent_hole(20);
    }
}

//switch_mount_v1();



module switch_mount_v2() {
    difference() {
        linear_extrude(100) {
            mount_profile();
        }
        // fidlock hole
        translate([d-5, p, w1/2+30]) rotate([0, 90, 0]) cylinder(d=diam+0.25, h=20);
        // vent hole
        translate([d/2+1, -4, 10+t+30]) rotate([-90, 0, 0]) vent_hole(20);
        
        wt = (100-40)/2; // transition width
        we = 10; // extension width
        
        r_todo = t;
        
        translate([-r_todo, 120-r_todo, 100+we]) 
        rotate([-90, 0, 0]) rotate([0, 90, 0])
        linear_extrude(50) smoothstep_prism(l1=80, l2=120, h1=wt, h2=we);
        
        translate([-r_todo, 120-r_todo, -we]) scale([1, 1, -1]) 
        rotate([-90, 0, 0]) rotate([0, 90, 0])
        linear_extrude(50) smoothstep_prism(l1=80, l2=120, h1=wt, h2=we, steps=40);
        
        translate([-r_todo, 100-10, 50])
        rotate([0, 90, 0]) {
            cylinder(d=100-20*2, h=50); 
            translate([-(100-20*2)/2, 0, 0]) cube([100-20*2, 20, 50]);
        }
        
        #translate([0, 0, 0]) xrot(0) yrot(-90) linear_rounder();
        #translate([0, 0, 0]) xrot(-90) yrot(-90) linear_rounder();
        #translate([0, 0, 0]) xrot(90) yrot(-90) linear_rounder();
        #translate([0, 0, 0]) xrot(-180) yrot(-90) linear_rounder();
        #translate([0, 0, 0]) xrot(90) yrot(-90) linear_rounder();
        #translate([0, 0, 0]) xrot(-180) yrot(-90) linear_rounder();

        
        /*
        translate([-r_todo, 50+r_todo, 50]) 
        scale([1, -1, 1])
        #rotate([-90, 0, 0]) rotate([0, 90, 0])
        #linear_extrude(50) smoothstep_prism(l1=50, l2=50+3, h1=30, h2=.1, steps=40);
        translate([-r_todo, 50+r_todo, 50]) 
        scale([1, -1, -1])
        #rotate([-90, 0, 0]) rotate([0, 90, 0])
        #linear_extrude(50) smoothstep_prism(l1=50, l2=50+3, h1=30, h2=.1, steps=40);
        */
        
    }
}
//switch_mount_v2();

//module smoothstep_prism(l1=20, l2=30, h1=10, h2=20, steps=50) {
    // l1 = length of the transition
    // h1 = height of the transition
    // l2 = length of the whole block
    // h2 = additional height


ee = 5; // extra width compared to v1
module switch_mount_v3(w1=40+ee) {
    difference() {
        union() {
            linear_extrude(w1) {
                mount_profile();
            }
            translate([d/2, h, w1/2]) rotate([0, 90, -90]) bumps();
        }
        // fidlock hole
        #translate([d-5, p, w1/2]) rotate([0, 90, 0]) cylinder(d=diam+0.25, h=20);
        
        // usbc hole
        translate([d/2, h-2, w1/2]) rotate([-90, 0, 0]) usbc_hole();

        // vent hole
        #translate([d/2+1, -4, 10+t+ee/2]) rotate([-90, 0, 0]) vent_hole(20+ee);
        
        // rounders
        rr = h1;
        translate([1, 0, w1-rr]) xrot(0) yrot(-90) linear_rounder(r=rr);
        translate([1, 0, rr]) xrot(-90) yrot(-90) linear_rounder(r=rr);
        translate([1, h, w1-rr]) xrot(90) yrot(-90) linear_rounder(r=rr);
        translate([1, h, rr]) xrot(-180) yrot(-90) linear_rounder(r=rr);
    }
}

//switch_mount_v3();

module fidlock_bump_profile() {
    d = flange_diam + 1;
    rpts = [
        [0, f, 0],
        [d/2, f, 1],
        [d/2+f, 0, 3],
        [d/2+f+2, 0, 0],
        [d/2+f+2, t, 0],    
        [d/2+f+t/2, t, 1],
        [d/2+f-t, f+t, 3],
        [0, f+t, 0],
    ];
    polygonArray = polyRound(rpts,128);
    polygon(polygonArray);

}

//fidlock_bump_profile();

module fidlock_bump() {
    rotate_extrude() fidlock_bump_profile();
}

//fidlock_bump();

ee = 5+10;
module switch_mount_v4(w1=40+ee) {
    difference() {
        union() {
            difference() {
                linear_extrude(w1) {
                    mount_profile();  // main body
                }
                translate([d-5, p, w1/2+4]) rotate([0, 90, 0]) 
                 cylinder(d=dd+f+6, h=20); // remove cylinder...
            }
            translate([d, p, w1/2+4]) 
            yrot(90) fidlock_bump(); // ...to add fidlock bump
            
            translate([d/2, h, w1/2]) rotate([0, 90, -90]) bumps(); // add locking bumps
        }
        // fidlock hole
        // +4 because center of mass of switch is not geometrically centered
        translate([d-5, p, w1/2+4]) rotate([0, 90, 0]) cylinder(d=diam+0.25, h=20);
        
        // usbc hole
        translate([d/2, h-2, w1/2]) rotate([-90, 0, 0]) usbc_hole();

        // vent hole
        translate([d/2+1, -4, 10+t+ee/2]) rotate([-90, 0, 0]) vent_hole(20+ee);
        
        // rounders
        rr = h1;
        #translate([1, 0, w1-rr]) xrot(0) yrot(-90) linear_rounder(r=rr);
        #translate([1, 0, rr]) xrot(-90) yrot(-90) linear_rounder(r=rr);
        #translate([1, h, w1-rr]) xrot(90) yrot(-90) linear_rounder(r=rr);
        #translate([1, h, rr]) xrot(-180) yrot(-90) linear_rounder(r=rr);
    }
}

switch_mount_v4();


module fidlock_holes() {
// fidlock snap pull, screw mount
 translate([-51/2, 0, -1]) cylinder(d=4.2, h=10);
 translate([51/2, 0, -1]) cylinder(d=4.2, h=10);
}

//fidlock_holes();

module visor_mount() {
 
}

