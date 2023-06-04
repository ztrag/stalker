import 'package:flutter/material.dart';
import 'package:stalker/home/add_stalk_target_form.dart';
import 'package:stalker/home/stalk_targets_widget.dart';
import 'package:stalker/home/stalker_card.dart';

class StalkerHomePage extends StatefulWidget {
  const StalkerHomePage({Key? key}) : super(key: key);

  @override
  State<StalkerHomePage> createState() => _StalkerHomePageState();
}

class _StalkerHomePageState extends State<StalkerHomePage> {
  Widget? addTargetForm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('stalker'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const StalkerCard(),
            const StalkTargetsWidget(),
            if (addTargetForm != null) addTargetForm!,
          ],
        ),
      ),
      floatingActionButton: addTargetForm != null
          ? null
          : FloatingActionButton(
              onPressed: () {
                _launchAddTargetForm();
              },
              child: const Icon(Icons.remove_red_eye_outlined),
            ),
    );
  }

  void _launchAddTargetForm() {
    setState(() {
      addTargetForm = AddStalkTargetForm(
        onDone: () {
          setState(() {
            addTargetForm = null;
          });
        },
      );
    });
  }
}
