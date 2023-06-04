import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalker/domain/stalk_target.dart';

class StalkerMapPage extends StatefulWidget {
  final StalkTarget stalkTarget;

  const StalkerMapPage({Key? key, required this.stalkTarget}) : super(key: key);

  @override
  State<StalkerMapPage> createState() => _StalkerMapPageState();
}

class _StalkerMapPageState extends State<StalkerMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('stalking ${widget.stalkTarget.name ?? ''}'),
      ),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(45.5312571, -122.6984473),
          zoom: 14,
        ),
      ),
    );
  }
}
