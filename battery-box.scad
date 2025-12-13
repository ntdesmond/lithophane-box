use <spring.scad>;

$fs = 0.5;

aaa_battery_size = [10.5, 45];
aa_battery_size = [14.5, 50.5];

thickness = 0.8;

battery_count = 3; // I use 3xAAA for 5v LED strip
stack_in_line = true;
spacing = [0.7, 0.5];

spring_thickness = 0.5;
spring_size = [aaa_battery_size.x, 3, aaa_battery_size.x - 0.05];

parallel_cells_length = aaa_battery_size.y + spring_size.y + spacing.y;

module inline_separator() {
  translate([0, spacing.y, aaa_battery_size.x]) {
    rotate([90, 90, 0]) {
      linear_extrude(spacing.y) {
        difference() {
          polygon([[0, 0], [1, 0], [1, 1], [0, 1], [0.5, 0.5]] * aaa_battery_size.x);
          hull() {
            translate([0.5, 0.5] * aaa_battery_size.x) circle(r=0.3 * aaa_battery_size.x);
            translate([0, 0.2] * aaa_battery_size.x) square([0.1, 0.6] * aaa_battery_size.x);
          }
        }
      }
    }
  }
}

module parallel_separator() {
  translate([0, 0, aaa_battery_size.x]) {
    rotate([0, 90, 0]) {
      linear_extrude(spacing.x) {
        intersection() {
          offset(r=-1)
            offset(r=2) {
              polygon(
                [
                  for (
                    dim = [
                      [0.1, 0],
                      [1, 0],
                      [1, 1],
                      [0.1, 1],
                      [0.1, 0.85],
                      [0.5, 0.85],
                      [0.5, 0.15],
                      [0.1, 0.15],
                    ]
                  ) [dim.x * aaa_battery_size.x, dim.y * parallel_cells_length],
                ]
              );
            }
          square([aaa_battery_size.x, parallel_cells_length]);
        }
      }
    }
  }
}

module cell_with_spring() {
  spring_offset = [0, 0.5];
  spring(spring_size);
  linear_extrude(thickness)
    translate([0, spring_size.y] + spring_offset)
      square(aaa_battery_size - spring_offset);
}

module cell_without_spring() {
  linear_extrude(thickness)
    square(aaa_battery_size);
}

module terminal() {
  translate([0, spacing.y, aaa_battery_size.x]) {
    rotate([90, 90, 0]) {
      linear_extrude(spacing.y) {
        square(aaa_battery_size.x);
      }
    }
  }
}

module wall() {
  linear_extrude(height=aaa_battery_size.x)
    square([spacing.x, parallel_cells_length]);
}

module battery_box() {
  first_cell_size = [aaa_battery_size.x, spring_size.y + aaa_battery_size.y];
  inline_cell_size = [aaa_battery_size.x, spacing.y + aaa_battery_size.y];
  parallel_cell_size = [spacing.x + aaa_battery_size.x, aaa_battery_size.y];
  if (stack_in_line) {
    //TODO: walls and terminal
    cell_with_spring();
    for (i = [1:battery_count - 1]) {
      offset = [0, first_cell_size.y + inline_cell_size.y * (i - 1)];
      translate(offset) {
        inline_separator();
        translate([0, spacing.y]) cell_without_spring();
      }
    }
  } else {
    wall();
    translate([spacing.x + first_cell_size.x + parallel_cell_size.x * (battery_count - 1), 0, 0]) wall();
    translate([spacing.x, 0, 0]) {
      cell_with_spring();
      translate([0, first_cell_size.y, 0]) terminal();
      for (i = [1:battery_count - 1]) {
        offset = [first_cell_size.x + parallel_cell_size.x * (i - 1), 0];
        translate(offset) {
          parallel_separator();
          if (i % 2 == 1) {
            translate([0, first_cell_size.y + spacing.y])
              mirror([0, 1, 0]) {
                translate([spacing.x, 0]) cell_with_spring();
                translate([spacing.x, first_cell_size.y, 0]) terminal();
              }
          } else {
            translate([spacing.x, 0]) cell_with_spring();
            translate([spacing.x, first_cell_size.y, 0]) terminal();
          }
        }
      }
    }
  }
}

battery_box();
// cell_with_spring();
