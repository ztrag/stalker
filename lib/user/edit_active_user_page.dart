import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/user_icon_provider.dart';
import 'package:stalker/user/user_icon_widget.dart';

class EditActiveUserPage extends StatefulWidget {
  const EditActiveUserPage({Key? key}) : super(key: key);

  @override
  State<EditActiveUserPage> createState() => _EditActiveUserPageState();
}

class _EditActiveUserPageState extends State<EditActiveUserPage> {
  final TextEditingController nameController = TextEditingController();
  XFile? pickedImage;
  Uint8List? pickedImageData;
  String? token;
  User editUser = ActiveUser().value ?? User();

  @override
  void initState() {
    super.initState();
    _fetchToken();
    if (ActiveUser().value == null) {
      editUser.hasLocalIcon = false;
      editUser.didAttemptDownload = true;
    }
    nameController.text = editUser.name ?? '';
  }

  void _fetchToken() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    token = await FirebaseMessaging.instance.getToken();

    if (editUser.token != token) {
      editUser.token = token;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: _onEditDone, icon: const Icon(Icons.done))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: InkWell(
                      onTap: _pickImage,
                      child: pickedImageData == null
                          ? UserIconWidget(
                              user: editUser,
                              errorWidget: const Icon(Icons.image_outlined),
                            )
                          : Image.memory(pickedImageData!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(label: Text('Name')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Position'),
                subtitle: Text(
                  'Enabled users will be able to stalk me.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Switch(value: true, onChanged: (v) {}),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => Share.share(editUser.token!),
                child: ListTile(
                  title: const Text('Token'),
                  subtitle: Text(
                    editUser.token ?? 'null',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.share),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 200,
      maxHeight: 200,
    );
    if (image == null) {
      return;
    }

    pickedImage = image;
    pickedImageData = await image.readAsBytes();
    setState(() {});
  }

  void _onEditDone() {
    _maybeSubmitName();
    _maybeSubmitImage();

    Navigator.of(context).maybePop();
  }

  Future<void> _maybeSubmitImage() async {
    if (pickedImage == null) {
      return;
    }
    final file = File(pickedImage!.path);
    final saved = await file.rename((await editUser.iconPath)!);

    editUser.hasLocalIcon = true;

    final db = await Db.db;
    db.writeTxn(() => db.users.put(editUser));

    UserIconProvider().store(editUser, pickedImageData!);

    final ref =
        FirebaseStorage.instance.ref('${ActiveUser().value!.token!.hashCode}');
    await ref.putFile(saved);
  }

  Future<void> _maybeSubmitName() async {
    final name = nameController.text.trim();

    if (editUser.name == name) {
      return;
    }

    editUser.name = name;

    final db = await Db.db;
    db.writeTxn(() => db.users.put(editUser));

    final ref = FirebaseStorage.instance
        .ref('${ActiveUser().value!.token!.hashCode}-n');
    await ref.putString(name);
  }
}
