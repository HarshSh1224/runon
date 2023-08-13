import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/doctors.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/providers/slots.dart';
import 'package:runon/providers/temp_provider.dart';
import 'package:runon/widgets/clip_paths.dart';
import 'package:runon/widgets/confirm_appointment_dialog.dart';
import 'package:runon/widgets/slot_picker.dart';
import 'package:runon/widgets/issue_dropdown.dart';
import 'package:runon/widgets/doctors_dropdown.dart';
import 'package:runon/widgets/flat_feet_image_upload.dart';
import 'package:runon/widgets/add_reports_box.dart';
import 'package:file_picker/file_picker.dart';

class NewAppointment extends StatelessWidget {
  static const routeName = '/new-appointment';
  NewAppointment({this.isFollowUp = false, this.appointment, super.key});

  final Appointment? appointment;
  final bool isFollowUp;
  List<PlatformFile> _filesList = [];
  PlatformFile? _flatFeetImage1;
  PlatformFile? _flatFeetImage2;

  final _formData = {
    'patientId': '',
    'doctorId': '',
    'issueId': '',
    'slotId': '',
    'height': '',
    'weight': '',
    'bookedOn': DateTime.now().toIso8601String()
  };

  void updateDoctorId(doctorId) => _formData['doctorId'] = doctorId;
  void updateIssueId(issueId) => _formData['issueId'] = issueId;
  void updateSlotId(slotId) => _formData['slotId'] = slotId;
  void updateReportList(List<PlatformFile> file) => _filesList = file;
  void updateFlatFeetImage1(PlatformFile file) => _flatFeetImage1 = file;
  void updateFlatFeetImage2(PlatformFile file) => _flatFeetImage2 = file;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _fetchSlots(Slots slotsProvider, String doctorId) async {
    await slotsProvider.fetchSlots(doctorId);
  }

  Future<void> _fetchIssueData({
    required IssueData issueProvider,
    required Doctors doctorsProvider,
    Slots? slotsProvider,
    String? doctorId,
  }) async {
    await issueProvider.fetchAndSetIssues();
    await doctorsProvider.fetchAndSetDoctors();
    if (doctorId != null) {
      await _fetchSlots(slotsProvider!, doctorId);
    }
  }

  void _submit(BuildContext context, Slots slotsProvider) async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (slotsProvider.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('No slots are available for the selected doctor'),
      )));
      return;
    }

    _formData['patientId'] = Provider.of<Auth>(context, listen: false).userId!;
    _formKey.currentState!.save();

    if (_formData['issueId'] == 'I8' && (_flatFeetImage1 == null || _flatFeetImage2 == null)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('Two images for flat feet are required'),
      )));
      return;
    }

    if (_flatFeetImage1 != null) _filesList.add(_flatFeetImage1!);
    if (_flatFeetImage2 != null) _filesList.add(_flatFeetImage2!);

    await showDialog(
        context: context,
        builder: (context) {
          return !isFollowUp
              ? ConfirmAppointmentDialog(
                  _formData['doctorId'] as String,
                  _formData['slotId'] as String,
                  Provider.of<IssueData>(context, listen: false).issueFromId(_formData['issueId']!),
                  _formData,
                  _filesList,
                )
              : ConfirmAppointmentDialog(
                  _formData['doctorId'] as String,
                  _formData['slotId'] as String,
                  Provider.of<IssueData>(context, listen: false).issueFromId(_formData['issueId']!),
                  _formData,
                  _filesList,
                  isFollowUp: true,
                  appointmentId: appointment!.appointmentId,
                );
        });
  }

  @override
  Widget build(BuildContext contextt) {
    final issueProvider = Provider.of<IssueData>(contextt, listen: false);
    final doctorsProvider = Provider.of<Doctors>(contextt, listen: false);
    final slotsProvider = Provider.of<Slots>(contextt, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Appointment'),
      ),
      body: FutureBuilder(
        future: _fetchIssueData(
          issueProvider: issueProvider,
          doctorsProvider: doctorsProvider,
          slotsProvider: isFollowUp ? slotsProvider : null,
          doctorId: isFollowUp ? appointment!.doctorId : null,
        ),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/newApntmnt.jpg',
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          Positioned.fill(
                            child: ClipPath(
                              clipper: OnlyBottomEllipse(0.87),
                              child: Container(
                                color: Theme.of(context).colorScheme.background,
                                // child: Expanded(child: Text('Hello World')),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              IgnorePointer(
                                  ignoring: isFollowUp,
                                  child: IssueDropdown(
                                    issueProvider,
                                    updateIssueId,
                                    initIssueId: isFollowUp ? appointment!.issueId : null,
                                  )),
                              const SizedBox(
                                height: 30,
                              ),
                              if (isFollowUp)
                                IgnorePointer(
                                  child: DoctorsDropdown(
                                    doctors: doctorsProvider,
                                    update: updateDoctorId,
                                    followUpDoctorId: appointment!.doctorId,
                                  ),
                                ),
                              if (!isFollowUp)
                                DoctorsDropdown(
                                  doctors: doctorsProvider,
                                  update: updateDoctorId,
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                              SlotPicker(
                                  onUpdate: updateSlotId,
                                  slotsReceived: isFollowUp ? slotsProvider : null),
                              const SizedBox(
                                height: 20,
                              ),
                              Consumer<TempProvider>(builder: (context, temp, ch) {
                                return _formData['issueId'] != 'I8'
                                    ? Container()
                                    : _extraFieldsForFlatFeet(context);
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              AddReportsBox(updateReportList),
                              const SizedBox(
                                height: 40,
                              ),
                              FilledButton(
                                onPressed: () {
                                  _submit(contextt, slotsProvider);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 80,
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Column _extraFieldsForFlatFeet(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _formData['height'] = value!;
                },
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Invalid Value';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    // icon: Icon(Icons.attribution_sharp),
                    label: Text('Height (cm)*'),
                    border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 1,
              child: TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _formData['weight'] = value!;
                },
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Invalid Value';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    label: Text('Weight (kg)*'), border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            FlatFeetImageUploadBox(updateFlatFeetImage1),
            const SizedBox(
              width: 15,
            ),
            FlatFeetImageUploadBox(updateFlatFeetImage2),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Text(
              'Upload 2 Images for flat feet',
            ),
            const SizedBox(
              width: 5,
            ),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('Sample Images'),
                          actions: [
                            TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text('Close'),
                            )
                          ],
                          content: Column(mainAxisSize: MainAxisSize.min, children: [
                            Image.asset(
                              'assets/images/sample1.jpg',
                            ),
                            const SizedBox(height: 10),
                            Image.asset(
                              'assets/images/sample2.jpg',
                            ),
                          ]),
                        );
                      });
                },
                child: const Icon(Icons.info_outline))
          ],
        ),
      ],
    );
  }
}
