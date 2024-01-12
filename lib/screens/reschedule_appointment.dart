import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/misc/constants/app_constants.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/providers/slots.dart';
import 'package:runon/widgets/slot_picker.dart';

class RescheduleAppointmentScreen extends StatefulWidget {
  const RescheduleAppointmentScreen(
      {required this.doctorId,
      required this.doctorName,
      required this.doctorImage,
      required this.appointment,
      super.key});
  final String doctorImage;
  final String doctorName;
  final String doctorId;
  final Appointment appointment;

  @override
  State<RescheduleAppointmentScreen> createState() => _RescheduleAppointmentScreenState();
}

class _RescheduleAppointmentScreenState extends State<RescheduleAppointmentScreen> {
  String? chosenSlot;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reschedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: Image.network(widget.doctorImage).image,
              radius: 70,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.doctorName,
                  style: GoogleFonts.raleway(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            FutureBuilder(
              future: _fetchSlots(),
              builder: (context, snapshot) {
                return _content(context);
              },
            ),
            const SizedBox(height: 20),
            const Text('Reschedules are allowed only once.'),
          ],
        ),
      ),
    );
  }

  Future _fetchSlots() async {
    await Provider.of<Slots>(context, listen: false).fetchSlots(widget.doctorId);
  }

  Widget _content(context) {
    return Column(
      children: [
        SlotPicker(
            onUpdate: (newSlot) => setState(() {
                  chosenSlot = newSlot;
                })),
        const SizedBox(height: 40),
        FilledButton(
          onPressed: chosenSlot == null ? null : _updateSlot,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 65,
            padding: const EdgeInsets.all(18.0),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 29,
                    width: 29,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  )
                : Text(
                    'Reschedule',
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
          ),
        ),
      ],
    );
  }

  _updateSlot() async {
    setState(() {
      isLoading = true;
    });

    final String timelineId = widget.appointment.timelines.last.id;

    final ref = FirebaseFirestore.instance
        .collection('appointments/${widget.appointment.appointmentId}/timeline')
        .doc(timelineId);

    final prevSlot = widget.appointment.slotId;

    await ref.update({AppConstants.slotId: chosenSlot, AppConstants.isReschedullable: false});
    await Provider.of<Slots>(context, listen: false).addSlot(
        prevSlot.substring(0, prevSlot.length - 2),
        prevSlot.substring(prevSlot.length - 2, prevSlot.length),
        widget.doctorId);
    await Provider.of<Slots>(context, listen: false).removeSlot(
        chosenSlot!.substring(0, chosenSlot!.length - 2),
        chosenSlot!.substring(chosenSlot!.length - 2, chosenSlot!.length),
        widget.doctorId);

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success')));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
