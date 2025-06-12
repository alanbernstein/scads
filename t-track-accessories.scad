use <utils.scad>;
//include <libs/BOSL2/geometry.scad>;
//include <libs/BOSL2/std.scad>;
//include <libs/BOSL2/rounding.scad>;
e=.1;
k1 = sqrt(3)/2;  // od = id / k1, for hexagons
$fn = 128;

module ttrack_profile() {
    polygon([
    [0, 0],  // bottom left exterior
    [19, 0], // bottom right exterior
    
    [19, 9.5],  // top right exterior
    [19*0.75, 9.5],
    [19*0.75, 7.2], 
    [19-(19-14.3)/2, 7.2], // top right interior
    [19*.875, 4],
   
    
    [19*.125, 4],
    [(19-14.3)/2, 7.2], // top left exterior
    [19*.25, 7.2], 
    [19*.25, 9.5],  
    [0, 9.5] // top left exterior
    ]);
}
//ttrack_profile();

module ttrack_profile_full() {
    polygon([
    [0, 0],  // bottom left exterior
    [19, 0], // bottom right exterior
    
    [19, 9.5],  // top right exterior
    [19*0.75, 9.5],
    [19*0.75, 7.2], 
    [19-(19-14.3)/2, 7.2], // top right interior
    [19*.875, 4],
    [19-(19-11.1)/2, 4],
    [19-(19-11.1)/2, 2.5],
    [(19-11.1)/2, 2.5],
    [(19-11.1)/2, 4],    
    [19*.125, 4],
    [(19-14.3)/2, 7.2], // top left exterior
    [19*.25, 7.2], 
    [19*.25, 9.5],  
    [0, 9.5] // top left exterior
    ]);
}
//ttrack_profile_full();

module ttrack_insert_profile() {
    S = 0.25; // slop
    translate([-9.5/2, 0]) square([9.5, 9.5-2.5+5]);
    #translate([-14.3/2, 4-2.5+S/2]) square([14.3-S, 3.2-S]);
}

//linear_extrude(5)
//ttrack_insert_profile();


module insert_basic() {
    S = 0.5; // slop
    translate([0, 0, 0]) rounded_cylinder(d=9.5, h=9.5-2.5+2, r=1);
    translate([0, 0, 4-2.5+S/2]) rounded_cylinder(d=14.3-S, h=3.2-S, r=1);
    translate([0, 0, 9.5-2.5]) rounded_cylinder(d=19, h=2, r=1);
}

//insert_basic();

module track_capsule(L=10) {
    S = 0.5; // slop
    translate([0, 0, 0]) rounded_cylinder(d=9.5, h=L-2.5+2, r=1);
    translate([0, -(21-(14.3-S))/2, 0]) pill2(r=(14.3-S)/2, l=21-(14.3-S), h=3.2-S);
}
//track_capsule();

module track_cylinder() {
    cylinder(r=13.5/2, h=3);
}

module stroller_tray_hook() {
    D = 14 - 0.25;
    union() {
        // track_capsule();
        track_cylinder();
        cylinder(r=4, h=6);
        translate([0, 0, 6]) cylinder(r1=4, r2=D/2, h=4);
        translate([0, 0, 10]) cylinder(r=D/2, h=11);
    }
}

//stroller_tray_hook();


module insert_with_hook(L=15) {
    S = 0.5; // slop
    translate([0, 0, 0]) rounded_cylinder(d=9.5, h=L-2.5+2, r=1);
    //translate([0, 0, 4-2.5+S/2]) rounded_cylinder(d=14.3-S, h=3.2-S, r=1);
    translate([0, -(21-(14.3-S))/2, 0]) pill2(r=(14.3-S)/2, l=21-(14.3-S), h=3.2-S);
    //translate([0, 0, 9.5-2.5]) rounded_cylinder(d=19, h=2, r=1);
    translate([-15, 0, L-2]) rotate([90, 0, 0]) 
    union() {
        torus(r1=15, r2=9.5/2, angle_width=90);
        translate([0, 15, 0]) sphere(r=9.5/2);
    }
}

//insert_with_hook(L=10);


module insert_with_stroller_tray_rest() {
    r = 1;
    difference() {
        union() {
            insert_basic();
            translate([0, 0, 9.5-2.5]) rounded_cylinder(d=19, h=7, r=1);        
        }
        translate([0, 0, 9.5-0.5]) stroller_tray_hook();
         translate([-15, 0, 9.5-0.5]) cube([30, 30, 30]);
    }
}

//rotate([90, 0, 0]) 
//insert_with_stroller_tray_rest();


module stroller_tray_hook() {
    D = 14 - 0.25;
    union() {
        // track_capsule();
        cylinder(r=13.5/2, h=3);
        cylinder(r=4, h=6);
        translate([0, 0, 6]) cylinder(r1=4, r2=D/2, h=4);
        translate([0, 0, 10]) cylinder(r=D/2, h=11);
    }
}


//rotate_extrude()
//difference() { 
//    ttrack_insert_profile();
//    square(20);
//};

