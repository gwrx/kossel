/*
   Parametrified Mini Bowden Extruder by m.Neuhauser ( m.neuhauser@gmail.com )

   Primary goal for this parametric extruder is to use this simple
   design for every possible combination of screwheads,
   bearings, diameters and dimensions you have laying around
   so you don't have to buy any specific parts.

   Second goal was to design it to handle flexible filament,
   should be possible, but untested yet.

   Based on "Makergear Filament drive goes Bowden" by Luke321
http://www.thingiverse.com/thing:63674
 */


// To print set flip_output to true:
flip_output = true;

// Bearing & Bolt toggle:
simulation_toggle = true;

m3_nut_diameter            = 3;     // diameter of screw to mount the extruder and tighten the clamp
bearing_diameter           = 16;
bearing_inner_diameter     = 5;
bearing_height             = 5;
bearing_offset             = 0.5;   // Amount to add for bearing chamber (not really used)
hobbed_bolt_diameter       = 9;
hobbed_bolt_inner_diameter = 6;
hobbed_bolt_height         = 17.75; // measured from the mounting plate of the stepper
filament_z_offset          = 14.5;  // offset between mountplate of stepper and
extruder_height            = 20;
extruder_diameter          = 34;    // 25-40 mm - use the diameter of the mounting plate of the stepper
filament_diameter          = 1.75;


// DO NOT CHANGE ANYTHING BELOW THIS LINE!


m3_nut_radius = (m3_nut_diameter/2)+0.3;
m3_wide_radius = m3_nut_diameter/2; 
x_center = 16;
y_center = 21;
filament_offset = x_center+(hobbed_bolt_diameter/2)+(filament_diameter/2);
hobbed_bolt_filament_height = filament_z_offset;

module bearing() {
	color("red")
		translate([bearing_diameter/2+hobbed_bolt_diameter/2+x_center,0-y_center,filament_z_offset-bearing_height/2])
		difference() {
			cylinder(bearing_height, bearing_diameter/2, bearing_diameter/2);
			translate([0,0,-0.5]) cylinder(bearing_height+1, bearing_inner_diameter/2, bearing_inner_diameter/2);

		}
}


module hobbed_bolt() {
	color("green")
		translate([x_center,0-y_center,0])
		difference () {
			cylinder(hobbed_bolt_height,hobbed_bolt_diameter/2,hobbed_bolt_diameter/2);
			translate([0,0,-0.5]) cylinder(hobbed_bolt_height+1, hobbed_bolt_inner_diameter/2, hobbed_bolt_inner_diameter/2);

			translate([0,0,filament_z_offset])
				difference() {
					cylinder(2,hobbed_bolt_diameter/2+1,hobbed_bolt_diameter/2+1);
					cylinder(2,hobbed_bolt_diameter/2-0.5,hobbed_bolt_diameter/2-0.5);
				}
		}
}


module extruder() {
	rotate([90, 0, 0])
		difference() {
			union() {
				//main cylinder
				translate([16,extruder_height,21]) rotate([90,0,0]) cylinder(h=extruder_height, r=(extruder_diameter/2)+1);

				//bearing mount
				translate([bearing_diameter/2+hobbed_bolt_diameter/2+x_center+filament_diameter,extruder_height,21]) rotate([90,0,0]) cylinder (h=extruder_height, r=bearing_diameter/2);

				//pushfit/pneufit mount
				translate([filament_offset-5, 0, 4])
					cube([10, extruder_height, extruder_diameter/2]);

				//filament support
				translate([hobbed_bolt_diameter/2+x_center,filament_z_offset,extruder_diameter/2]) rotate([0,0,0]) cylinder (h=8, r=3, $fn=12);

				//clamp
				translate([hobbed_bolt_diameter/2+x_center-3, 0, 3]) cube([13, extruder_height, extruder_diameter]);
			}

			//pulley opening
			translate([16,extruder_height+1,21]) rotate([90,0,0]){
				cylinder (h=extruder_height+2, r=(hobbed_bolt_diameter/2)+0.5);
				//open pulley opening a bit more for the pulley-screw
				translate([0,0,extruder_height-filament_z_offset+5.1]){
					cylinder (h=filament_z_offset-5, r1=(hobbed_bolt_diameter/2)+3, r2=(hobbed_bolt_diameter/2)+3);
				}

				rotate([0,0,45]) {
					//translate([14,0,0-(extruder_height/2)]) cylinder(h=22, r=1.6, $fn=12);
					translate([0,14,0]) cylinder(h=extruder_height+2, r=m3_nut_radius, $fn=12);
					translate([-14,0,0]) cylinder(h=extruder_height+2, r=m3_nut_radius, $fn=12);
					translate([0,-14,0]) cylinder(h=extruder_height+2, r=m3_nut_radius, $fn=12);
				}
			}

			//gearhead indentation
			translate([16,2,21]) rotate([90,0,0]) cylinder (h=4, r=11.25);

			//pulley hub indentation
			//translate([16,20-2,21]) rotate([90,0,0]) cylinder (h=5.6, r=7);

			//bearing screws
			translate([bearing_diameter/2+hobbed_bolt_diameter/2+x_center+filament_diameter,21,21]) rotate([90,0,0]) cylinder (h=extruder_height+2, r=bearing_inner_diameter/2, $fn=12);
			//translate([bearing_diameter/2+hobbed_bolt_diameter/2+x_center+filament_diameter,22,21]) rotate([90,30,0]) cylinder (h=5.3, r=bearing_inner_diameter/2*1.625, $fn=6);

			//bearing
			difference() {
				union() {
					translate([bearing_diameter/2+hobbed_bolt_diameter/2+x_center+filament_diameter,filament_z_offset+((bearing_height+1)/2),y_center]) rotate([90,0,0])
						cylinder (h=bearing_height+1, r=bearing_diameter/2+1);
				}

			}

			//filament path chamber
			//translate([filament_offset,filament_z_offset,15]) rotate([0,0,0]) 
			cylinder(h=3, r1=0.5, r2=3, $fn=12);

			//filament path
			translate([filament_offset,filament_z_offset,-10]) rotate([0,0,0]) #
				cylinder(h=60, r=(filament_diameter/2)+0.25, $fn=12);

			//pushfit/pneufit mount
			translate([filament_offset, filament_z_offset, 0])  cylinder(r=2.3, h=8, $fn=12);

			//clamp slit
			translate([25,-1,10]) cube([2, extruder_height+2, 35]);

			//clamp screws
			if (extruder_height/2 >= (filament_z_offset)) {
				translate([10,extruder_height/4*3,extruder_diameter]) rotate([0,90,0])
					cylinder(h=16, r=m3_nut_radius-0.3, $fn=6);
				translate([26,extruder_height/4*3,extruder_diameter]) rotate([0,90,0])
					cylinder(h=8, r=m3_wide_radius, $fn=12);
			}

			if (extruder_height/2 <= (filament_z_offset)) {
				translate([10,extruder_height/4,extruder_diameter]) rotate([0,90,0])
					cylinder(h=16, r=m3_nut_radius-0.3, $fn=6);
				translate([26,extruder_height/4,extruder_diameter]) rotate([0,90,0])
					cylinder(h=8, r=m3_wide_radius, $fn=12);
			}


		}
}



module supports() {
	difference() {
		rotate([90,0,0])
			for (z = [21-(bearing_diameter/2):4:21+(bearing_diameter/2)]) {
				translate([bearing_diameter/2+hobbed_bolt_diameter/2+x_center+filament_diameter, filament_z_offset, z])  cube([bearing_diameter, bearing_height+1, 0.5], center=true);
			}


		difference() {
			translate([bearing_diameter/2+hobbed_bolt_diameter/2+x_center,0-y_center,(filament_z_offset-bearing_height/2)-3])
				cylinder(bearing_height+10, (bearing_diameter/2)+20, (bearing_diameter/2)+20);
			color("blue")
				translate([bearing_diameter/2+hobbed_bolt_diameter/2+x_center+filament_diameter,0-y_center,(filament_z_offset-bearing_height/2-5)])
				cylinder(bearing_height+10, (bearing_diameter/2), (bearing_diameter/2));
		}
		translate([25,0-extruder_diameter-3,0]) cube([2, extruder_diameter, extruder_height+1]);


	}
}

module output(){
	output_rotation = flip_output == true ? 180 : 0;
	output_z_translate = flip_output == true ? 0-extruder_height : 0;
	rotate([0,output_rotation,0]) translate([0,0,output_z_translate]) {
		extruder();
		supports();
		if (simulation_toggle == true) {
			bearing();
			hobbed_bolt();
		}
	}
}

output();
