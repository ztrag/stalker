import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stalker/alien/alien_encription.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/token_text.dart';
import 'package:stalker/user/user_enabled_switch.dart';
import 'package:stalker/user/user_icon_picker.dart';
import 'package:stalker/user/user_icon_provider.dart';
import 'package:stalker/user/user_icon_widget.dart';

class EditActiveUserPage extends StatefulWidget {
  const EditActiveUserPage({Key? key}) : super(key: key);

  @override
  State<EditActiveUserPage> createState() => _EditActiveUserPageState();
}

class _EditActiveUserPageState extends State<EditActiveUserPage> {
  final TextEditingController nameController = TextEditingController();
  final UserIconPicker userIconPicker = UserIconPicker();

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

  @override
  void dispose() {
    userIconPicker.dispose();
    nameController.dispose();
    super.dispose();
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
              SizedBox(
                height: kUserIconSize,
                child: Row(
                  children: [
                    SizedBox(
                      width: kUserIconSize,
                      child: InkWell(
                        onTap: userIconPicker.pick,
                        child: ValueListenableBuilder<Uint8List?>(
                          valueListenable: userIconPicker,
                          builder: (_, __, ___) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: UserIconWidget(
                              user: editUser,
                              errorWidget: const Icon(Icons.image_outlined),
                              image: userIconPicker.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'John Doe',
                          contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: _toggleEnabled,
                child: ListTile(
                  title: const Text('Location Sharing'),
                  subtitle: Text(
                    'Allow enabled contacts to stalk me.',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  trailing: ActiveUser().value == null
                      ? null
                      : UserEnabledSwitch(
                          user: editUser,
                          onValueChanged: (v) => editUser.isEnabled = v,
                        ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => Share.share(editUser.token!.encrypt),
                child: ListTile(
                  title: const Text('Token'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exchange with a friend to establish contact.',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TokenText(user: editUser),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
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

  void _onEditDone() {
    _maybeSubmitName();
    _maybeSubmitImage();

    Navigator.of(context).maybePop();
  }

  Future<void> _maybeSubmitImage() async {
    final icon = userIconPicker.value;
    if (icon == null) {
      return;
    }

    final filepath = await editUser.getIconPath(UserIconSize.original);
    final saved = await File(filepath).writeAsBytes(icon);
    for (final size in UserIconSize.values) {
      if (size != UserIconSize.original) {
        File(await editUser.getIconPath(size)).delete();
      }
    }
    editUser.hasLocalIcon = true;

    final db = await Db.db;
    db.writeTxn(() => db.users.put(editUser));

    UserIconProvider().cache(editUser, icon);

    final ref = FirebaseStorage.instance.ref('${editUser.token!.hashCode}');
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

    final ref = FirebaseStorage.instance.ref('${editUser.token!.hashCode}-n');
    await ref.putString(name);
  }

  void _toggleEnabled([bool? v]) async {
    if (ActiveUser().value == null) {
      return;
    }

    editUser.isEnabled = v ?? !editUser.isEnabled;
    setState(() {});

    UserEnabledSwitch.toggleInDb(editUser, editUser.isEnabled);
  }
}
