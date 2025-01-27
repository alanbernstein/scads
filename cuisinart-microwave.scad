use <./utils.scad>;
$fn=128;
e = 0.1;


// measurements
d1 = 7; // screw post diameter
d2 = 12; // "diameter" of bottom fins of screw post
h1 = 15; // height of screw post


x1 = 20; // vertical distance between screw post and center of hinge mount
x2 = 18; // left-right distance between screw post and plastic wall


module screw_post() {
    ww = 1.5;
    cylinder(d=d1, h=h1);
    translate([-d2/2, -ww/2, 0]) cube([d2, ww, 11]);
    translate([-ww/2, -d2/2, 0]) cube([ww, d2, 11]);
}

// rough parameters
W1l = 39;        // half-width of screw-post mount, left side
W1r = 44;        // half-width of screw-post mount, right side (not symmetric)
W1 = W1l + W1r;  // width of screw-post mount
H1 = 20;         // height of screw post mount
W2 = 5;         // width of connector segment
H2 = 27.5;         // height of connector segment

H3 = 15;         // height of hinge segment

// precision parameters
dx = x1 - H3/2; // x offset of hinge part to get correct vertical spacing


module screw_post_fit_test() {
    difference() {
        cylinder(d=20, h=2);
        translate([0, 0, -0.5]) screw_post();
    }    
}

// screw_post_fit_test();

module screw_posts_fit_test() {
    difference() {
        translate([-H1/2, -W1l, e/2]) cube([H1, W1, 1]);
        translate([0, -55/2, 0]) screw_post();
        translate([0, 55/2, 0]) screw_post();
    }    
}

// screw_posts_fit_test();

module fixer() {
    difference() {
        union() {
            translate([-H1/2, -W1l, e/2]) cube([H1, W1, h1 - e]); // screw post mount
            translate([0, W1r-W2, e/2]) cube([H2, W2, h1 - e]); // connector part
            
            // hinge part (hole included)
            translate([dx, W1r - 5, 0])
            difference() {
                cube([H3, 5, 35]);
                #translate([H3/2, 7, 30]) rotate([90, 0, 0]) cylinder(d=5.5, h=10);
            }
            // corner brace 1 (interferes with circuit board)
            /*
            translate([12.5, W1r-W2, 14.5])
             rotate([-90, 0, 0])
              linear_extrude(W2)
               polygon([[0, 0], [0, -20], [-20, 0]]);
            */
            translate([H1/2, W1r-W2, 0]) linear_extrude(h1) polygon([[0, 0], [15, 0], [0, -15]]);
        }
        
        // material removal
        translate([-5, -20, 0]) rounded_square3([10, 40], r=d1/2, h=16);
        // screw post holes
        translate([0, -55/2, 0]) screw_post();
        translate([0, 55/2, 0]) screw_post();
        translate([-15+e, W1r-2+e, -e]) cube([50, 2, 6]);
    }
}

fixer();