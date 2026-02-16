include <common.scad>

//only for preview
use <lithophane-box.scad>
frame_vars = packed_frame_vars();
lithophane_vars = packed_lithophane_vars();
backing_vars = packed_backing_vars();

notch_width = frame_notch_width;
notch_height = frame_notch_height;

module notch() {
  color("#ca5a109f") {
    translate([-notch_width / 2, 0, notch_height]) {
      rotate([0, 90, 0]) {
        linear_extrude(height=notch_width) {
          polygon(
            points=[
              [-notch_height / 2, 0],
              [notch_height, 0],
              [0, notch_height],
            ]
          );
        }
      }
    }
  }
}

function get_notch_offset(frame_vars, lithophane_vars) =
  let (
    lithophane_width = get_lithophane_width(lithophane_vars),
    lithophane_height = get_lithophane_height(lithophane_vars),
    lithophane_thickness = get_lithophane_thickness(lithophane_vars),
    lip_depth = get_lip_depth(frame_vars)
  ) [
      lithophane_width / 2 - notch_width * 1.5,
      -lithophane_height / 2,
      lip_depth + lithophane_thickness,
  ];

module notch_pair(notch_offset) {
  translate([0, notch_offset.y, 0]) notch();
  mirror([0, 1, 0]) translate([0, notch_offset.y, 0]) notch();
}

module led_strip(frame_vars, lithophane_vars) {
  translate(
    [0, 0, get_led_strip_start(frame_vars, lithophane_vars)]
  ) {
    color("#e7f071ff") {
      linear_extrude(led_strip_thickness) {
        difference() {
          offset(delta=0.3) lithophane_surface(lithophane_vars);
          offset(delta=-1) lithophane_surface(lithophane_vars);
        }
      }
    }
    color("#000") {
      translate([0, get_lithophane_height(lithophane_vars) / 2 - 1, 3])
        rotate([90, 0, 0])
          linear_extrude(height=0.01)
            text("LED Strip preview", size=3, halign="center");
    }
  }
}

module frame_with_notches(frame_vars, backing_vars, lithophane_vars) {
  lip_depth = get_lip_depth(frame_vars);
  color("#0abeebab") {
    // walls
    linear_extrude(
      height=get_wall_height(frame_vars, backing_vars, lithophane_vars)
    ) {
      difference() {
        box_surface(get_wall_thickness(frame_vars), lithophane_vars);
        lithophane_surface(lithophane_vars);
      }
    }

    // lip (thin frame in front of lithophane)
    linear_extrude(lip_depth) {
      lip_corner_radius = get_lip_corner_radius(frame_vars);
      lip_width = get_lip_width(frame_vars);

      difference() {
        lithophane_surface(lithophane_vars);
        offset(r=lip_corner_radius)
          offset(delta=-(lip_corner_radius + lip_width))
            lithophane_surface(lithophane_vars);
      }
    }
  }

  notch_offset = get_notch_offset(frame_vars, lithophane_vars);

  // notches to secure lithophane in place
  translate([0, 0, notch_offset.z]) {
    translate([notch_offset.x, 0, 0]) notch_pair(notch_offset);
    translate([-notch_offset.x, 0, 0]) notch_pair(notch_offset);
  }
}

module frame(frame_vars, backing_vars, lithophane_vars) {

  difference() {
    frame_with_notches(frame_vars, backing_vars, lithophane_vars);
    led_strip(frame_vars, lithophane_vars);
  }
  if ($preview) {
    led_strip(frame_vars, lithophane_vars);
  }
}

frame(frame_vars, backing_vars, lithophane_vars);
