use <spring.scad>;
use <terminal.scad>;

//only for preview
use <../lithophane-box.scad>
default_vars = packed_battery_vars();

function get_battery_count(vars) = vars[0];
function get_stack_in_line(vars) = vars[1];
function get_notch_width(vars) = vars[2];
function get_battery_type(vars) = vars[3];

/* [Hidden] */
battery_sizes = [
  [14.5, 50.5], // AA
  [10.5, 45], // AAA
];

function get_battery_size(vars) = battery_sizes[get_battery_type(vars)];

thickness = 0.8;
spacing = [0.7, 0.5];

spring_thickness = 0.5;

function get_spring_size(vars) =
  let (
    battery_size = get_battery_size(vars)
  ) [battery_size.x, 3, battery_size.x - 0.05];

function get_cell_without_spring_length(vars) =
  let (
    battery_size = get_battery_size(vars)
  ) battery_size.y + spacing.y;

function get_cell_with_spring_length(vars) =
  let (
    spring_size = get_spring_size(vars)
  ) spring_size.y + get_cell_without_spring_length(vars);

function get_battery_box_dimensions(vars) =
  let (
    stack_in_line = get_stack_in_line(vars),
    battery_count = get_battery_count(vars),
    battery_size = get_battery_size(vars),
    cell_with_spring_length = get_cell_with_spring_length(vars),
    cell_without_spring_length = get_cell_without_spring_length(vars)
  ) (stack_in_line) ?
    [
      battery_size.x + spacing.x * 2,
      // wall_length
      cell_with_spring_length + cell_without_spring_length * (battery_count - 1),
      battery_size.x,
    ]
  : [
    battery_size.x * battery_count + spacing.x * (battery_count + 1),
    cell_with_spring_length,
    battery_size.x,
  ];

function get_notch_height(vars) = get_notch_width(vars) * sqrt(2);

module inline_separator(vars) {
  battery_size = get_battery_size(vars);

  translate([0, spacing.y, battery_size.x]) {
    rotate([90, 90, 0]) {
      linear_extrude(spacing.y) {
        difference() {
          polygon([[0, 0], [1, 0], [1, 1], [0, 1], [0.5, 0.5]] * battery_size.x);
          hull() {
            translate([0.5, 0.5] * battery_size.x) circle(r=0.3 * battery_size.x);
            translate([0, 0.2] * battery_size.x) square([0.1, 0.6] * battery_size.x);
          }
        }
      }
    }
  }
}

module parallel_separator(vars) {
  battery_size = get_battery_size(vars);
  cell_with_spring_length = get_cell_with_spring_length(vars);

  translate([0, 0, battery_size.x]) {
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
                    ) [dim.x * battery_size.x, dim.y * cell_with_spring_length],
                  ]
                );
              }
            square([battery_size.x, cell_with_spring_length]);
          }
          slot_offset = spacing.y;
          slot_width = spacing.y * 1.5;
          translate(
            [
              battery_size.x * 0.15,
              cell_with_spring_length - slot_offset - slot_width,
            ]
          )
            square([battery_size.x * 0.7, slot_width]);
          translate([battery_size.x * 0.15, slot_offset])
            square([battery_size.x * 0.7, slot_width]);
        }
      }
    }
  }
}

module cell_with_spring(vars) {
  spring_size = get_spring_size(vars);
  battery_size = get_battery_size(vars);

  spring_offset = [0, 0.5];
  spring(spring_size);
  linear_extrude(thickness)
    translate([0, spring_size.y] + spring_offset)
      square(battery_size - spring_offset);
}

module cell_without_spring(vars) {
  battery_size = get_battery_size(vars);

  linear_extrude(thickness)
    square(battery_size);
}

module wall(vars, length) {
  battery_size = get_battery_size(vars);

  linear_extrude(height=battery_size.x)
    square([spacing.x, length]);
}

module wall_without_spring(vars) {
  wall(vars, get_cell_without_spring_length(vars));
}

module terminal_sized(vars) {
  battery_size = get_battery_size(vars);

  terminal([battery_size.x, spacing.y, battery_size.x]);
}

module notch(vars) {
  box_dimensions = get_battery_box_dimensions(vars);
  notch_width = get_notch_width(vars);

  notch_base_size = [
    box_dimensions.x,
    box_dimensions.y,
    0.01,
  ];
  difference() {
    hull() {
      cube(notch_base_size, center=true);
      translate([0, 0, get_notch_height(vars)])
        cube(notch_base_size + notch_width * 2 * [1, 1, 0], center=true);
    }
    cube(box_dimensions, center=true);
  }
}

module battery_box(vars) {
  battery_count = get_battery_count(vars);
  stack_in_line = get_stack_in_line(vars);
  battery_size = get_battery_size(vars);
  cell_with_spring_length = get_cell_with_spring_length(vars);
  cell_without_spring_length = get_cell_without_spring_length(vars);
  spring_size = get_spring_size(vars);

  first_cell_size = [battery_size.x, spring_size.y + battery_size.y];
  inline_cell_size = [battery_size.x, spacing.y + battery_size.y];
  parallel_cell_size = [spacing.x + battery_size.x, battery_size.y];
  if (stack_in_line) {
    wall_length = cell_with_spring_length + cell_without_spring_length * (battery_count - 1);
    wall(vars, wall_length);
    translate([spacing.x, 0]) {
      cell_with_spring(vars);
      translate([spring_size.x, 0]) {
        wall(vars, wall_length);
      }
    }
    if (battery_count > 1) {
      for (i = [1:battery_count - 1]) {
        offset = [0, first_cell_size.y + inline_cell_size.y * (i - 1)];
        translate(offset) {
          translate([spacing.x, 0]) {
            inline_separator(vars);
            translate([0, spacing.y]) cell_without_spring(vars);
          }
        }
      }
    }
    translate(
      [spacing.x, first_cell_size.y + inline_cell_size.y * (battery_count - 1)]
    ) {
      terminal_sized(vars);
    }
  } else {
    wall(vars, cell_with_spring_length);
    translate(
      [
        spacing.x + first_cell_size.x + parallel_cell_size.x * (battery_count - 1),
        0,
      ]
    ) {
      wall(vars, cell_with_spring_length);
    }
    translate([spacing.x, 0]) {
      cell_with_spring(vars);
      translate([0, first_cell_size.y, 0]) terminal_sized(vars);
      if (battery_count > 1) {
        for (i = [1:battery_count - 1]) {
          offset = [first_cell_size.x + parallel_cell_size.x * (i - 1), 0];
          translate(offset) {
            parallel_separator(vars);
            if (i % 2 == 1) {
              translate([0, first_cell_size.y + spacing.y])
                mirror([0, 1, 0]) {
                  translate([spacing.x, 0]) cell_with_spring(vars);
                  translate([spacing.x, first_cell_size.y, 0]) terminal_sized(vars);
                }
            } else {
              translate([spacing.x, 0]) cell_with_spring(vars);
              translate([spacing.x, first_cell_size.y, 0]) terminal_sized(vars);
            }
          }
        }
      }
    }
  }

  box_dimensions = get_battery_box_dimensions(vars);
  translate(
    box_dimensions / 2 + [0, 0, box_dimensions.z / 2 - get_notch_height(vars)]
  )
    notch(vars);
}

module battery_box_cutout(vars) {
  box_dimensions = get_battery_box_dimensions(vars);

  translation_up = [0, 0, box_dimensions.z / 2];
  color("#d888") {
    translate(translation_up) {
      cube(box_dimensions + [0.2, 0.2, 0.2], center=true);
      translate([0, 0, box_dimensions.z / 2 - get_notch_height(vars)])
        notch(vars);
    }
  }
}

if ($preview) {
  box_dimensions = get_battery_box_dimensions(default_vars);
  translate(
    [box_dimensions.x, box_dimensions.y, 0] / 2 + (
      [box_dimensions.x + 10, 0, 0]
    )
  )
    battery_box_cutout(default_vars);
}

battery_box(default_vars);
echo(str("default_vars = ", default_vars));
