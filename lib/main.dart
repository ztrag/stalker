import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stalker/stalker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Stalker());
}
