import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessageField extends StatefulWidget {
  final String appointmentId;
  const SendMessageField(
    this.appointmentId,
    // this.currId,
    {
    Key? key,
  }) : super(key: key);

  @override
  State<SendMessageField> createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  bool _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
      trailing: _isLoading
          ? const SizedBox(
              height: 25, width: 25, child: CircularProgressIndicator())
          : IconButton(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(),
              onPressed: _controller.text.trim().isEmpty ? null : _submit,
              icon: const Icon(
                Icons.send,
                size: 29,
              ),
            ),
    );
  }
}
