use <vars.scad>;

function get_battery_box_rotation(vars) = vars[4];

function get_battery_box_dimensions(vars) =
  let (
    stack_in_line = get_stack_in_line(vars),
    battery_count = get_battery_count(vars),
    battery_size = get_battery_size(vars),
    cell_with_spring_length = get_cell_with_spring_length(vars),
    cell_without_spring_length = get_cell_without_spring_length(vars),
    spacing = get_spacing()
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
