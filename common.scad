$fs = 0.5;

// Lithophane
function get_lithophane_width(vars) = vars[0];
function get_lithophane_height(vars) = vars[1];
function get_lithophane_thickness(vars) = vars[2];
function get_lithophane_size(vars) =
  let (
    lithophane_width = get_lithophane_width(vars),
    lithophane_height = get_lithophane_height(vars)
  ) [lithophane_width, lithophane_height];

// Frame
function get_lip_depth(vars) = vars[0];
function get_wall_thickness(vars) = vars[1];

// Back panel
backpanel_thickness = 5;
backpanel_protrusion = 5;

// Advanced
led_strip_thickness = 10;
led_lithophane_spacing = 7;
led_backpanel_spacing = 5;
frame_notch_width = 10;
frame_notch_height = 1.2;

function get_led_strip_start(frame_vars, lithophane_vars) =
  let (
    lip_depth = get_lip_depth(frame_vars),
    lithophane_thickness = get_lithophane_thickness(lithophane_vars)
  ) (
    lip_depth + lithophane_thickness + led_lithophane_spacing
  );

function get_wall_height(frame_vars, lithophane_vars) =
  get_led_strip_start(frame_vars, lithophane_vars) + (
    led_strip_thickness
  ) + (
    backpanel_protrusion
  ) + (
    led_backpanel_spacing
  );

module lithophane_surface(lithophane_vars) {
  square(size=get_lithophane_size(lithophane_vars), center=true);
}

module box_surface(wall_thickness, lithophane_vars) {
  offset(r=wall_thickness) {
    lithophane_surface(lithophane_vars);
  }
}
