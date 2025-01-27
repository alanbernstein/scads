//include </u/a/3dprint/alanlib/shortcuts.scad>;
//include <shortcuts.scad>  <- only works if run from terminal
module R(v) {rotate(v) children();}
module T(v) {translate(v) children();}
module S(v) {scale(v) children();}
module Rx(a=90) {rotate([a, 0, 0]) children();}
module Ry(a=90) {rotate([0, a, 0]) children();}
module Rz(a=90) {rotate([0, 0, a]) children();}
module Tx(d) {translate([d, 0, 0]) children();}
module Ty(d) {translate([0, d, 0]) children();}
module Tz(d) {translate([0, 0, d]) children();}
module Sx(s) {scale([s, 1, 1]) children();}
module Sy(s) {scale([1, s, 1]) children();}
module Sz(s) {scale([1, 1, s]) children();}

// TODO: rename this to utils.scad
// TODO: create shapes.scad, move stuff there

mm_per_in = 25.4;
eps = .001;
phi = (sqrt(5)+1)/2; // useful for regular solids
O = 0; // silly sugar for hiding syntax highlighting

module brim_scale(s = [0.9, 1.1], height=.3) {
    // to be used for objects with multiply-connected footprints - 
    // the minkowski method doesn't work well for that case
    //
    // designed to work for objects that :
    // - rest on the x-y plane
    // - are somewhat centered on the origin
    union() {
        children();
        linear_extrude(height=height)
        difference() {
            scale([s[1], s[1], s[0]]) hull() projection(cut=true) children();
            scale([s[0], s[0], s[1]]) hull() projection(cut=true) children();
        }
    }
}

module dremel_footprint() {
    difference() {
        cube([232, 152, 1], center=true);
        cube([230, 150, 2], center=true);
    }
}

module brim_minkowski(radius=10, height=.3) {
    // i think this produces the "right" result for objects with simply-connected footprints.
    // nonconvex objects with narrow crevices might not do well.
    //
    // designed to work for objects that:
    // - rest on the x-y plane (?)
    // - have simply-connected footprints
    union() {
        minkowski() {
            linear_extrude(height=eps)
                projection(cut=true)
                    children();
            cylinder(r=radius, h=height-eps);
        }
        children();
    }
}

module trapezoid_arbitrary_3d(base_width, top_width, height, offs, thickness) {
    // assumes base_width > top_width
    linear_extrude(height=thickness) {
        polygon([[0, 0], 
                 [offs, height], 
                 [offs+top_width, height], 
                 [base_width, 0]]);
    }
}

module trapezoid_3d(base_width, top_width, height, thickness) {
    trapezoid_arbitrary_3d(base_width, top_width, height, (base_width-top_width)/2, thickness);
}

module pill3(r=1, l=1) {
    union() {
        cylinder(r=r, h=l, $fn=64);
        sphere(r=r, $fn=64);
        translate([0, 0, l]) sphere(r=r, $fn=64);
    }
}

module pill2(r=1, l=2, h=.5) {
    //translate([0, -l/2, 0])
    linear_extrude(height=h) {
        translate([-r, 0, 0]) square([r*2, l]);
        circle(r, $fn=64);
        translate([0, l, 0]) circle(r, $fn=64);
    }
}

module pill2D(r=1, l=2) {
    translate([-r, 0, 0]) square([r*2, l]);
    circle(r, $fn=64);
    translate([0, l, 0]) circle(r, $fn=64);
}

module rounded_square2(dim=[3, 3], r=1, $fn=64) {
    union() {
        translate([r, 0]) square(dim - [2*r, 0]); 
        translate([0, r]) square(dim - [0, 2*r]);
        translate([r, r]) circle(r, $fn=$fn);
        translate([r, dim[1]-r]) circle(r, $fn=$fn);
        translate([dim[0]-r, r]) circle(r, $fn=$fn);
        translate([dim[0]-r, dim[1]-r]) circle(r, $fn=$fn);
    }
}

//rounded_square2();

module rounded_square3(dim=[3, 3], r=1, h=1, $fn=64) {
    linear_extrude(h) {
        rounded_square2(dim=dim, r=r, $fn=$fn);
    }
}

//rounded_square3(h=4);

module torus(r1=20, r2=5, angle_start=0, angle_width=360) {
    rotate([0, 0, angle_start])
    rotate_extrude(angle=angle_width, convexity=10, $fn=128)
        translate([r1, 0, 0])
            circle(r = r2, $fn = 128);
}

// torus(r1=20, r2=5, angle_start=10, angle_width=180);

// dim represents the dimensions of the flat part, not the exterior hull. probably useless
module rounded_cube_dumb(dim=[3, 3, 3], r=1, $fn=64) {
    W = dim[0];
    L = dim[1];
    H = dim[2];
    union() {
        // cubes
        translate([-r, 0, 0]) cube(dim + [2*r, 0, 0]);
        translate([0, -r, 0]) cube(dim + [0, 2*r, 0]);
        translate([0, 0, -r]) cube(dim + [0, 0, 2*r]);
        // spheres
        translate([0, 0, 0]) sphere(r);
        translate([W, 0, 0]) sphere(r);
        translate([0, L, 0]) sphere(r);
        translate([W, L, 0]) sphere(r);
        translate([0, 0, H]) sphere(r);
        translate([W, 0, H]) sphere(r);
        translate([0, L, H]) sphere(r);
        translate([W, L, H]) sphere(r);
        // cylinders - z-axis aligned
        translate([0, 0, 0]) cylinder(r=r, h=H);
        translate([W, 0, 0]) cylinder(r=r, h=H);
        translate([0, L, 0]) cylinder(r=r, h=H);
        translate([W, L, 0]) cylinder(r=r, h=H);
        // cylinders - y-axis aligned
        translate([0, 0, 0]) rotate([-90, 0, 0]) cylinder(r=r, h=L);
        translate([W, 0, 0]) rotate([-90, 0, 0]) cylinder(r=r, h=L);
        translate([0, 0, H]) rotate([-90, 0, 0]) cylinder(r=r, h=L);
        translate([W, 0, H]) rotate([-90, 0, 0]) cylinder(r=r, h=L);
        // cylinders - x-axis aligned
        translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r=r, h=W);
        translate([0, L, 0]) rotate([0, 90, 0]) cylinder(r=r, h=W);
        translate([0, 0, H]) rotate([0, 90, 0]) cylinder(r=r, h=W);
        translate([0, L, H]) rotate([0, 90, 0]) cylinder(r=r, h=W);
    }
}

module rounded_cube(dim=[3, 3, 3], r=1, center=0, $fn=64) {
    W = dim[0] - 2*r;
    L = dim[1] - 2*r;
    H = dim[2] - 2*r;
    offset_noncentered = [r, r, r];
    offset_centered = [-W/2, -L/2, -H/2];
    //translate(center=1 ? offset_centered : offset_noncentered)
    translate(offset_noncentered)
    union() {
        // cubes
        translate([-r, 0, 0]) cube([W + 2*r, L, H]);
        translate([0, -r, 0]) cube([W, L + 2*r, H]);
        translate([0, 0, -r]) cube([W, L, H + 2*r]);
        // spheres
        translate([0, 0, 0]) sphere(r);
        translate([W, 0, 0]) sphere(r);
        translate([0, L, 0]) sphere(r);
        translate([W, L, 0]) sphere(r);
        translate([0, 0, H]) sphere(r);
        translate([W, 0, H]) sphere(r);
        translate([0, L, H]) sphere(r);
        translate([W, L, H]) sphere(r);
        // cylinders - z-axis aligned
        translate([0, 0, 0]) cylinder(r=r, h=H);
        translate([W, 0, 0]) cylinder(r=r, h=H);
        translate([0, L, 0]) cylinder(r=r, h=H);
        translate([W, L, 0]) cylinder(r=r, h=H);
        // cylinders - y-axis aligned
        translate([0, 0, 0]) rotate([-90, 0, 0]) cylinder(r=r, h=L);
        translate([W, 0, 0]) rotate([-90, 0, 0]) cylinder(r=r, h=L);
        translate([0, 0, H]) rotate([-90, 0, 0]) cylinder(r=r, h=L);
        translate([W, 0, H]) rotate([-90, 0, 0]) cylinder(r=r, h=L);
        // cylinders - x-axis aligned
        translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r=r, h=W);
        translate([0, L, 0]) rotate([0, 90, 0]) cylinder(r=r, h=W);
        translate([0, 0, H]) rotate([0, 90, 0]) cylinder(r=r, h=W);
        translate([0, L, H]) rotate([0, 90, 0]) cylinder(r=r, h=W);
    }
}

//rounded_cube(dim=[6, 7, 8], r=1);

module rounded_square_prism(dim=[50, 100, 15], r1=15) {
    W = dim[0] - 2*r1;
    L = dim[1] - 2*r1;
    H = dim[2];
    union() {
        // cubes
        translate([0, r1, 0]) cube([dim[0], L, H]);
        translate([r1, 0, 0]) cube([W, dim[1], H]);
        
        // cylinders - z-axis aligned
        $fn=128;
        rr1 = [r1, r1, 0];
        translate(rr1) cylinder(r=r1, h=H);
        translate(rr1 + [W, 0, 0]) cylinder(r=r1, h=H);
        translate(rr1 + [0, L, 0]) cylinder(r=r1, h=H);
        translate(rr1 + [W, L, 0]) cylinder(r=r1, h=H);     
    }
}

// like a macbook pro: 
// - 4 large-radius (r1) corners
// - every other edge has a small radius (r2) fillet
module filleted_rounded_square_prism(dim=[50, 100, 15], r1=15, r2=2) {
    W = dim[0] - 2*r1;
    L = dim[1] - 2*r1;
    H = dim[2];
    
    // these represent all the cubes and the z-aligned cylinders
    translate([0, 0, r2]) rounded_square_prism(dim-[0, 0, 2*r2], r1);
    translate([r2, r2, 0]) rounded_square_prism(dim-[2*r2, 2*r2, 0], r1-r2);
    
    // torus segments
    // TODO: quarter circle extrusions
    translate([r1, r1, r2]) torus(r1-r2, r2, 180, 90);
    translate([r1, r1, H-r2]) torus(r1-r2, r2, 180, 90);
    translate([r1, r1+L, r2]) torus(r1-r2, r2, 90, 90);
    translate([r1, r1+L, H-r2]) torus(r1-r2, r2, 90, 90);
    translate([r1+W, r1+L, r2]) torus(r1-r2, r2, 0, 90);
    translate([r1+W, r1+L, H-r2]) torus(r1-r2, r2, 0, 90);
    translate([r1+W, r1, r2]) torus(r1-r2, r2, 270, 90);
    translate([r1+W, r1, H-r2]) torus(r1-r2, r2, 270, 90);
    
    // cylinders - y-axis aligned
    $fn=128;
    translate([r2, r1, r2]) rotate([-90, 0, 0]) cylinder(r=r2, h=L);
    translate([dim[0]-r2, r1, r2]) rotate([-90, 0, 0]) cylinder(r=r2, h=L);
    translate([r2, r1, dim[2]-r2]) rotate([-90, 0, 0]) cylinder(r=r2, h=L);
    translate([dim[0]-r2, r1, dim[2]-r2]) rotate([-90, 0, 0]) cylinder(r=r2, h=L);
    // cylinders - x-axis aligned
    translate([r1, r2, r2]) rotate([0, 90, 0]) cylinder(r=r2, h=W);
    translate([r1, r2, dim[2]-r2]) rotate([0, 90, 0]) cylinder(r=r2, h=W);
    translate([r1, dim[1]-r2, r2]) rotate([0, 90, 0]) cylinder(r=r2, h=W);
    translate([r1, dim[1]-r2, dim[2]-r2]) rotate([0, 90, 0]) cylinder(r=r2, h=W);

}

//filleted_rounded_square_prism();


module connect_points_with_cone(p1, p2, r1, r2) {
    v = p2 - p1;
    h = norm(v); 
    dir = v / h; 
    
    // Rotation axis and angle 
    axis = cross([0, 0, 1], dir); 
    angle = acos([0, 0, 1]*dir /* dot product */); 
    translate(p1) { 
        if (norm(axis) > 0) { 
            rotate(angle, axis) 
                cylinder(h, r1, r2, $fn = 50); 
        } else { 
            // If already aligned with z-axis 
            cylinder(h, r1, r2, $fn = 50);
        }
    }
}

module rounded_cone(p1, p2, r1, r2) {
    union() {
        connect_points_with_cone(p1, p2, r1=r1, r2=r2); 
        translate(p1) sphere(r=r1, $fn=50); 
        translate(p2) sphere(r=r2, $fn=50);
    }
}


// Example usage: 
pA = [10, 10, 0]; 
pB = [10, -5, 15]; 
rA = 2; 
rB = 0.5; 
//rounded_cone(pA, pB, r1=rA, r2=rB);


// Function to find center and radius of circle that passes through three points
// Input: p1, p2, p3 = three 2D points as [x,y] vectors
// Output: [c, r] = center of circle as [x,y] vector and radius of circle
function circle_center_radius(p1, p2, p3) = let (
        // Calculate midpoint of line segments AB and BC
        mx1 = (p1[0] + p2[0]) / 2,
        my1 = (p1[1] + p2[1]) / 2,
        mx2 = (p2[0] + p3[0]) / 2,
        my2 = (p2[1] + p3[1]) / 2,
        // Calculate slopes of lines AB and BC and slopes of perpendicular bisectors
        m1 = (p2[1] - p1[1]) / (p2[0] - p1[0]),
        m2 = (p3[1] - p2[1]) / (p3[0] - p2[0]),
        mp1 = -1 / m1,
        mp2 = -1 / m2,
        // Calculate coordinates of center of circle
        cx = (mp2 * mx2 - mp1 * mx1 + my1 - my2) / (mp2 - mp1),
        cy = mp1 * (cx - mx1) + my1,
        // Calculate radius of circle
        r = sqrt((cx - p1[0]) * (cx - p1[0]) + (cy - p1[1]) * (cy - p1[1]))
    ) [cx, cy, r];

// Example usage:
p1 = [0, 0];
p2 = [1, 1];
p3 = [2, 0];
// OP had to fix the next three lines
cr = circle_center_radius(p1, p2, p3);
echo("Center of the circle: ", cr[0], cr[1]);
echo("Radius of the circle: ", cr[2]);

module three_point_circle(p1, p2, p3) {
    cr = circle_center_radius(p1, p2, p3);
    translate([cr[0], cr[1]]) circle(cr[2]);
}
$fn=128;
//three_point_circle(p1, p2, p3);


module test_object() {
    union() {
        cube([30, 10, 10]);
        cube([10, 30, 10]);
    }
}    

//test_object();
//brim_minkowski() test_object();
//brim_scale() test_object();
//brim_scale() {test_object();}


// material/process constants
// thickness = 2 -> notch width = 2.4
ACRYLIC_60mil = 1.5;
LASER_KERF_ACRYLIC_60mil = .3; 
// this is an adjustment to the material width which accounts for
// the small amount of material lost in the cut.
// not sure yet whether this depends on the material/thickness.
// i suspect that it might depend on the laser power/speed,
// which is determined by the material/thickness


module laser_fiducial() {
    polygon([[0, 0], [0, 1], [1, 0]]);    
}