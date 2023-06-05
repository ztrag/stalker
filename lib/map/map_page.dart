import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalker/domain/stalk_target.dart';
import 'package:stalker/stalk/stalk_machine_widget.dart';

class MapPage extends StatelessWidget {
  final StalkTarget stalkTarget;

  const MapPage({Key? key, required this.stalkTarget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StalkMachineWidget(
      stalkTarget: stalkTarget,
      child: Scaffold(
        appBar: AppBar(
          title: Text('stalking ${stalkTarget.name ?? ''}'),
        ),
        body: Platform.isIOS
            ? Container()
            : const GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(45.5312571, -122.6984473),
                  zoom: 14,
                ),
              ),
      ),
    );
  }
}
