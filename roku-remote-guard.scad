use <./utils.scad>;

$fn=128;

module guard_profile() {
    // https://makerworld.com/en/models/650493
    projection() translate([0, -95, 0]) import("roku-remote-cover-v5.stl");
}

// rounded-rectangle button
module button(w, h, x, y, r) {
    //translate([x, y]) square([w, h], center=true);
    translate([x-w/2, y-h/2]) rounded_square2([w, h], r);
}

module buttons_top() {
    circle(d=8);  // power button = origin
    translate([0, 7.5]) circle(d=3); // mic port
    button(14, 8, 8, 14, 2);       // back
    button(14, 8, -8, 14, 2);      // home
}

module buttons_all() {
    circle(d=7);  // power button = origin
    translate([0, 7.5]) circle(d=3); // mic port
    button(14, 8, 7.5, 15, 2);       // back
    button(14, 8, -7.5, 15, 2);      // home
    translate([0, 37]) circle(d=30); // d-pad
    button(7, 5, 0, 59, 2);          // mic
    button(9, 5, 11, 59, 2);         // reload
    button(9, 5, -11, 59, 2);        // star
    button(14, 9, 0, 69, 2);         // play
    button(6, 9, 13, 69, 2);         // rewind
    button(6, 9, -13, 69, 2);         // forward
}

module top_guard() {
    difference() {
        linear_extrude(27.5) guard_profile();
        translate([0, 0, 27-3-3.5]) 
         rotate([-90, 0, 0]) 
          linear_extrude(10) 
           #buttons_top();
    }
}

top_guard();

//buttons_top();