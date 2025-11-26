use <spring.scad>;

$fs = 0.5;

aaa_battery_size = [10.5, 45];
aa_battery_size = [14.5, 50.5];

thickness = 0.8;

battery_count = 3; // I use 3xAAA for 5v LED strip
stack_in_line = !true;
spacing = [0.7, 0.5];

spring_thickness = 0.5;
spring_size = [aaa_battery_size.x, 3, aaa_battery_size.x - 0.05];

length_with_spring = aaa_battery_size.y + spring_size.y;

module inline_separator() {
  translate([0, 0, aaa_battery_size.x]) {
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
  translate([-spacing.x, 0, aaa_battery_size.x]) {
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
                  ) [dim.x * aaa_battery_size.x, dim.y * length_with_spring],
                ]
              );
            }
          square([aaa_battery_size.x, length_with_spring]);
        }
      }
    }
  }
}

module battery_box() {
  stack_direction =
    stack_in_line ?
      [0, aaa_battery_size.y + spacing.y, 0]
    : [aaa_battery_size.x + spacing.x, 0, 0];
  translate([thickness, thickness, 0]) {
    difference() {
      // the box itself
      for (i = [0:battery_count - 1]) {
        translate(stack_direction * i)
          linear_extrude(thickness + aaa_battery_size.x)
            offset(r=thickness)
              square(aaa_battery_size + [0, spring_size.y]);
      }

      // battery compartment
      translate([0, 0, thickness]) {
        linear_extrude(aaa_battery_size.x + 0.01) {
          square(
            stack_in_line ?
              [
                aaa_battery_size.x,
                length_with_spring + (aaa_battery_size.y + spacing.y) * (battery_count - 1),
              ]
            : [
              aaa_battery_size.x * battery_count + spacing.x * (battery_count - 1),
              length_with_spring,
            ]
          );
        }
      }
    }

    // separators
    separator_offset =
      stack_in_line ?
        [0, spring_size.y, 0]
      : [0, 0, 0];
    for (i = [1:battery_count - 1]) {
      translate(separator_offset + stack_direction * i) {
        if (stack_in_line) {
          inline_separator();
        } else {
          parallel_separator();
        }
      }
    }

    // springs
    spring_start_offset = [-spring_thickness / 2, 0];
    if (stack_in_line) {
      translate(spring_start_offset) {
        spring(spring_size);
      }
    } else {
      for (i = [0:battery_count - 1]) {
        translate(spring_start_offset + stack_direction * i) {
          spring(spring_size);
        }
      }
    }
  }
}

battery_box();
// spring();
