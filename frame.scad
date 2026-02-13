include <common.scad>

//only for preview
use <lithophane-box.scad>
default_vars = packed_lithophane_vars();

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

function get_notch_offset(lithophane_vars) =
  let (
    lithophane_width = get_lithophane_width(lithophane_vars),
    lithophane_height = get_lithophane_height(lithophane_vars),
    lithophane_thickness = get_lithophane_thickness(lithophane_vars)
  ) [
      lithophane_width / 2 - notch_width * 1.5,
      -lithophane_height / 2,
      lithophane_offset + lithophane_thickness,
  ];

module notch_pair(notch_offset) {
  translate([0, notch_offset.y, 0]) notch();
  mirror([0, 1, 0]) translate([0, notch_offset.y, 0]) notch();
}

module led_strip(lithophane_vars) {
  translate([0, 0, get_led_strip_start(get_lithophane_thickness(lithophane_vars))]) {
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

module frame_with_notches(lithophane_vars) {
  union() {
    color("#0abeebab") {
      // walls
      linear_extrude(
        height=get_wall_height(
          get_lithophane_thickness(lithophane_vars)
        )
      ) {
        difference() {
          box_surface(lithophane_vars);
          lithophane_surface(lithophane_vars);
        }
      }

      // thin frame in front of lithophane
      linear_extrude(lithophane_offset) {
        difference() {
          lithophane_surface(lithophane_vars);
          offset(r=3) offset(delta=-4) lithophane_surface(lithophane_vars);
        }
      }
    }

    notch_offset = get_notch_offset(lithophane_vars);

    // notches to secure lithophane in place
    translate([0, 0, notch_offset.z]) {
      translate([notch_offset.x, 0, 0]) notch_pair(notch_offset);
      translate([-notch_offset.x, 0, 0]) notch_pair(notch_offset);
    }
  }
}

module frame(lithophane_vars) {
  if ($preview) {
    union() {
      frame_with_notches(lithophane_vars);
      led_strip(lithophane_vars);
    }
  } else {
    difference() {
      frame_with_notches(lithophane_vars);
      led_strip(lithophane_vars);
    }
  }
}

frame(default_vars);
