DateTime slotIdTodDateTime(String slot) {
  String y = '';
  for (int j = 0; j < 4; j++) {
    y += slot[4 + j];
  }
  y += slot[2];
  y += slot[3];
  y += slot[0];
  y += slot[1];

  // print(y);
  slot = slot.substring(0, y.length - 2);
  // print(y);

  return DateTime.utc(int.parse(y.substring(0, 4)),
      int.parse(y.substring(4, 6)), int.parse(y.substring(6, 8)));
}
