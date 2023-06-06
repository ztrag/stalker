import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';

class AddUserForm extends StatefulWidget {
  final VoidCallback onDone;

  const AddUserForm({Key? key, required this.onDone}) : super(key: key);

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final TextEditingController _token = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: _token,
                  decoration: const InputDecoration(label: Text('Token')),
                  onFieldSubmitted: (_) => _addUser(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addUser() async {
    if (_token.text.isEmpty) {
      widget.onDone();
      return;
    }

    final user = User();
    user.token = _token.text;
    user.didAttemptDownload = false;
    user.hasLocalIcon = false;

    final db = await Db.db;
    await db.writeTxn(() => db.users.put(user));
    widget.onDone();

    final nameRef = FirebaseStorage.instance.ref('${user.token.hashCode}-n');
    final nameData = await nameRef.getData();
    if (nameData != null) {
      await db.writeTxn(() async {
        final saved = await db.users.get(user.id);
        saved!.name = String.fromCharCodes(nameData);
        return db.users.put(saved);
      });
    }
  }
}
