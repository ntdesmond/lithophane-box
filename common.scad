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

lithophane_offset = 1;
led_strip_thickness = 10;
led_lithophane_spacing = 7;

backpanel_thickness = 5;
backpanel_protrusion = 5;
led_backpanel_spacing = 5;

function get_led_strip_start(lithophane_thickness) =
  lithophane_offset + lithophane_thickness + led_lithophane_spacing;

function get_wall_height(lithophane_thickness) =
  get_led_strip_start(lithophane_thickness) + (
    led_strip_thickness
  ) + (
    backpanel_protrusion
  ) + (
    led_backpanel_spacing
  );

wall_thickness = 5;

frame_notch_width = 10;
frame_notch_height = 1.2;

module lithophane_surface(vars) {
  square(size=get_lithophane_size(vars), center=true);
}

module box_surface(vars) {
  offset(r=wall_thickness) {
    lithophane_surface(vars);
  }
}
