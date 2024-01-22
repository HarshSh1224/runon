// Formats compact slot Id to detailed slot string

import 'package:intl/intl.dart';
import 'package:runon/providers/slot_timings.dart';

String expandSlot(String slot, bool isOffline) {
  final date = DateTime(int.parse(slot.substring(4, 8)), int.parse(slot.substring(2, 4)),
      int.parse(slot.substring(0, 2)));
  return '${DateFormat('dd MMM').format(date)} ${slotTimings(key: int.parse(slot.substring(8, 10)).toString(), offline: isOffline)}';
}
