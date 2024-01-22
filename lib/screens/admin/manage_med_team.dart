import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/doctors.dart';
import 'package:runon/screens/doctor/manage_slots.dart';

class ManageMedicalTeam extends StatefulWidget {
  static const routeName = '/manageMedicalTeam';
  const ManageMedicalTeam({super.key});

  @override
  State<ManageMedicalTeam> createState() => _ManageMedicalTeamState();
}

class _ManageMedicalTeamState extends State<ManageMedicalTeam> {
  bool _isUpdating = false;

  TextEditingController nameController = TextEditingController();

  TextEditingController qualificationsController = TextEditingController();

  TextEditingController feesController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    nameController.dispose();
    qualificationsController.dispose();
    feesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String doctorId = ModalRoute.of(context)!.settings.arguments as String;
    final auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Team'),
        actions: const [],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('doctors').doc(doctorId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final doctor = Doctor.fromMap(snapshot.data!.data()!, snapshot.data!.id);

            nameController.text = doctor.name;
            qualificationsController.text = doctor.qualifications;
            feesController.text = doctor.fees.toString();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                      backgroundImage: Image.network(
                        'https://i2-prod.mirror.co.uk/interactives/article12645227.ece/ALTERNATES/s1200c/doctor.jpg',
                      ).image,
                      radius: 60,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    _formRowBuilder('Name :', nameController, (value) {
                      if (value!.length < 3) return "Please enter a valid name";
                      return null;
                    }, doctor),
                    const SizedBox(
                      height: 10,
                    ),
                    _formRowBuilder('Qualifications : ', qualificationsController, (value) {
                      if (value!.isEmpty) return "Please enter a valid Qualification";
                      return null;
                    }, doctor),
                    const SizedBox(
                      height: 10,
                    ),
                    _formRowBuilder('Fees :', feesController, (value) {
                      if (double.tryParse(value!) == null || double.parse(value) <= 0) {
                        return "Please enter a valid number";
                      }
                      return null;
                    }, doctor),
                    const SizedBox(
                      height: 10,
                    ),
                    _formRowBuilder('Email id :', feesController, (value) => null, doctor,
                        disabledText: (doctor.email ?? 'Not available')),
                    const SizedBox(
                      height: 45,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonal(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ManageSlotsScreen.routeName, arguments: doctor.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Manage Slots  ',
                                style: TextStyle(fontSize: 15),
                              ),
                              Icon(Icons.arrow_forward)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                            onPressed: Navigator.of(context).pop,
                            child: Container(
                              height: 50,
                              width: 130,
                              padding: const EdgeInsets.all(15.0),
                              child: const Text(
                                '    Cancel    ',
                                style: TextStyle(fontSize: 17),
                              ),
                            )),
                        FilledButton(
                          onPressed: () {
                            _submit(context, doctor, setState);
                          },
                          child: Container(
                            height: 50,
                            width: 130,
                            padding: const EdgeInsets.all(15.0),
                            child: _isUpdating
                                ? Center(
                                    child: FittedBox(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    '    Update    ',
                                    style: TextStyle(fontSize: 17),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (auth.isAdmin) _deleteTeamButton(context, doctor),
                    const SizedBox(
                      height: 30,
                    ),
                  ]),
                ),
              ),
            );
          }),
    );
  }

  Row _deleteTeamButton(BuildContext context, Doctor doctor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onError,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              final deleteable = await doctor.isFree();
              showDialog(
                  context: context,
                  builder: (_) {
                    return deleteable
                        ? _confirmDelete(context, doctor)
                        : AlertDialog(
                            title: const Text('Delete Team'),
                            content: const Text(
                                'This team cannot be deleted as it has active appointments. Please delete all of their appointments to proceed'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Ok'),
                              ),
                            ],
                          );
                  });
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Text(
                'Delete Team',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AlertDialog _confirmDelete(BuildContext context, Doctor doctor) {
    return AlertDialog(
      title: const Text('Delete Team'),
      content: const Text('Are you sure you want to delete this team?'),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            try {
              await FirebaseFirestore.instance
                  .collection('doctors')
                  .doc(doctor.id)
                  .update({'archived': true});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Success',
                    ),
                  ),
                ),
              );
              Navigator.of(context).pop();
            } catch (error) {
              debugPrint(error.toString());
            }
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
      ],
    );
  }

  void _submit(context, Doctor doctor, setState) async {
    // FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final formData = {
      'fees': double.parse(feesController.text),
      'name': nameController.text,
      'qualification': qualificationsController.text,
    };

    setState(() {
      _isUpdating = true;
    });

    try {
      await FirebaseFirestore.instance.collection('doctors').doc(doctor.id).set(formData);
      doctor.name = nameController.text;
      doctor.qualifications = qualificationsController.text;
      doctor.fees = double.parse(feesController.text);

      Provider.of<Doctors>(context, listen: false).updateDoctor(doctor);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Success',
            ),
          ),
        ),
      );
    } catch (error) {
      debugPrint(error.toString());
    }

    setState(() {
      _isUpdating = false;
    });
  }

  Widget _formRowBuilder(String title, TextEditingController controller,
      String? Function(String?)? validator, Doctor doctor,
      {String? disabledText}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: GoogleFonts.roboto(fontSize: 15),
          ),
        ),
        Expanded(
          flex: 10,
          child: disabledText != null
              ? _disabledTextField(disabledText)
              : TextFormField(
                  onEditingComplete: () {
                    _submit(context, doctor, setState);
                  },
                  validator: validator,
                  controller: controller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _disabledTextField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
      child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.outline)),
    );
  }
}
