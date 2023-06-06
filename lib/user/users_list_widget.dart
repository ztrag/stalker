import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/user/stalker_card.dart';
import 'package:stalker/user/user_card.dart';

class UsersListWidget extends StatefulWidget {
  const UsersListWidget({Key? key}) : super(key: key);

  @override
  State<UsersListWidget> createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends State<UsersListWidget> {
  List<User> targets = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final db = await Db.db;
    final query = db.users.where();
    final initial = await query.findAll();
    setState(() {
      targets = initial;
    });
    query.watch().listen((event) {
      targets = event;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (targets.isEmpty) {
      return Container();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: targets.length,
        padding: const EdgeInsets.only(bottom: 70),
        itemBuilder: (context, index) =>
            index == 0 ? const StalkerCard() : UserCard(user: targets[index]),
      ),
    );
  }
}
