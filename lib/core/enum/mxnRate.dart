// ignore_for_file: constant_identifier_names

enum MxNRate {
  ONEBYQUARTER("ONEBYONE", 4, 1),
  ONEBYHALF("ONEBYTWO", 4, 2),
  ONEBYONE("ONEBYONE", 4, 4),
  ONEBYTWO("ONEBYTWO", 4, 8),
  TWOBYQUARTER("TWOBYQUARTER", 8, 1),
  TWOBYHALF("TWOBYONE", 8, 2),
  TWOBYONE("TWOBYONE", 8, 4),
  TWOBYTHREEQUARTERS("TWOBYTHREEQUARTERS", 8, 6),
  TWOBYTWO("TWOBYTWO", 8, 8),
  ;

  final String mode;
  final int width;
  final int height;
  const MxNRate(this.mode, this.width, this.height);
}
