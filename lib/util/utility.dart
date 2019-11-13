import 'package:intl/intl.dart';

double getDouble(String input) {
  return double.parse(input);
}

// July 10, 1996
String getDateNow() {
  return DateFormat.yMMMMd("en_US").format(new DateTime.now());
}

// 7/10/1996 5:08 PM
String getDateTimeNow() {
  return DateFormat.yMd().add_jm().format(new DateTime.now());
}

String getIsoDateNow() {
  return DateTime.now().toIso8601String();
}

// July 10, 1996 17:08
String getDateTimeNow2() {
  return DateFormat.yMMMMd("en_US").add_Hms().format(new DateTime.now());
}
