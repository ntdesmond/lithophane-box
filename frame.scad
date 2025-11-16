include <common.scad>

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

notch_offset = [
  lithophane_width / 2 - notch_width * 1.5,
  -lithophane_height / 2,
  lithophane_offset + lithophane_thickness,
];

module notch_pair() {
  translate([0, notch_offset.y, 0]) notch();
  mirror([0, 1, 0]) translate([0, notch_offset.y, 0]) notch();
}

module frame() {
  color("#0abeebab") {
    // walls
    linear_extrude(height=wall_height) {
      difference() {
        box_surface();
        lithophane_surface();
      }
    }

    // thin frame in front of lithophane
    difference() {
      lithophane_surface();
      offset(r=3) offset(delta=-4) lithophane_surface();
    }
  }

  // notches to secure lithophane in place
  translate([0, 0, notch_offset.z]) {
    translate([notch_offset.x, 0, 0]) notch_pair();
    translate([-notch_offset.x, 0, 0]) notch_pair();
  }
}

frame();
