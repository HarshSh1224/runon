import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runon/providers/slot_timings.dart';
import 'package:runon/widgets/method_slotId_to_DateTime.dart';

class Slots with ChangeNotifier {
  // Map < Date, List of available slot indexes >
  Map<String, List<String>> _slots = {};

  Map<String, List<String>> get slots {
    return {..._slots};
  }

  bool isScheduled(String date, String slot) {
    slot = int.parse(slot).toString();
    return _slots.containsKey(date) && _slots[date]!.contains(slot.toString());
  }

  bool get isEmpty {
    return _slots.isEmpty;
  }

  Future<void> fetchSlots(String doctorId) async {
    try {
      final response = await FirebaseFirestore.instance.collection('doctors/$doctorId/slots').get();
      Map<String, List<String>> temp = {};

      for (int i = 0; i < response.docs.length; i++) {
        if (slotIdTodDateTime(offline: false, slotId: response.docs[i].id).isBefore(DateTime.now()
            .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0))) {
          continue;
        }
        temp[response.docs[i].id] = List<String>.from(response.docs[i]['slots']);
      }
      temp.removeWhere((key, value) {
        for (int i = 0; i < value.length; i++) {
          DateTime slot = slotIdTodDateTime(offline: false, slotId: key);
          String time = slotTimings(key: int.parse(value[i]).toString(), offline: false);
          slot = slot.add(Duration(hours: int.parse(time.substring(0, 2))));
          slot = slot.add(Duration(minutes: int.parse(time.substring(3, 5))));
          if (time[6] == 'P' && time.substring(0, 2) != '12') {
            slot = slot.add(const Duration(hours: 12));
          }

          DateTime nowTime = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
          if (nowTime.isAfter(slot)) {
            return true;
          }
        }
        return false;
      });
      _slots = temp;
    } catch (error) {
      print(error.toString());
    }
    notifyListeners();
  }

  List<String> get onlyDates {
    return [..._slots.keys];
  }

  DateTime? get firstAvailableDate {
    final temp = [..._slots.keys];
    List<String> temp2 = [];
    for (int i = 0; i < temp.length; i++) {
      String x = temp[i];
      String y = '';
      for (int j = 0; j < 4; j++) {
        y += x[4 + j];
      }
      y += x[2];
      y += x[3];
      y += x[0];
      y += x[1];
      temp2.add(y);
    }
    temp2.sort();
    // print(int.parse(temp2[0].substring(6, 8)));
    final date = DateTime(int.parse(temp2[0].substring(0, 4)), int.parse(temp2[0].substring(4, 6)),
        int.parse(temp2[0].substring(6, 8)));
    return date;
  }

  List<String> slotTimes(String date) {
    return [..._slots[date]!];
  }

  Future<void> addSlot(String date, String slot, String doctorId) async {
    // await fetchSlots(doctorId);
    List<String> slotsList = _slots[date] == null ? [] : [..._slots[date]!];

    if (slotsList.indexWhere((element) => element == slot) != -1) {
      return;
    } else {
      slotsList.add(slot);
    }

    try {
      await FirebaseFirestore.instance
          .collection('doctors/$doctorId/slots')
          .doc(date)
          .set({'slots': slotsList});
      _slots[date] = slotsList;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  removeSlot(String date, String slot, String doctorId) async {
    slot = int.parse(slot).toString();
    List<String> slotsList = _slots[date] == null ? [] : [..._slots[date]!];
    slotsList.removeWhere((element) => element == slot);

    try {
      if (slotsList.isEmpty) {
        await FirebaseFirestore.instance.collection('doctors/$doctorId/slots').doc(date).delete();
        _slots[date] = [];
      } else {
        await FirebaseFirestore.instance
            .collection('doctors/$doctorId/slots')
            .doc(date)
            .set({'slots': slotsList});
        _slots[date] = slotsList;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
