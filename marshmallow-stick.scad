include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
include <libs/BOSL2/shapes2d.scad>;
$fn=128;

module pill2(r=1, l=2, h=.5) {
    translate([0, -l/2, 0])
    linear_extrude(height=h) {
        translate([-r, 0, 0]) square([r*2, l]);
        circle(r);
        translate([0, l, 0]) circle(r);
    }
}

h = 10;

module cap_exterior() {
    pill2(4, 17, h);
}

module cap(d1, d2) {
    difference() {
        cap_exterior();
        translate([0, 8.5, -1]) cylinder(d1=d1, d2=d2, h=h+2);
        #translate([0, -8.5, -1]) cylinder(d1=d1, d2=d2, h=h+2);
        translate([1.0, -6, h-0.49]) 
         linear_extrude(0.5) 
          rotate([0, 0, 90])
           text("s'more", size=3); 
           //text(str(d1), size=3);
    }
}

//cap(3, 2.5);

//translate([-20, 0, 0]) cap(2.5);
//translate([-10, 0, 0]) cap(2.45);
//translate([0, 0, 0]) cap(2.4);
//translate([10, 0, 0]) cap(2.35);


d1 = 14.5;
l1 = 105;

module handle() {
 cylinder(d=d1, h=l1);
}

module handle_sheath(h=l1) {
 cylinder(d1=d1-0.25, d2=d1, h);
}


// pill2(4, 17, 10);


t = 2;    // wall thicknes
x = 25;   // spacing between sticks
n = 5;    // number of sticks
hh = 30;  // height

module holder() {
 difference() {
  down(18.5) linear_extrude(hh+18.5) round2d(r=d1/2+t-.1) square([x*(n-1)+d1+2*t, d1+2*t]);
  
  back(d1+2*t) xrot(-45) cube([120, 50, 50], anchor=[-1,-1,1]);
  #down(1) right(d1/2+t+(n-1)/2*x) xrot(45) up(6) cylinder(d=6.5, h=30, anchor=[0,0,1]);
  
  for(i=[0:n-1]) {
   #up(2) back(d1/2+t) right(d1/2+t + i*x) handle_sheath(hh);
  }
  vv = 2;
  for(i=[0:n-2]) {
   back(t+d1) right(t+d1+(x-d1-8)*.5+i*x) up(t) xrot(90) 
   linear_extrude(25) round2d(r=4-.1) square([8, hh-2*t]);
   back(3*t+d1) right(vv+t+d1+(x-d1-8)*.5+i*x) up(vv+t) xrot(90) 
   linear_extrude(25) round2d(r=(4-vv)-.1) square([8-2*vv, hh-4*t]);
  }
 }
}

//holder();

module stand() {

}

//stand();

module stand_holder() {
 union() {
  holder();
  stand();
 }
}

stand_holder();