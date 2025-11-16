include <common.scad>

module backpanel() {
  color("#055366ab") {
    linear_extrude(backpanel_thickness) {
      box_surface();
    }
    translate([0, 0, backpanel_thickness]) {

      linear_extrude(backpanel_thickness) {
        difference() {
          lithophane_surface();
          offset(delta=-1) {
            lithophane_surface();
          }
        }
      }
    }
  }
}

backpanel();