import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runon/controllers/database.dart';
import 'package:runon/models/flat_feet_options.dart';
import 'package:runon/providers/appointments.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/slots.dart';
import 'package:runon/screens/cancel_appointment_screen.dart';
import 'package:runon/screens/messages_screen.dart';
import 'package:runon/screens/patient/new_appointment.dart';
import 'package:runon/screens/reschedule_appointment.dart';
import 'package:runon/utils/app_methods.dart';
import 'package:runon/video_call/call_methods.dart';
import 'package:runon/video_call/call_model.dart';
import 'package:runon/video_call/call_utils.dart';
import 'package:runon/video_call/video_call_screen.dart';
import 'package:runon/widgets/method_slotId_to_DateTime.dart';
import 'package:runon/widgets/method_slot_formatter.dart';
import 'package:runon/widgets/attachment_card.dart';
import 'package:runon/widgets/countdown_timer.dart';

enum Option { cancel, reschedule }

class AppointmentDetailScreen extends StatefulWidget {
  static const routeName = '/appointment-detail-screen';
  AppointmentDetailScreen({this.isDoctor = false, super.key});

  bool isDoctor;

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  bool isAdmin = false;

  late StreamSubscription callStreamSubscription;
  late Call call;
  bool incomingCall = false;
  final callMethods = CallMethods();

  late Appointment appointment;

  final Map<dynamic, String> _appointmentData = {
    'patient': 'Loading...',
    'patientImage': '',
    'patient_age': 'Loading...',
    'doctor': 'Loading...',
    'doctorImage':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6ILFjfb_VfmQr0Zd1ozwtBh_myghTAdRH2g&usqp=CAU',
    'issue': 'Loading...',
  };

  List<Timeline> _timeLine = [];
  bool isCheckingDoctorAvailability = false;

  Future<void> _fetchAndSetData(Appointment appointment) async {
    final patient =
        await FirebaseFirestore.instance.collection('users').doc(appointment.patientId).get();

    _appointmentData['patient'] = patient.data()!['fName'] + ' ' + patient.data()!['lName'];

    _appointmentData['patient_age'] =
        '${DateTime.now().year - (DateTime.parse(patient.data()!['dateOfBirth']).year)}y';

    _appointmentData['patientImage'] = patient.data()!['imageUrl'];

    final doctor =
        await FirebaseFirestore.instance.collection('doctors').doc(appointment.doctorId).get();

    _appointmentData['doctor'] = doctor.data()!['name'];

    final issue =
        await FirebaseFirestore.instance.collection('issues').doc(appointment.issueId).get();

    _appointmentData['issue'] = issue.data()!['title'];

    _timeLine = appointment.timelines;

    // debugPrint('HELLLLLLLL${timelineFetch.docs[0]['paymentId']}');
  }

  Widget _customWidgetBuilder(String type, String name, String imageUrl, {Widget? trailing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 18.0,
          ),
          child: Text(
            type,
            style: GoogleFonts.raleway(),
          ),
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundImage: Image.network(imageUrl).image,
            ),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.raleway(fontWeight: FontWeight.w600, fontSize: 18)),
            ),
            if (trailing != null) ...[const SizedBox(width: 7), trailing]
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
  }

  addPostFrameCallback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appointment = ModalRoute.of(context)!.settings.arguments as Appointment;
      widget.isDoctor = appointment.doctorId == FirebaseAuth.instance.currentUser!.uid;
      isAdmin = Provider.of<Auth>(context, listen: false).type == 2;

      if (!widget.isDoctor && !isAdmin) {
        callStreamSubscription = callMethods
            .callStream(uid: appointment.appointmentId)
            .listen((DocumentSnapshot snapshot) {
          if (snapshot.data() != null) {
            call = Call.fromMap(snapshot.data() as Map<String, dynamic>);
            setState(() {
              incomingCall = true;
            });
          } else {
            setState(() {
              incomingCall = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appointment = ModalRoute.of(context)!.settings.arguments as Appointment;
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Details'), actions: [
        PopupMenuButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: ((value) {
              if (value == Option.cancel) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CancelAppointmentScreen(
                    appointment: appointment,
                    paymentId: appointment.mostRecentPaymentId ?? '',
                    auth: Provider.of<Auth>(context, listen: false),
                  );
                }));
              } else {
                if (!appointment.before48Hours) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Cannot reschedule'),
                  ));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return RescheduleAppointmentScreen(
                      doctorId: appointment.doctorId,
                      doctorImage: _appointmentData['doctorImage']!,
                      doctorName: _appointmentData['doctor']!,
                      appointment: appointment,
                    );
                  }));
                }
              }
            }),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  value: Option.cancel,
                  child: Text(
                    'Cancel Appointment',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
                PopupMenuItem(
                  value: Option.reschedule,
                  child: Text(
                    'Reschedule Appointment',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
                // PopupMenuItem(
                //   child: PopupMenuButton(
                //     child: Padding(
                //         padding: EdgeInsets.all(20), child: Text("Nested Items")),
                //     itemBuilder: (_) {
                //       return [
                //         PopupMenuItem(child: Text("Item2")),
                //         PopupMenuItem(child: Text("Item3"))
                //       ];
                //     },
                //   ),
                //   value: Option.all,
                // ),
              ];
            })
      ]),
      body: FutureBuilder(
        future: _fetchAndSetData(appointment),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _customWidgetBuilder('PATIENT', _appointmentData['patient']!,
                            _appointmentData['patientImage']!,
                            trailing: Text(
                              _appointmentData['patient_age']!,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.outline),
                            )),
                        _customWidgetBuilder('DOCTOR', _appointmentData['doctor']!,
                            _appointmentData['doctorImage']!),
                        SizedBox(
                          width: double.infinity,
                          child: _customWidgetBuilder('ISSUE', _appointmentData['issue']!,
                              'https://static.vecteezy.com/system/resources/previews/000/553/397/original/foot-cartoon-vector-icon.jpg'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'TIMELINE',
                          style: GoogleFonts.raleway(),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ..._timeLine.map((e) {
                          // e['createdOn'];
                          return Transform.translate(
                            offset: const Offset(10, 0),
                            child: e.type == TimelineType.cancelled
                                ? _cancelledTimeline(context, e)
                                : _normalTimeline(context, e),
                          );
                        }).toList(),
                        const SizedBox(
                          height: 20,
                        ),
                        if (!appointment.hasPassed && !appointment.isCancelled)
                          _upcomingAppointment(appointment, context),
                        if ((appointment.hasPassed && !widget.isDoctor) || appointment.isCancelled)
                          FollowUpButton(
                            appointment: appointment,
                            doctorName: _appointmentData['doctor']!,
                            isAdmin: isAdmin,
                          ),
                        if (appointment.isCancelled && isAdmin)
                          _deleteAppointmentButton(appointment),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _normalTimeline(BuildContext context, Timeline e) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(0, 8),
          child: Column(
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              Container(
                height: 175,
                width: 3,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(e.createdOn),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                e.byDoctor ? 'Successfully Consulted' : 'Payment Scuccessful Rs ${e.paymentAmount}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 10,
              ),
              AttachmentCard(
                docsUrl: e.prescriptionList,
                title: 'View Attachments',
                color: Theme.of(context).colorScheme.secondaryContainer,
                height: 70,
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cancelledTimeline(BuildContext context, Timeline e) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(0, 8),
          child: Column(
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              Container(
                height: 60,
                width: 3,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(e.createdOn),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                'Appointment Cancelled.${e.refundId != null ? ' Fee Refunded.' : ''}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _upcomingAppointment(Appointment appointment, BuildContext context) {
    return Column(
      children: [
        Text(
          'Upcoming Appointment on: ${expandSlot(appointment.slotId)}',
          style: GoogleFonts.roboto(
              color: Theme.of(context).colorScheme.outline,
              fontStyle: FontStyle.italic,
              fontSize: 18),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: !canStartAppointment(appointment)
                    ? null
                    : (!widget.isDoctor && !incomingCall)
                        ? null
                        : (widget.isDoctor
                            ? () async {
                                await _generateTimeline(
                                    appointment.appointmentId, appointment.slotId);
                                CallUtilities.dial(
                                  context: context,
                                  appointment: appointment,
                                  patientName: _appointmentData['patient']!,
                                  doctorName: _appointmentData['doctor']!,
                                  patientProfilePic: _appointmentData['patientImage']!,
                                  doctorProfilePic: _appointmentData['doctorImage']!,
                                );
                              }
                            : (incomingCall
                                ? () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => VideoCallScreen(
                                          call: call,
                                          isDoctor: false,
                                        ),
                                      ),
                                    )
                                : null)),
                child: FittedBox(child: _buttonContent()),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                flex: 1,
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(MessagesScreen.routeName, arguments: appointment);
                    },
                    child: const Text(
                      'Chat',
                    )))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        if (!canStartAppointment(appointment))
          CountdownTimer(
            countTo: slotIdTodDateTime(appointment.slotId, withTime: true),
            onComplete: () => setState(() {}),
          ),
        // if (!appointment.hasPassed)
        // TextButton(
        //     onPressed: () {

        //     },
        //     child: const Text('Cancel Appointment')),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Padding _buttonContent() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isDoctor)
            const Text(
              'Start Video Call',
              style: TextStyle(fontSize: 18),
            ),
          if (!widget.isDoctor)
            Text(
              canStartAppointment(appointment) && !incomingCall
                  ? 'Waiting for Doctor '
                  : 'Join Video Call',
              style: const TextStyle(fontSize: 18),
            ),
          const SizedBox(width: 5),
          !widget.isDoctor && !incomingCall && canStartAppointment(appointment)
              ? const SizedBox(
                  height: 17, width: 17, child: FittedBox(child: CircularProgressIndicator()))
              : const Icon(Icons.play_circle_sharp, size: 30)
        ],
      ),
    );
  }

  Widget _deleteAppointmentButton(Appointment appointment) {
    return OutlinedButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Delete Appointment'),
                  content: const Text('Are you sure you want to delete this appointment?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No')),
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await appointment.delete();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes')),
                  ],
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.delete),
            Text('Delete Appointment'),
          ],
        ));
  }

  bool canStartAppointment(Appointment appointment) {
    if (incomingCall) return true;
    DateTime slot = slotIdTodDateTime(appointment.slotId, withTime: true);

    DateTime nowTime = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    if (nowTime.isAfter(slot.subtract(const Duration(minutes: 10))) &&
        nowTime.isBefore(slot.add(const Duration(minutes: 30)))) {
      return true;
    }
    return false;
  }

  Future<void> _uploadPrescription(
      String text, Appointment appointment, FeetObservations? feetObservations) async {
    if (text.isEmpty && feetObservations == null) return;
    print('Creating Prescription');
    final prescription = await AppMethods.gneratePrescriptionPdf(
        appointmentId: appointment.appointmentId,
        patientName: _appointmentData['patient']!,
        patientId: appointment.patientId,
        doctorName: _appointmentData['doctor']!,
        doctorId: appointment.doctorId,
        issue: _appointmentData['issue']!,
        date: expandSlot(appointment.slotId),
        prescription: text,
        feetObservations: feetObservations);

    final ref = FirebaseStorage.instance
        .ref()
        .child('prescriptions')
        .child(appointment.appointmentId + appointment.slotId);
    await ref.putFile(prescription);
    final url = await ref.getDownloadURL();
    await _generateTimeline(appointment.appointmentId, appointment.slotId, url);
  }

  Future<void> _generateTimeline(String appointmentId, String slotId,
      [String? prescriptionUrl]) async {
    final ref = FirebaseFirestore.instance
        .collection('appointments/$appointmentId/timeline')
        .doc(appointmentId + slotId);

    try {
      final data = {
        'createdOn': DateTime.now().toIso8601String(),
        'byDoctor': true,
        'slotId': slotId,
      };
      if (prescriptionUrl != null) data['prescriptionList'] = [prescriptionUrl];
      await ref.set(data);
    } catch (error) {
      print(error);
    }
  }
}

class FollowUpButton extends StatefulWidget {
  const FollowUpButton({
    required this.appointment,
    required this.doctorName,
    required this.isAdmin,
    super.key,
  });
  final Appointment appointment;
  final String doctorName;
  final isAdmin;

  @override
  State<FollowUpButton> createState() => _FollowUpButtonState();
}

class _FollowUpButtonState extends State<FollowUpButton> {
  bool isCheckingDoctorAvailability = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: isCheckingDoctorAvailability
                      ? null
                      : () {
                          _onTapBookFollowUp(widget.appointment);
                        },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Book Follow Up',
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: isCheckingDoctorAvailability
                    ? const CircularProgressIndicator(strokeWidth: 3)
                    : null,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _onTapBookFollowUp(Appointment appointment) async {
    final slotsProvider = Provider.of<Slots>(context, listen: false);
    setState(() {
      isCheckingDoctorAvailability = true;
    });
    await slotsProvider.fetchSlots(appointment.doctorId);

    setState(() {
      isCheckingDoctorAvailability = false;
    });

    if (!slotsProvider.isEmpty) {
      Auth? patient;
      if (widget.isAdmin) {
        final user = await Database.downloadDoc(collection: 'users', docId: appointment.patientId);
        patient = Auth.fromMap(user, appointment.patientId);
      }
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewAppointment(
          patient: patient,
          isFollowUp: true,
          appointment: appointment,
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text('No slots are available for Dr. ${widget.doctorName}'),
      )));
    }
  }
}
