use <frame.scad>
use <backpanel.scad>
use <switch.scad>
include <common.scad>

show_frame = true;
show_backpanel = true;

module switch_placed() {
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
    union() frame();
    switch_placed();
  }
}

if (show_backpanel) {
  backpanel_placement = [0, 0, wall_height + backpanel_thickness];
  backpanel_rotation = [180, 0, 0];
  backpanel_y_offset = show_frame ? lithophane_height + wall_thickness * 3 : 0;

  translate([0, backpanel_y_offset, 0]) {
    rotate(-backpanel_rotation) {
      translate(-backpanel_placement) {
        difference() {
          translate(backpanel_placement) {
            rotate(backpanel_rotation) {
              backpanel();
            }
          }
          switch_placed();
        }
      }
    }
  }
}
