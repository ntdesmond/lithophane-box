use <spring.scad>;
use <terminal.scad>;

$fs = 0.5;

aaa_battery_size = [10.5, 45];
aa_battery_size = [14.5, 50.5];

thickness = 0.8;

battery_count = 3; // I use 3xAAA for 5v LED strip
stack_in_line = !true;
spacing = [0.7, 0.5];

spring_thickness = 0.5;
spring_size = [aaa_battery_size.x, 3, aaa_battery_size.x - 0.05];

cell_with_spring_length = aaa_battery_size.y + spring_size.y + spacing.y;
cell_without_spring_length = aaa_battery_size.y + spacing.y;

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
        difference() {
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
                    ) [dim.x * aaa_battery_size.x, dim.y * cell_with_spring_length],
                  ]
                );
              }
            square([aaa_battery_size.x, cell_with_spring_length]);
          }
          slot_offset = spacing.y;
          slot_width = spacing.y * 1.5;
          translate(
            [
              aaa_battery_size.x * 0.15,
              cell_with_spring_length - slot_offset - slot_width,
            ]
          )
            square([aaa_battery_size.x * 0.7, slot_width]);
          translate([aaa_battery_size.x * 0.15, slot_offset])
            square([aaa_battery_size.x * 0.7, slot_width]);
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

module wall(length) {
  linear_extrude(height=aaa_battery_size.x)
    square([spacing.x, length]);
}

module wall_without_spring() {
  wall(cell_without_spring_length);
}

module terminal_sized() {
  terminal([aaa_battery_size.x, spacing.y, aaa_battery_size.x]);
}

module battery_box() {
  first_cell_size = [aaa_battery_size.x, spring_size.y + aaa_battery_size.y];
  inline_cell_size = [aaa_battery_size.x, spacing.y + aaa_battery_size.y];
  parallel_cell_size = [spacing.x + aaa_battery_size.x, aaa_battery_size.y];
  if (stack_in_line) {
    wall_length = cell_with_spring_length + cell_without_spring_length * (battery_count - 1);
    wall(wall_length);
    translate([spacing.x, 0]) {
      cell_with_spring();
      translate([spring_size.x, 0]) {
        wall(wall_length);
      }
    }
    if (battery_count > 1) {
      for (i = [1:battery_count - 1]) {
        offset = [0, first_cell_size.y + inline_cell_size.y * (i - 1)];
        translate(offset) {
          translate([spacing.x, 0]) {
            inline_separator();
            translate([0, spacing.y]) cell_without_spring();
          }
        }
      }
    }
    translate(
      [spacing.x, first_cell_size.y + inline_cell_size.y * (battery_count - 1)]
    ) {
      terminal_sized();
    }
  } else {
    wall(cell_with_spring_length);
    translate(
      [
        spacing.x + first_cell_size.x + parallel_cell_size.x * (battery_count - 1),
        0,
      ]
    ) {
      wall(cell_with_spring_length);
    }
    translate([spacing.x, 0]) {
      cell_with_spring();
      translate([0, first_cell_size.y, 0]) terminal_sized();
      if (battery_count > 1) {
        for (i = [1:battery_count - 1]) {
          offset = [first_cell_size.x + parallel_cell_size.x * (i - 1), 0];
          translate(offset) {
            parallel_separator();
            if (i % 2 == 1) {
              translate([0, first_cell_size.y + spacing.y])
                mirror([0, 1, 0]) {
                  translate([spacing.x, 0]) cell_with_spring();
                  translate([spacing.x, first_cell_size.y, 0]) terminal_sized();
                }
            } else {
              translate([spacing.x, 0]) cell_with_spring();
              translate([spacing.x, first_cell_size.y, 0]) terminal_sized();
            }
          }
        }
      }
    }
  }
}

battery_box();
