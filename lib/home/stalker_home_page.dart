import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stalker/map/stalker_map_page.dart';

class StalkerHomePage extends StatefulWidget {
  const StalkerHomePage({Key? key}) : super(key: key);

  @override
  State<StalkerHomePage> createState() => _StalkerHomePageState();
}

class _StalkerHomePageState extends State<StalkerHomePage> {
  String? token;

  @override
  void initState() {
    super.initState();
    _fetchToken().then((v) => setState(() => token = v));
  }

  Future<String?> _fetchToken() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    return FirebaseMessaging.instance.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('stalker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(4),
              color: Colors.pink,
              child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {
                    if (token != null) {
                      Share.share(token!);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      token ?? '...',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  )),
            ),
          ),
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
    );
  }
}
