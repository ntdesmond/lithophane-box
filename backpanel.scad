include <common.scad>
use <battery-box/battery-box.scad>

//only for preview
use <lithophane-box.scad>

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

module placed_battery_box(battery_vars) {
  rotate([180, 0, 90])
    translate([0, 0, -get_battery_box_dimensions(battery_vars).z])
      battery_box_cutout(battery_vars);
}

module backpanel(wall_thickness, backing_vars, lithophane_vars, battery_vars) {
  backing_thickness = get_backing_thickness(backing_vars);
  backing_lip_depth = get_backing_lip_depth(backing_vars);

  difference() {
    color("#055366ab") {
      linear_extrude(backing_thickness) {
        box_surface(wall_thickness, lithophane_vars);
      }
      translate([0, 0, backing_thickness]) {
        linear_extrude(backing_lip_depth) {
          difference() {
            lithophane_surface(lithophane_vars);
            offset(delta=-1) {
              lithophane_surface(lithophane_vars);
            }
          }
        }
      }
    }
    placed_battery_box(battery_vars);

    translate([0, get_lithophane_height(lithophane_vars) / 2 * 0.7, -0.01])
      keyhole(diameter=6);
  }
  if ($preview) {
    color("#d882")
      placed_battery_box(battery_vars);
  }
}

backpanel(
  get_wall_thickness(packed_frame_vars()),
  packed_backing_vars(),
  packed_lithophane_vars(),
  packed_battery_vars()
);
