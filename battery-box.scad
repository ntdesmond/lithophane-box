$fs = 0.5;

aaa_battery_size = [10.5, 45];
aa_battery_size = [14.5, 50.5];

thickness = 1.5;

battery_count = 3; // I use 3xAAA for 5v LED strip
stack_in_line = !true;
spacing = [0.7, 0.5];

spring_thickness = 0.5;

module spring_half() {

  // dont even ask
  line = concat(
    // flat line
    [[3, 2]],
    // wide curve
    [for (i = [1.5:-0.05:-1.5]) [i, sqrt(1 - ( (i - 1.5) / 3) ^ 2) * 2]],
    // semi-circle (half of the spring)
    [for (i = [-1.5:0.05:0]) [i, -sqrt(1 - ( (i + 0.75) / 0.75) ^ 2) * 0.75]]
  );

  offset(r=spring_thickness / 2)
    polygon(concat(line, [for (i = [len(line) - 1:-1:0]) line[i] + [0.001, 0.001]]));
}

module spring_one_side() {
  spring_half();
  rotate([0, 0, 180]) spring_half();
}

module spring() {
  linear_extrude(aaa_battery_size.x)
    scale(aaa_battery_size.x / (12 + spring_thickness)) {
      translate([-3, 0, 0]) spring_one_side();
      mirror([1, 0, 0]) translate([-3, 0, 0]) spring_one_side();
    }
}

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
                  for (dim = [[0.1, 0], [1, 0], [1, 1], [0.1, 1], [0.1, 0.85], [0.5, 0.85], [0.5, 0.15], [0.1, 0.15]]) [dim.x * aaa_battery_size.x, dim.y * aaa_battery_size.y],
                ]
              );
            }
          square(aaa_battery_size);
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
              square(aaa_battery_size);
      }

      // battery compartment
      translate([0, 0, thickness]) {
        linear_extrude(aaa_battery_size.x + 0.01) {
          square(
            stack_in_line ?
              [
                aaa_battery_size.x,
                aaa_battery_size.y * battery_count + spacing.y * (battery_count - 1),
              ]
            : [
              aaa_battery_size.x * battery_count + spacing.x * (battery_count - 1),
              aaa_battery_size.y,
            ]
          );
        }
      }
    }

    // separators
    separator_offset =
      stack_in_line ?
        [0, 0, 0]
      : [spacing.x / 2, 0, 0];
    for (i = [1:battery_count - 1]) {
      translate(stack_direction * i) {
        if (stack_in_line) {
          inline_separator();
        } else {
          parallel_separator();
        }
      }
    }
  }
}

battery_box();
spring();
