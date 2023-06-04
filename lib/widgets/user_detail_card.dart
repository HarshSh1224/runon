import 'dart:io';
import 'package:flutter/material.dart';
import 'package:runon/providers/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:runon/widgets/edit_profile_bottom_sheet.dart';
import 'package:flutter/services.dart';

class UserDetailCard extends StatelessWidget {
  UserDetailCard({
    super.key,
    required this.user,
  });

  File? _pickedImage;
  XFile? _xPickedImage;
  CroppedFile? _croppedImage;

  bool _isCopied = false;

  Future<void> _cropImage(filePath) async {
    _croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
  }

  void _pickkImage(ImageSource source, setState, context) async {
    _xPickedImage = await ImagePicker().pickImage(source: source, imageQuality: 10);

    if (_xPickedImage == null) {
      _pickedImage = null;
      return;
    }

    await _cropImage(_xPickedImage!.path);

    setState(() {
      _pickedImage = _croppedImage != null ? File(_croppedImage!.path) : null;
      print('PICKED ${_xPickedImage?.path}');
    });
    // widget.getProfilePic(_pickedImage);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(padding: EdgeInsets.all(10.0), child: Text('Uploading image...'))));
    try {
      if (_pickedImage != null) {
        await user.updateProfileImage(_pickedImage!);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Padding(padding: EdgeInsets.all(10.0), child: Text('Success'))));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(padding: const EdgeInsets.all(10.0), child: Text(error.toString()))));
    }
  }

  final Auth user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(builder: (context, setState) {
                    return InkWell(
                      onTap: () async {
                        int sourceChoice = -1;
                        await showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                            ),
                            context: context,
                            builder: (_) {
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                        width: 33,
                                        height: 4,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      'Pick image from:',
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                                          fontSize: 17,
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: () {
                                                  sourceChoice = 0;
                                                  Navigator.of(context).pop();
                                                },
                                                child: imageSourceChoiceBuilder(context, 0))),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              sourceChoice = 1;
                                              Navigator.of(context).pop();
                                            },
                                            child: imageSourceChoiceBuilder(
                                              context,
                                              1,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                        if (sourceChoice != -1) {
                          _pickkImage(sourceChoice == 0 ? ImageSource.camera : ImageSource.gallery,
                              setState, context);
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage: _pickedImage == null
                            ? Image.network(user.imageUrl!).image
                            : Image.file(
                                _pickedImage!,
                                fit: BoxFit.cover,
                              ).image,
                        radius: 40,
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${user.fName} ${user.lName}',
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${user.age}y',
                        // '',
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    user.email!,
                    style: GoogleFonts.raleway(
                        // fontSize: 18,
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Id : ${user.userId!}',
                        style: GoogleFonts.inconsolata(
                          fontSize: 13,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isCopied = true;
                            });
                            await Clipboard.setData(ClipboardData(text: user.userId));
                            await Future.delayed(const Duration(seconds: 1));
                            setState(() {
                              _isCopied = false;
                            });
                          },
                          child: Icon(
                            _isCopied ? Icons.done : Icons.copy,
                            size: 17,
                            color: _isCopied ? Colors.green : null,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                              ),
                              isScrollControlled: true,
                              context: context,
                              builder: (_) {
                                return const EditBottomSheet();
                              });
                        },
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}

Container imageSourceChoiceBuilder(BuildContext context, int choice) {
  return Container(
    decoration: BoxDecoration(
        // color: Theme.of(context)
        //     .colorScheme
        //     .onSurfaceVariant,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(10)),
    height: 80,
    width: 80,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          choice == 0 ? Icons.camera_alt : Icons.photo_library,
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          choice == 0 ? 'Camera' : 'Browse',
          style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 10),
        ),
      ],
    ),
  );
}
