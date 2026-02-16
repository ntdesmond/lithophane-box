use <frame.scad>
use <backpanel.scad>
use <switch.scad>
use <battery-box/common.scad>
use <battery-box/battery-box.scad>
use <common.scad>

/* [Parts] */
show_frame = true;
show_backpanel = true;
show_battery_box = true;

/* [Lithophane] */
lithophane_width = 120;
lithophane_height = 90;
lithophane_thickness = 4; // .1

function packed_lithophane_vars() =
  [
    lithophane_width,
    lithophane_height,
    lithophane_thickness,
  ];
lithophane_vars = packed_lithophane_vars();

/* [Frame] */
wall_thickness = 3; // .1
lip_depth = 1; // .1
lip_width = 0.2; // .1
lip_corner_radius = 3; // .1
led_strip_thickness = 8; // .1
led_lithophane_spacing = 7; // .1
led_backing_spacing = 8; // .1
frame_notch_width = 6; // .1
frame_notch_height = 1.2; // .1

function packed_frame_vars() =
  [
    wall_thickness,
    lip_depth,
    lip_width,
    lip_corner_radius,
    led_strip_thickness,
    led_lithophane_spacing,
    led_backing_spacing,
    frame_notch_width,
    frame_notch_height,
  ];
frame_vars = packed_frame_vars();

/* [Backing] */
backing_thickness = 3; // .1
backing_lip_depth = 2; // .1
function packed_backing_vars() =
  [
    backing_thickness,
    backing_lip_depth,
  ];
backing_vars = packed_backing_vars();

/* [Battery box] */
battery_count = 3; // I use 3xAAA for 5v LED strip
stack_in_line = false;
notch_width = 0.8; // .1
battery_type = 1; // [0:AA, 1:AAA]'
battery_box_rotation = 90; // 90

function packed_battery_vars() =
  [
    battery_count,
    stack_in_line,
    notch_width,
    battery_type,
    battery_box_rotation,
  ];
battery_vars = packed_battery_vars();

module switch_placed(wall_height, lithophane_vars) {
  lithophane_width = get_lithophane_width(lithophane_vars);
  lithophane_height = get_lithophane_height(lithophane_vars);

  translate(
    [
      -(lithophane_width / 2 + wall_thickness),
      -(lithophane_height / 2 - 3),
      wall_height - get_switch_body_dimensions().z,
    ]
  )
    switch(body_offset=0.1);
}

if (show_frame) {
  difference() {
    frame(frame_vars, backing_vars, lithophane_vars);
    switch_placed(
      get_wall_height(frame_vars, backing_vars, lithophane_vars),
      lithophane_vars
    );
  }
}

if (show_backpanel) {
  lithophane_height = get_lithophane_height(lithophane_vars);
  wall_thickness = get_wall_thickness(frame_vars);
  wall_height = get_wall_height(frame_vars, backing_vars, lithophane_vars);
  backing_thickness = get_backing_thickness(backing_vars);

  backpanel_placement = [0, 0, wall_height + backing_thickness];
  backpanel_rotation = [180, 0, 0];
  backpanel_y_offset = show_frame || show_battery_box ? lithophane_height + wall_thickness * 3 : 0;

  translate([0, backpanel_y_offset, 0]) {
    rotate(backpanel_rotation) {
      translate(-backpanel_placement) {
        difference() {
          translate(backpanel_placement) {
            rotate(backpanel_rotation) {
              backpanel(wall_thickness, backing_vars, lithophane_vars, battery_vars);
            }
          }
          switch_placed(wall_height, lithophane_vars);
        }
      }
    }
  }
}

if (show_battery_box) {
  battery_box_dimensions = get_battery_box_dimensions(battery_vars);
  rotate([0, 0, get_battery_box_rotation(battery_vars)])
    translate(
      -[
        battery_box_dimensions.x / 2,
        battery_box_dimensions.y / 2,
        0,
      ]
    )
      battery_box(battery_vars);
}
