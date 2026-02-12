include <common.scad>
use <battery-box/battery-box.scad>

module keyhole(diameter = 5) {
  radius = diameter / 2;
  height = radius;
  inner_radius = radius * 0.7;
  inner_height = height / 2;
  outer_height = height - inner_height;
  cylinder(h=height, r=radius);
  translate([0, 0, outer_height]) {
    hull() {
      cylinder(h=inner_height, r=radius);
      translate([0, diameter, 0])
        cylinder(h=inner_height, r=radius);
    }
  }
  hull() {
    cylinder(h=height, r=inner_radius);
    translate([0, diameter, 0])
      cylinder(h=height, r=inner_radius);
  }
}

module backpanel(battery_vars) {
  difference() {
    color("#055366ab") {
      linear_extrude(backpanel_thickness) {
        box_surface();
      }
      translate([0, 0, backpanel_thickness]) {
        linear_extrude(backpanel_protrusion) {
          difference() {
            lithophane_surface();
            offset(delta=-1) {
              lithophane_surface();
            }
          }
        }
      }
    }
    rotate([180, 0, 90])
      translate([0, 0, -get_battery_box_dimensions(battery_vars).z])
        battery_box_cutout(battery_vars);

    translate([0, lithophane_height / 2 * 0.7, -0.01])
      keyhole(diameter=6);
  }
}

backpanel();
