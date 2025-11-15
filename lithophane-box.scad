$fs = 0.5;

lithophane_width = 140;
lithophane_height = 100;
lithophane_thickness = 4;
lithophane_offset = 1;
led_strip_thickness = 10;
spacing = 10;

wall_height = lithophane_offset + lithophane_thickness + led_strip_thickness + spacing;

lithophane_size = [lithophane_width, lithophane_height];

notch_width = 10;
notch_height = 2;

module lithophane_surface() {
  square(size=lithophane_size, center=true);
}

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

module box() {
  color("#0abeebab") {
    linear_extrude(height=wall_height) {
      difference() {
        offset(r=5) {
          lithophane_surface();
        }
        lithophane_surface();
      }
    }
    difference() {
      lithophane_surface();
      offset(r=3) offset(delta=-4) lithophane_surface();
    }
  }

  translate([0, 0, notch_offset.z]) {
    translate([notch_offset.x, 0, 0]) notch_pair();
    translate([-notch_offset.x, 0, 0]) notch_pair();
  }
}

box();
