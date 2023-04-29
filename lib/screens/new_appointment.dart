import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/doctors.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/providers/slots.dart';
import 'package:runon/providers/temp_provider.dart';
import 'package:runon/widgets/clip_paths.dart';
import '../widgets/slot_picker.dart';
import 'package:runon/widgets/issue_dropdown.dart';
import 'package:runon/widgets/doctors_dropdown.dart';
import 'package:runon/widgets/flat_feet_image_upload.dart';
import '../widgets/add_reports_box.dart';
import '../widgets/confirm_appointment_dialog.dart';
import 'package:file_picker/file_picker.dart';

class NewAppointment extends StatelessWidget {
  static const routeName = '/new-appointment';
  NewAppointment({super.key});
  List<PlatformFile> _filesList = [];

  final _formData = {
    'patientId': '',
    'doctorId': '',
    'issueId': '',
    'slotId': '',
    'reportUrl': [],
    'height': '',
    'weight': '',
    'bookedOn': ''
  };

  void updateDoctorId(doctorId) => _formData['doctorId'] = doctorId;
  void updateIssueId(issueId) => _formData['issueId'] = issueId;
  void updateSlotId(slotId) => _formData['slotId'] = slotId;
  void updateReportList(List<PlatformFile> file) => _filesList = file;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _fetchIssueData(
      IssueData issueProvider, Doctors doctorsProvider) async {
    await issueProvider.fetchAndSetIssues();
    await doctorsProvider.fetchAndSetDoctors();
  }

  void _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (Provider.of<Slots>(context, listen: false).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('No slots are available for the selected doctor'),
      )));
      return;
    }

    _formData['patientId'] = Provider.of<Auth>(context, listen: false).userId!;
    _formKey.currentState!.save();

    await showDialog(
        context: context,
        builder: (context) {
          return ConfirmAppointmentDialog(
              _formData['doctorId'] as String,
              _formData['slotId'] as String,
              Provider.of<IssueData>(context, listen: false)
                  .issueFromId(_formData['issueId']! as String),
              _formData,
              _filesList);
        });
  }

  @override
  Widget build(BuildContext context) {
    final issueProvider = Provider.of<IssueData>(context, listen: false);
    final doctorsProvider = Provider.of<Doctors>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Slots(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Appointment'),
        ),
        body: FutureBuilder(
          future: _fetchIssueData(issueProvider, doctorsProvider),
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
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  // child: Expanded(child: Text('Hello World')),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                IssueDropdown(issueProvider, updateIssueId),
                                const SizedBox(
                                  height: 30,
                                ),
                                DoctorsDropdown(
                                    doctorsProvider, updateDoctorId),
                                const SizedBox(
                                  height: 20,
                                ),
                                SlotPicker(updateSlotId),
                                const SizedBox(
                                  height: 20,
                                ),

                                Consumer<TempProvider>(
                                    builder: (context, temp, ch) {
                                  return _formData['issueId'] != 'I8'
                                      ? Container()
                                      : Column(
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onSaved: (value) {
                                                      _formData['height'] =
                                                          value!;
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty ||
                                                          double.tryParse(
                                                                  value) ==
                                                              null ||
                                                          double.parse(value) <
                                                              0) {
                                                        return 'Invalid Value';
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            // icon: Icon(Icons.attribution_sharp),
                                                            label: Text(
                                                                'Height (cm)*'),
                                                            border:
                                                                OutlineInputBorder()),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onSaved: (value) {
                                                      _formData['weight'] =
                                                          value!;
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty ||
                                                          double.tryParse(
                                                                  value) ==
                                                              null ||
                                                          double.parse(value) <
                                                              0) {
                                                        return 'Invalid Value';
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            label: Text(
                                                                'Weight (kg)*'),
                                                            border:
                                                                OutlineInputBorder()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                FlatFeetImageUploadBox(
                                                    updateReportList),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                FlatFeetImageUploadBox(
                                                    updateReportList),
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
                                                              title: const Text(
                                                                  'Sample Images'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop,
                                                                  child: const Text(
                                                                      'Close'),
                                                                )
                                                              ],
                                                              content: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Image.asset(
                                                                      'assets/images/sample1.jpg',
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    Image.asset(
                                                                      'assets/images/sample2.jpg',
                                                                    ),
                                                                  ]),
                                                            );
                                                          });
                                                    },
                                                    child: const Icon(
                                                        Icons.info_outline))
                                              ],
                                            ),
                                          ],
                                        );
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
                                    _submit(context);
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
                                // Container(
                                //   height: 160,
                                //   width: double.infinity,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(30),
                                //       border: Border.all(
                                //           color:
                                //               Theme.of(context).colorScheme.onBackground)),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
