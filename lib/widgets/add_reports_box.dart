import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class AddReportsBox extends StatelessWidget {
  const AddReportsBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: DottedBorder(
          color: Theme.of(context).colorScheme.outline,
          strokeCap: StrokeCap.round,
          radius: Radius.circular(30),
          strokeWidth: 2,
          borderType: BorderType.RRect,
          dashPattern: const [7, 5, 7, 5],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              // height: 160,
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.1),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        size: 60,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                          'Upload previous reports\nor prescriptions (if any)'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Add Reports'),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
