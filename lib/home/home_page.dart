import 'package:flutter/material.dart';
import 'package:stalker/home/add_user_form.dart';
import 'package:stalker/user/users_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? addUserForm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('stalker'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const UsersListWidget(),
            if (addUserForm != null) addUserForm!,
          ],
        ),
      ),
      floatingActionButton: addUserForm != null
          ? null
          : FloatingActionButton(
              onPressed: () {
                _launchAddUserForm();
              },
              child: const Icon(Icons.person_add),
            ),
    );
  }

  void _launchAddUserForm() {
    setState(() {
      addUserForm = AddUserForm(
        onDone: () {
          setState(() {
            addUserForm = null;
          });
        },
      );
    });
  }
}
