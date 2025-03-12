Future<void> delay(
  void Function() callback, {
  int? seconds,
}) {
  return Future.delayed(Duration(seconds: seconds ?? 0), () => callback());
}
