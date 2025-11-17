$fs = 0.5;

lithophane_width = 140;
lithophane_height = 100;
lithophane_thickness = 4;
lithophane_offset = 1;
led_strip_thickness = 10;
led_lithophane_spacing = 7;

backpanel_thickness = 5;
backpanel_protrusion = 5;
led_backpanel_spacing = 5;

led_strip_start = lithophane_offset + lithophane_thickness + led_lithophane_spacing;
wall_height = led_strip_start + led_strip_thickness + backpanel_protrusion + led_backpanel_spacing;
wall_thickness = 5;

lithophane_size = [lithophane_width, lithophane_height];

notch_width = 10;
notch_height = 2;

module lithophane_surface() {
  square(size=lithophane_size, center=true);
}

module box_surface() {
  offset(r=wall_thickness) {
    lithophane_surface();
  }
}
