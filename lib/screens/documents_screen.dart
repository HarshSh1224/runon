import 'package:flutter/material.dart';

class AllDocumentsScreen extends StatelessWidget {
  static const routeName = '/documents-screen';
  const AllDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
          ),
          children: [
            Card(
              elevation: 0,
              color: Colors.grey.withOpacity(0.3),
            ),
            Card(
              elevation: 0,
              color: Colors.grey.withOpacity(0.3),
            ),
            Card(
              elevation: 0,
              color: Colors.grey.withOpacity(0.3),
            ),
            Card(
              elevation: 0,
              color: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
