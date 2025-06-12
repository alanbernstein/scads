$fn=128;
use <./libs/BOSL/threading.scad>

k = 5; // wall thickness


// measurements
d1 = 92; // inner diameter of thread - 92 is incorrect, but close enough to stick in
l1 = 16; // height of cylinder (thread is not as high)
p1 = 5;  // pitch (center-center between threads)
t1 = 1.5; // thread depth (difference between inner and outer radius)

r1 = 100; // radius of curvature of the "handle"


union() { 
    difference() {
        // https://github.com/revarbat/BOSL/wiki/threading.scad
        trapezoidal_threaded_rod(
            d=d1, l=l1, pitch=p1, thread_depth=t1, thread_angle=30,
            bevel=true
        );
        translate([0, 0, -10]) cylinder(d=d1-k*2, h=20); // empty interior
    }
    intersection() {
        difference() {
            translate([0, k/2, -r1+l1/2+9.5])
             rotate([90, 0, 0]) 
              cylinder(r=r1, h=5); // handle base-cylinder
            translate([0, 5, 5])
             rotate([90, 0, 0])
              cylinder(d=18, h=10); // hole for carabiner
        }
        translate([-(d1-t1*2)/2, -2.5, -8]) cube([d1-t1*2, 5, 30]); // handle shape-mask
    }
    translate([0, 0, -8]) cylinder(d=d1-t1*2, h=0.5); // cap 
}


// more detailed measurements for v2
threadOuterRadius = 95/2.0;
threadInnerRadius = 92/2.0;
threadOuterHeight = 1;
threadInnerHeight = 3;
threadPitch = 5.0;

rimRadius = 102/2.0;
baseHeight = 16.0;

tolerance = 0.5;
screwLength = 6.0;

rimHeight = 3.0;
