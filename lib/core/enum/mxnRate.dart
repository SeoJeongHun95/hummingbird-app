// ignore_for_file: constant_identifier_names

enum MxNRate {
  ONEBYONE("ONEBYONE", 2, 2),
  ONEBYTWO("ONEBYTWO", 2, 4),
  TWOBYONE("TWOBYONE", 4, 2),
  TWOBYTWO("TWOBYTWO", 4, 4),
  FOURBYTHREE("FOURBYTHREE", 4, 3),
  ;

  final String mode;
  final int width;
  final int height;
  const MxNRate(this.mode, this.width, this.height);
}
