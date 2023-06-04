import 'package:flutter/material.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/stalk_target.dart';

class AddStalkTargetForm extends StatefulWidget {
  final VoidCallback onDone;

  const AddStalkTargetForm({Key? key, required this.onDone}) : super(key: key);

  @override
  State<AddStalkTargetForm> createState() => _AddStalkTargetFormState();
}

class _AddStalkTargetFormState extends State<AddStalkTargetForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _profilePictureUrl = TextEditingController();
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
              children: [
                const SizedBox(height: 4),
                const Text(
                  'Add a new contact',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _name,
                  autofocus: true,
                  decoration: const InputDecoration(label: Text('Name')),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _profilePictureUrl,
                  decoration:
                      const InputDecoration(label: Text('Profile Picture Url')),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _token,
                  decoration: const InputDecoration(label: Text('Token')),
                  onFieldSubmitted: (_) => _insertTarget(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _insertTarget();
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _insertTarget() async {
    final target = StalkTarget();
    target.name = _name.text;
    target.profilePictureUrl = _profilePictureUrl.text;
    target.token = _token.text;

    final db = await Db.db;
    await db.writeTxn(() => db.stalkTargets.put(target));
    widget.onDone();
  }
}
