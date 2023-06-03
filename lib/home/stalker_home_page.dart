import 'package:flutter/material.dart';
import 'package:stalker/home/add_stalk_target_form.dart';
import 'package:stalker/home/stalk_targets_widget.dart';
import 'package:stalker/home/stalker_card.dart';
import 'package:stalker/map/stalker_map_page.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const StalkerCard(),
            const StalkTargetsWidget(),
            if (addTargetForm != null) addTargetForm!,
            Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) => const StalkerMapPage(),
                      ),
                    );
                  },
                  child: const Text('Go to map')),
            ),
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
