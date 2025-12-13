base_spring_size = [12, 4];

module spring_half() {

  // dont even ask
  line = concat(
    // flat line
    [[3, 2]],
    // wide curve
    [for (i = [1.5:-0.05:-1.5]) [i, sqrt(1 - ( (i - 1.5) / 3) ^ 2) * 2]],
    // semi-circle (half of the horizontal spring)
    [for (i = [-1.5:0.05:0]) [i, -sqrt(1 - ( (i + 0.75) / 0.75) ^ 2) * 0.75]]
  );

  polygon(concat(line, [for (i = [len(line) - 1:-1:0]) line[i] + [0.001, 0.001]]));
}

module spring_one_side() {
  spring_half();
  rotate([0, 0, 180]) spring_half();
}

module spring(dimensions = [10, 3, 10], thickness = 0.5) {
  spring_scale = [
    (dimensions.x - thickness) / (base_spring_size.x),
    (dimensions.y - thickness) / (base_spring_size.y),
  ];
  spring_size = [
    base_spring_size.x * spring_scale.x,
    base_spring_size.y * spring_scale.y,
  ] + [thickness, thickness];

  translate(spring_size / 2) {
    linear_extrude(dimensions.z) {
      offset(r=thickness / 2) {
        scale(spring_scale) {
          translate([-3, 0, 0]) spring_one_side();
          mirror([1, 0, 0])
            translate([-3, 0, 0]) spring_one_side();
        }
      }
    }
  }
}

spring();
