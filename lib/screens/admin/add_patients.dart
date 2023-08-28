import 'package:flutter/material.dart';

class AddPatients extends StatefulWidget {
  static const routName="/add-patient";
  const AddPatients({super.key});

  @override
  State<AddPatients> createState() => _AddPatientsState();
}

class _AddPatientsState extends State<AddPatients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Patient"),centerTitle: true,),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text("Add Patients Form"),
        ),
        ),
    );
  }
}