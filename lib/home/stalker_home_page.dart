import 'package:flutter/material.dart';
import 'package:stalker/map/stalker_map_page.dart';

class StalkerHomePage extends StatelessWidget {
  const StalkerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('stalker'),
      ),
      body: Center(
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
    );
  }
}
