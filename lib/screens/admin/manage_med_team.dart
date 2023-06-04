import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:runon/providers/doctors.dart';

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
  Widget build(BuildContext context) {
    Doctor doctor = ModalRoute.of(context)!.settings.arguments as Doctor;

    nameController.text = doctor.name;
    qualificationsController.text = doctor.qualifications;
    feesController.text = doctor.fees.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Team'),
      ),
      body: Padding(
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
              }),
              const SizedBox(
                height: 10,
              ),
              _formRowBuilder('Qualifications : ', qualificationsController, (value) {
                if (value!.isEmpty) return "Please enter a valid Qualification";
                return null;
              }),
              const SizedBox(
                height: 10,
              ),
              _formRowBuilder('Fees :', feesController, (value) {
                if (double.tryParse(value!) == null || double.parse(value) <= 0) {
                  return "Please enter a valid number";
                }
                return null;
              }),
              const SizedBox(
                height: 100,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: () {},
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
                height: 50,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _submit(context, Doctor doctor, setState) async {
    FocusScope.of(context).unfocus();
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

  Widget _formRowBuilder(
    String title,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
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
          child: TextFormField(
            validator: validator,
            controller: controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
