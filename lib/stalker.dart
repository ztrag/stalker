import 'package:flutter/material.dart';
import 'package:stalker/home/stalker_home_page.dart';

class Stalker extends StatelessWidget {
  const Stalker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'stalker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const StalkerHomePage(),
    );
  }
}
