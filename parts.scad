include <libs/BOSL2/std.scad>;
include <libs/BOSL2/rounding.scad>;
include <libs/BOSL2/shapes2d.scad>;
include <utils.scad>;
$fn=128;
e = .05;


module semicircle(r, t) {
 difference() {
  circle(r+t/2);
  circle(r-t/2);
  translate([-r-t, -2*r-2*t]) square(2*r+2*t);
 }
}


module spring2d_from_dimensions(t, N, w, l) {
 r = (l - t)/(2*N);
 y = w - 2*r;
 spring2d(r, t, y, N); 
}

module spring2d(r=10, t=2, y=10, N=4) {
// full width = y + 2*r
// length = 2*N*r + t
 translate([r+t/2, r+t/2]) {
  for(n = [0:N-1]) {
   translate([n*2*r, (n%2) * y]) 
    scale([1, (n%2) * 2 - 1]) 
     semicircle(r, t);
  }
  for(n = [-1:N-1]) {
   translate([n*2*r+1*r-t/2, 0]) 
    square([t, y]);
  }
 }
 //#translate([0, 0]) square([2*N*r+t, y+2*r+t]);
}

//spring2d(r=4, t=2, y=20, N=6);
//spring2d(r=2, t=2, y=20, N=6);

//linear_extrude(10) spring2d_from_dimensions(2, 8, 30, 51);
//linear_extrude(5) spring2d_from_dimensions(4, 8, 30, 51);
//linear_extrude(5) spring2d_from_dimensions(4, 6, 15, 51);