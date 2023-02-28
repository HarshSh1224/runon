import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runon/providers/slot_timings.dart';

class Slots with ChangeNotifier {
  // Map < Date, List of available slot indexes >
  Map<String, List<String>> _slots = {};

  bool get isEmpty {
    return _slots.isEmpty;
  }

  Future<void> fetchSlots(String doctorId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('doctors/$doctorId/slots')
          .get();
      Map<String, List<String>> temp = {};

      for (int i = 0; i < response.docs.length; i++) {
        temp[response.docs[i].id] =
            List<String>.from(response.docs[i]['slots']);
      }
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
    final date = DateTime(
        int.parse(temp2[0].substring(0, 4)),
        int.parse(temp2[0].substring(4, 6)),
        int.parse(temp2[0].substring(6, 8)));
    return date;
  }

  List<String> slotTimes(String date) {
    return _slots[date]!.map((element) {
      return slotTimings[element] ?? 'error';
    }).toList();
  }
}
