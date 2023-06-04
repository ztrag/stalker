import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/stalk_target.dart';
import 'package:stalker/home/stalk_target_card.dart';

class StalkTargetsWidget extends StatefulWidget {
  const StalkTargetsWidget({Key? key}) : super(key: key);

  @override
  State<StalkTargetsWidget> createState() => _StalkTargetsWidgetState();
}

class _StalkTargetsWidgetState extends State<StalkTargetsWidget> {
  List<StalkTarget> targets = [];

  @override
  void initState() {
    super.initState();
    _fetchTargets();
  }

  void _fetchTargets() async {
    final db = await Db.db;
    final query = db.stalkTargets.where();
    final initial = await query.findAll();
    setState(() {
      targets = initial;
    });
    query.watch().listen((event) {
      setState(() {
        targets = event;
      });
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
        itemBuilder: (context, index) => StalkTargetCard(
          stalkTarget: targets[index],
        ),
      ),
    );
  }
}
