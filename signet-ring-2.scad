size_diameter_map = [0, 12.04, 12.45, 12.85, 13.26, 13.67, 14, 14.4, 14.8, 15.2, 15.6, 16.0, 16.45, 16.9, 17.3, 17.7, 18.2, 18.6, 19.0, 19.4, 19.8, 20.2, 20.6, 21.0, 21.4, 21.8, 22.2, 22.6];
function ring_radius_from_US_size(size) = size_diameter_map[size*2]/2;

echo(version());


//ring_size = 10.5; cone_angle=60; // alan
ring_size = 2; cone_angle=30; // dana 2025/02


// would prefer to factor these parameter computations into 
// a factored out function...

// high level ring design parameters
rt=2;   // ring band thickness (nominal)
seal_depth = 0.2;
seal_radius_relative = 0.75;
//cone_angle=30;

band_width = 5;

// computed parameters
ri = ring_radius_from_US_size(ring_size);  // ring inner radius
ro=ri+rt;  // ring outer radius (sphere outer radius)
d = ro*sin(cone_angle/2);   // |(sphere center) - (cone base)|
r1 = ro*cos(cone_angle/2);  // cone radius
h = ro/sin(cone_angle/2) - d;  // cone height

r_top = 2*(ro-d)/h*r1; // signet top radius  TODO this equation is wrong
r_logo = r_top * seal_radius_relative;  // radius of containing circle of logo
echo("r_logo", r_logo);
echo("r_top", r_top);
echo(d);


module smooth_ring_base() {
    // https://www.thingiverse.com/thing:2011638/files
    // sphere, cone, shave off top and bottom
    // logo on top
    // inscription on bottom
    // two cubes to make it slanty
    // TODO bevel sharp edge    
    
    difference() {
        union() {
            // main body
            sphere(r=ro, $fn=64);
            // cone
            translate([0, 0, d]) 
                cylinder(r1=r1, r2=0, h=h, $fn=128);
        }

        // shave off the top
        translate([-ro, -ro, ro*1.0]) cube(ro*4);
        // ring hole
        translate([0, ro, 0])
            rotate([90, 0, 0])
                cylinder(r=ri, h=3*ro, $fn=128);

                
        // y offset of these cylinders needs to be at the
        // uppermost intersection of the cone and the 
        // finger-hole cylinder
        // cone:
        // x*x + y*y = R*R*(z-H)**2/H*H  (R = r1*(h+d)/h, H = h+d)
        // cylinder:
        // x*x + z*z = A*A               (A = ri)
        // x = sqrt(A*A-z*z)
        // A*A-z*z + y*y = R*R*(z-H)**2/H*H
        // set z = A, the top of the cylinder
        // A*A-A*A + y*y = R*R*(A-H)**2/H*H
        // y*y = R*R*(A-H)**2/H*H
        A = ri;
        R = r1*(h+d)/h;
        H = h+d;
        yy = R*R*(A-H)*(A-H)/(H*H);
        y = sqrt(yy);
        
        echo(d, ri/2);
        
        // y - yy = band_width/2
        // yy = y - band_width/2
        
        translate([-ro, -y, -ri]) 
            rotate([0, 90, 0]) 
                scale([ri*2, y-band_width/2, 1]) 
                    cylinder(h=ro*2, r=1, $fn=128);
        translate([-ro, +y, -ri]) 
            rotate([0, 90, 0]) 
                scale([ri*2, y-band_width/2, 1]) 
                    cylinder(h=ro*2, r=1, $fn=128);
        
    }
}

module heart(r=1) {
 d = sqrt(2)/2;  // half-diagonal of the square
 union() {
  translate([r*d, r*d]) circle(r=r, $fn=128);
  translate([-r*d, r*d]) circle(r=r, $fn=128);
  rotate(45) square(2*r, center=true);
 }
}



module pilosa_sloth(r=1, h=1) {
    scale([r, r, 1])
    translate([-1, -1, h/2])
        scale([.02, .02, h])
            import(file="logo-sloth-only.svg_1mm.stl", center=true);
}

//pilosa_sloth();

module image_svg(svg, r=1) {
 translate([0, 0, ro-seal_depth])
  scale([.01*r*r_logo, .01*r*r_logo, .1])
   linear_extrude(h)
    import(file=svg, center=true);
}

module ring_base_heart(r) {
    difference() {
        smooth_ring_base();
        translate([0, -r*.4, ro-seal_depth]) linear_extrude(1) heart(r);
    }
}

module ring_image_heart(r) {
    intersection() {
        smooth_ring_base();
        translate([0, -r*.4, ro-seal_depth]) linear_extrude(1) heart(r);    
    }
}


module ring_base_svg(svg, r) {
    difference() {
        smooth_ring_base();
        image_svg(svg, r);
    }
}

module ring_image(svg, r) {
    intersection() {
        smooth_ring_base();
        image_svg(svg, r);
    }
}

//svg = "svg/ballerina-1-norm.svg"; r = 13;
//svg = "svg/ballerina-2-norm.svg"; r = 11;
r = 3; // for heart
translate([0, 0, ri+rt]) rotate([180, 0, 0]) 
{
 //ring_base_svg(svg, r);
 //ring_base_heart(r);
 ring_image_heart(r);
 //heart();
 //color("red") 
 //ring_image(svg, r);
 //image_svg(svg, r);
}

//translate([0, 0, -2]) rotate([90, 0, 0]) cylinder(d=0.2, h=10, $fn=128);

module inscription() {
   // TODO text engraved on the underside of the signet
   // TODO text engraved all along the ring exterior
   // pattern instead of text?
   // solid and hollow circles?
   // negative spherical segments - golfball divots
   // binary encode a message? 
}

module pilosa_ring(ring_size) {
    ri = ring_radius_from_US_size(ring_size);  // ring inner radius
    ro=ri+rt;  // ring outer radius (sphere outer radius)
    d = ro*sin(cone_angle/2);   // |(sphere center) - (cone base)|
    r1 = ro*cos(cone_angle/2);  // cone radius
    h = ro/sin(cone_angle/2) - d;  // cone height

    r_top = 2*(ro-d)/h*r1; // signet top radius  TODO this equation is wrong
    r_logo = r_top * seal_radius_relative;  // radius of containing circle of logo
    difference() {
        smooth_ring_base(ring_size);
        translate([0, 0, ro-seal_depth])
            #pilosa_sloth(r=r_logo, h=1.2);  // seal
        inscription();
    }
}
//pilosa_ring(10.5);


//pilosa_sloth(r=2, h=2);


module alan_wedding_ring() {
    // band width = 5mm
    // band thickness = 2.2mm
    // inner radius = 20.0mm
    // outer radius = 24.5mm
}



/*

angle=7;
d=3;
W0=10;  // max width of ring cylinder
W1=5;   // min width of ring cylinder
rt=2;   // ring thickness
ro=ri+rt;

module ring() {
    difference() {
        cylinder(r=ro, h=W0, $fn=128);
        // TODO adjust angle of cubes to make W0, W1 work
        // TODO subtract off a layer of the ring so signet lies flat
        translate([0, 0, -1]) cylinder(r=ri, h=W0+2, $fn=128);
        translate([0, 0, -d]) rotate([angle, 0, 0]) cube([50, 50, 10], center=true);
        translate([0, 0, W0+d]) rotate([-angle, 0, 0]) cube([50, 50, 10], center=true);
    }
}

module signet() {
    // TODO: put "10101" on the bottom
    difference() {
        cylinder(r=8, h=2, $fn=128);
        scale([-0.08, 0.08, 1])
          translate([-85.87, -85.87, 0])
            import(file="logo-sloth-only.ai.svg_1mm.stl");
    }
}

// v1
//translate([0, W0/2, ro+1]) rotate([90, 0, 0]) ring();
//signet();
*/
