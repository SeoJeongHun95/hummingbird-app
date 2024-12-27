// ignore_for_file: constant_identifier_names

enum MxNRate {
  ONEBYONE("ONEBYONE", 1, 1),
  ONEBYTWO("ONEBYTWO", 1, 2),
  TWOBYONE("TWOBYONE", 2, 1),
  TWOBYTWO("TWOBYTWO", 2, 2),
  ;

  final String mode;
  final int width;
  final int height;
  const MxNRate(this.mode, this.width, this.height);
}
