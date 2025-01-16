import 'package:intl/intl.dart';

String get formattedToday {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}
