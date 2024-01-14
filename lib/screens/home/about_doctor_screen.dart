import 'package:flutter/material.dart';

class AboutDoctor extends StatelessWidget {
  const AboutDoctor(
      {required this.name, required this.image, required this.description, super.key});
  final String name;
  final String image;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(image),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(description, style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
        ));
  }
}
