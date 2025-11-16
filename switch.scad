// harsh approximation of KCD1-11 switch

// front panel
translate([0, 0, 5]) {
  hull() {
    translate([0, 0, 0.5]) {
      cube([9, 14, 1], center=true);
    }
    cube([10, 15, 0.75], center=true);
  }
}

// main body
cube([9, 14, 10], center=true);

// pins
for (i = [-1:1]) {
  translate([0, 5 * i, -5.5]) {
    cube([4, 2, 1], center=true);
    translate([0, 0, -2]) {
      cube([3.7, 0.5, 3], center=true);
    }
  }
}
