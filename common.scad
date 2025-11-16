$fs = 0.5;

lithophane_width = 140;
lithophane_height = 100;
lithophane_thickness = 4;
lithophane_offset = 1;
led_strip_thickness = 10;
spacing = 10;

wall_height = lithophane_offset + lithophane_thickness + led_strip_thickness + spacing;
wall_thickness = 5;

lithophane_size = [lithophane_width, lithophane_height];

notch_width = 10;
notch_height = 2;

backpanel_thickness = 5;

module lithophane_surface() {
  square(size=lithophane_size, center=true);
}

module box_surface() {
  offset(r=wall_thickness) {
    lithophane_surface();
  }
}