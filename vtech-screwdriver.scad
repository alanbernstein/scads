$fn=128;

// screw head dimensions
W=16-1;  // phillips wing width
T=6-1;   // phillips wing thickness
D=10;    // depth of phillips head
D2=11;   // depth of hex head
id=22;   // inner diameter of hex head


module driver_cross_section() {
union() {
   square([W, T], center=true);
   square([T, W], center=true);
  }
}

module driver_head() {
 minkowski() {
  linear_extrude(D) union() {
   square([W-2, T-2], center=true);
   square([T-2, W-2], center=true);
  }
  sphere(1);
 }
}

module driver1(L1=60, L2=15) {
// phillips driver, hex handle that matches wrench, blocky transition
// L1 = handle length
// L2 = transition length
 translate([0, 0, -D]) linear_extrude(D) driver_cross_section();
 hull() {
  translate([0, 0, -D]) linear_extrude(1) driver_cross_section();
  translate([0, 0, -D-L2]) linear_extrude(1) circle(d=id, $fn=6);
 }
 translate([0, 0, -D-L2-L1]) linear_extrude(L1) circle(d=id, $fn=6);
}
 
module driver_transition(L2) {
   // L2 = transition length
   hull() {
    translate([0, 0, 0]) linear_extrude(1) { 
     minkowski() {
      circle(1); 
      square([W-2, T-2], center=true);
     }
    };
    translate([0, 0, -L2]) linear_extrude(1) circle(d=id*2/sqrt(3), $fn=6);
   }
   hull() {
    translate([0, 0, 0]) linear_extrude(1) { 
     minkowski() {
      circle(1); 
      square([T-2, W-2], center=true);
     }
    };
    translate([0, 0, -L2]) linear_extrude(1) circle(d=id*2/sqrt(3), $fn=6);
   }

}
 
 module driver2(L1=45, L2=15) {
 // phillips driver, hollow hex handle that matches wrench, smoothish transition between them
 difference() {
  union() {
   driver_head();
   driver_transition(L2);
   translate([0, 0, -L1-L2]) cylinder(d=id*2/sqrt(3), h=L1, $fn=6); // handle
  } 
  // interior void of handle
  translate([0, 0, -L2-1]) cylinder(d1=id*2/sqrt(3)-3, d2=0, h=L2, $fn=6);
  translate([0, 0, -L1-L2-1]) cylinder(d=id*2/sqrt(3)-3, h=L1, $fn=6);
 }
}

 module driver3(L1=45, L2=15) {
 // phillips driver, hollow hex handle that matches wrench, socket driver
 // L1 = handle length
 // L2 = transition length
 difference() {
  union() {
   driver_head();
   driver_transition(L2);
   translate([0, 0, -L1+D2-L2]) cylinder(d=id*2/sqrt(3), h=L1-D2, $fn=6); // handle
   translate([0, 0, -L1-L2]) cylinder(d=id*2/sqrt(3)+6, h=D2, $fn=6); // socket
   hull() {
    translate([0, 0, -L1-L2+D2+5]) cylinder(d=id*2/sqrt(3), h=1, $fn=6);
    translate([0, 0, -L1-L2+D2]) cylinder(d=id*2/sqrt(3)+6, h=1, $fn=6);
   }
  } 
  // interior void of handle
  translate([0, 0, -L2-1]) cylinder(d1=id*2/sqrt(3)-3, d2=10, h=L2, $fn=6);
  translate([0, 0, -L1+D2-L2-2]) cylinder(d=id*2/sqrt(3)-3, h=L1-D2+1+.05, $fn=6);
  // socket void
  translate([0, 0, -L1-L2-2]) cylinder(d=id*2/sqrt(3)+0.5, h=12, $fn=6); 
  translate([0, 0, -L1-3-2.05]) cylinder(d1=id*2/sqrt(3)+0.5, d2=id*2/sqrt(3)-4, h=4, $fn=6); 
 }
}

difference() {
//driver1();
//driver2();
driver3();
//translate([-50, 0, -100]) cube(100);
} 