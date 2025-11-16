use <frame.scad>
use <backpanel.scad>
include <common.scad>

frame();
translate([0, lithophane_height + wall_thickness * 5, 0]) backpanel();
