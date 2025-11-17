// harsh approximation of KCD1-11 switch

front_panel_width = 15;
front_panel_height = 10;
body_depth = 10;

module switch(body_offset = 0) {
  color("#1b1b1be8") {
    translate([body_depth / 2, front_panel_width / 2, front_panel_height / 2]) {
      rotate([0, -90, 0]) {
        // front panel
        translate([0, 0, body_depth / 2 + 0.25]) {
          hull() {
            translate([0, 0, 0.25]) {
              cube([front_panel_height - 1, front_panel_width - 1, 1], center=true);
            }
            cube([front_panel_height, front_panel_width, 0.5], center=true);
          }
        }

        // main body
        cube([9 + body_offset, 14 + body_offset, body_depth], center=true);

        // pins
        for (i = [-1:1]) {
          translate([0, 5 * i, -5.5]) {
            cube([4, 2, 1], center=true);
            translate([0, 0, -2]) {
              cube([3.7, 0.5, 3], center=true);
            }
          }
        }
      }
    }
  }
}

switch();
