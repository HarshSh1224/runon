import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({required this.countTo, super.key});
  final DateTime countTo;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;

  late int _start;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    _start = widget.countTo
        .difference(DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)))
        .inSeconds;
    // print(widget.countTo);
    if (_start >= 0) startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time Remaining: $_timerString',
      style: GoogleFonts.roboto(
          color: Theme.of(context).colorScheme.outline, fontStyle: FontStyle.italic, fontSize: 18),
    );
  }

  String get _timerString {
    String minutes = (_start ~/ 60).toString();
    String hours = (int.parse(minutes) ~/ 60).toString();
    String days = (int.parse(hours) ~/ 24).toString();

    if (int.parse(days) != 0) return '$days day(s)';

    minutes = (int.parse(minutes) % 60).toString();
    String seconds = (_start % 60).toString();

    if (seconds.length == 1) seconds = '0$seconds';
    if (minutes.length == 1) minutes = '0$minutes';
    if (hours.length == 1) hours = '0$hours';

    String ans = '';

    if (int.parse(hours) != 0) ans += '$hours : ';

    ans += '$minutes : $seconds';
    return ans;
  }
}
