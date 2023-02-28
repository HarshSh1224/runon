import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';

class AddReportsBox extends StatefulWidget {
  const AddReportsBox({
    super.key,
  });

  @override
  State<AddReportsBox> createState() => _AddReportsBoxState();
}

class _AddReportsBoxState extends State<AddReportsBox> {
  List<PlatformFile> _files = [];

  void _filePicker() async {
    if (_files.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('Maximum 3 attachments allowed'),
      )));
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'pdf',
        'doc',
        'docx',
        'png',
      ],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _files.add(file);
      });

      print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _files.isEmpty ? _filePicker : null,
        child: DottedBorder(
          color: Theme.of(context).colorScheme.outline,
          strokeCap: StrokeCap.round,
          radius: const Radius.circular(30),
          strokeWidth: 2,
          borderType: BorderType.RRect,
          dashPattern: const [7, 5, 7, 5],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              // height: 160,
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.1),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  _files.isNotEmpty
                      ? Column(
                          children: [
                            ..._files.map((e) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 1)),
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          e.extension == 'jpg' ||
                                                  e.extension == 'png' ||
                                                  e.extension == 'jpeg'
                                              ? Icons.image
                                              : Icons.file_present_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          child: Text(
                                            e.name,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned.fill(
                                      child: Transform.translate(
                                        offset: const Offset(7, 0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () {
                                                setState(() {
                                                  _files.removeWhere(
                                                      (element) =>
                                                          element.name ==
                                                          e.name);
                                                });
                                              },
                                              icon: const Icon(Icons.close)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_upload_outlined,
                              size: 60,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                                'Upload previous reports\nor prescriptions (if any)'),
                          ],
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                      onPressed: _filePicker,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
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
