import 'package:runon/providers/slot_timings.dart';

DateTime slotIdTodDateTime(String slotId, {bool withTime = false}) {
  String y = '';
  for (int j = 0; j < 4; j++) {
    y += slotId[4 + j];
  }
  y += slotId[2];
  y += slotId[3];
  y += slotId[0];
  y += slotId[1];

  // print(y);
  // slotId = slotId.substring(0, y.length - 2);
  // print(y);
  DateTime slot = DateTime.utc(
      int.parse(y.substring(0, 4)), int.parse(y.substring(4, 6)), int.parse(y.substring(6, 8)));

  print(slotId);

  if (withTime) {
    String time = slotTimings[int.parse(slotId.substring(8, 10)).toString()]!;
    slot = slot.add(Duration(hours: int.parse(time.substring(0, 2))));
    slot = slot.add(Duration(minutes: int.parse(time.substring(3, 5))));
    if (time[6] == 'P') slot = slot.add(const Duration(hours: 12));
  }

  return slot;
}
