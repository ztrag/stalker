import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stalker/profile/profile_picture_submitter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(onPressed: _onEditDone, icon: const Icon(Icons.done))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: TextButton(
                    onPressed: _pickImage,
                    child: pickedImage == null
                        ? const Icon(Icons.image)
                        : Image.file(File(pickedImage!.path)),
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
            Divider(),
            const SizedBox(height: 8),
            ListTile(
              title: Text('Position'),
              subtitle: Text('Enabled users will be able to stalk me.'),
              trailing: Switch(value: true, onChanged: (v) {}),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text('Token'),
              subtitle: Text(
                  'snatoehu snathoe usnthao esunthsaoetuh sntaohesuthasoe uth.'),
              trailing: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  print('share');
                },
              ),
            ),
          ],
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
    setState(() {
      pickedImage = image;
    });
  }

  void _onEditDone() {
    print('onEditDone');
    _maybeSubmitImage();
    _maybeSubmitName();
    Navigator.of(context).pop();
  }

  Future<void> _maybeSubmitImage() async {
    if (pickedImage == null) {
      return;
    }
    await ProfilePictureSubmitter().submitFile(File(pickedImage!.path));
  }

  Future<void> _maybeSubmitName() async {
    // Check if name is different from current in db.
    // Store new name in db.
    // Submit new name to firebase.
  }
}
