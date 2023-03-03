// Formats compact slot Id to detailed slot string
import 'package:intl/intl.dart';
import '../providers/slot_timings.dart';

String expandSlot(String slot) {
  final date = DateTime(int.parse(slot.substring(4, 8)),
      int.parse(slot.substring(2, 4)), int.parse(slot.substring(0, 2)));
  return DateFormat('dd MMM').format(date) +
      ' ' +
      slotTimings[int.parse(slot.substring(8, 10)).toString()]!;
}
