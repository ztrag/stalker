import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stalker/profile/edit_profile_page.dart';

class StalkerCard extends StatefulWidget {
  const StalkerCard({Key? key}) : super(key: key);

  @override
  State<StalkerCard> createState() => _StalkerCardState();
}

class _StalkerCardState extends State<StalkerCard> {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(4),
        color: Colors.pink,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (c) => const EditProfilePage()),
                    );
                  },
                  child: Image(
                    image: const NetworkImage(''),
                    errorBuilder: (c, _, __) =>
                        const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
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
                  ),
                ),
              ),
              Switch(value: true, onChanged: (v) {}),
            ],
          ),
        ),
      ),
    );
  }
}
