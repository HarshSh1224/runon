String dateTimeToSlotId(DateTime date) {
  String ans = '';
  if (date.day.toString().length == 1) ans += '0';
  ans += date.day.toString();
  if (date.month.toString().length == 1) ans += '0';
  ans += date.month.toString();
  ans += date.year.toString();
  print(ans);
  return ans;
}
