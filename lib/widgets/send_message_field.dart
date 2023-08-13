import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class SendMessageField extends StatefulWidget {
  final String appointmentId;
  final bool hasPassed;
  const SendMessageField(
    this.appointmentId, {
    this.hasPassed = false,
    Key? key,
  }) : super(key: key);

  @override
  State<SendMessageField> createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  bool _isLoading = false, _isLoadingFile = false;
  String _enteredMessage = '';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    // FocusScope.of(context).unfocus();
    _controller.clear();
    _enteredMessage.trim();
    // print(_enteredMessage);
    // print('users/${widget.currId}/chats/${widget.personId}');
    setState(() {
      _isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('appointments/${widget.appointmentId}/messages')
        .add({
      'type': 'text',
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'createdBy': FirebaseAuth.instance.currentUser!.uid,
    });

    setState(() {
      _isLoading = false;
    });
    // await FirebaseFirestore.instance
    //     .collection('users/${widget.personId}/chats')
    //     .doc('${widget.currId}')
    //     .set({'data': 'data'});

    // await FirebaseFirestore.instance
    //     .collection('users/${widget.personId}/chats/${widget.currId}/messages')
    //     .add({
    //   'text': _enteredMessage,
    //   'createdAt': Timestamp.now(),
    //   'creatorId': widget.currId,
    // });
  }

  Future _sendFile() async {
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

      // print('Picked file ${file.name}');

      await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Send File'),
            content: Text(file.name),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  return;
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  setState(() {
                    _isLoadingFile = true;
                  });

                  final ref = FirebaseStorage.instance.ref().child('chatDocuments').child(
                      '${DateTime.now().toString()}${FirebaseAuth.instance.currentUser!.uid}');
                  await ref.putFile(File(file.path!));
                  final url = await ref.getDownloadURL();

                  print('UPLOADED $url');

                  await FirebaseFirestore.instance
                      .collection('appointments/${widget.appointmentId}/messages')
                      .add({
                    'type': 'file',
                    'title': file.name,
                    'text': url,
                    'createdAt': Timestamp.now(),
                    'createdBy': FirebaseAuth.instance.currentUser!.uid,
                  });

                  setState(() {
                    _isLoadingFile = false;
                  });
                },
                child: const Text('Send'),
              ),
            ],
          );
        },
      );
    } else {
      // User cancelled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.hasPassed
        ? Container(
            height: 45,
            padding: const EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.secondary,
            child: FittedBox(
              child: Text(
                'You can only chat within 48 hours of your last appointment',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary, fontStyle: FontStyle.italic),
              ),
            ),
          )
        : ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: TextField(
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
              controller: _controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintText: 'Type a message',
                  // labelText: 'Type a message',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
            ),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              _isLoadingFile
                  ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator())
                  : IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(),
                      onPressed: _sendFile,
                      icon: const Icon(
                        Icons.attach_file_rounded,
                        size: 25,
                      ),
                    ),
              const SizedBox(
                width: 5,
              ),
              _isLoading
                  ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator())
                  : IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(),
                      onPressed: _controller.text.trim().isEmpty ? () {} : _submit,
                      icon: const Icon(
                        Icons.send,
                        size: 29,
                      ),
                    ),
            ]),
          );
  }
}
