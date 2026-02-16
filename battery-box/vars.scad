function get_battery_count(vars) = vars[0];
function get_stack_in_line(vars) = vars[1];
function get_notch_width(vars) = vars[2];
function get_battery_type(vars) = vars[3];

function get_battery_size(vars) = get_battery_sizes()[get_battery_type(vars)];

function get_battery_sizes() = [
  [14.5, 50.5], // AA
  [10.5, 45], // AAA
];
function get_thickness() = 0.8;
function get_spacing() = [0.7, 0.5];
function get_spring_thickness() = 0.5;

function get_spring_size(vars) =
  let (
    battery_size = get_battery_size(vars)
  ) [battery_size.x, 3, battery_size.x - 0.05];

function get_cell_without_spring_length(vars) =
  let (
    battery_size = get_battery_size(vars)
  ) battery_size.y + get_spacing().y;

function get_cell_with_spring_length(vars) =
  let (
    spring_size = get_spring_size(vars)
  ) spring_size.y + get_cell_without_spring_length(vars);

function get_notch_height(vars) = get_notch_width(vars) * sqrt(2);