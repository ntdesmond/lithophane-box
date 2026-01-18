$fs = 0.5;

base_terminal_size = [10, 1, 10];

module cutout_base(thickness) {
  translate([0, 0, -0.01]) {
    linear_extrude(thickness + 0.02) {
      hull() {
        translate([0, -2, 0]) circle(0.7);
        translate([0, 2, 0]) circle(0.7);
      }
    }
  }
}

module cutout(dimensions) {
  rotate([-90, -90, 0]) {
    translate(v=[dimensions.z / 2 + dimensions.z / 6, dimensions.x / 2, 0])
      cutout_base(dimensions.y);
    translate(v=[dimensions.z / 2 - dimensions.z / 6, dimensions.x / 2, 0])
      cutout_base(dimensions.y);
  }
}

module terminal(dimensions = [9, 0.5, 9]) {
  difference() {
    scale(
      [
        dimensions.x / base_terminal_size.x,
        dimensions.y / base_terminal_size.y,
        dimensions.z / base_terminal_size.z,
      ]
    )
      translate([0, base_terminal_size.y, base_terminal_size.x]) {
        rotate([90, 90, 0]) {
          linear_extrude(base_terminal_size.y) {
            square([base_terminal_size.x, base_terminal_size.z]);
          }
        }
      }
    cutout(dimensions);
  }
}

terminal();
