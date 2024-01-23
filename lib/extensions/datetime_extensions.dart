import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get ddMMyyyy {
    return DateFormat('ddMMyyyy').format(this);
  }
}
